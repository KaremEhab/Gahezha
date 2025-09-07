import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/cache_helper.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/authentication/signup.dart';
import 'package:gahezha/screens/layout/layout.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit._privateConstructor() : super(LoginInitial());

  static final LoginCubit _instance = LoginCubit._privateConstructor();

  factory LoginCubit() => _instance;

  static LoginCubit get instance => _instance;

  void userLogin({required String email, required String password}) async {
    try {
      emit(LoginLoadingState());
      var userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      uId = userCredential.user!.uid;
      var user = await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .get();
      if (!user.exists) {
        throw 'الحساب غير موجود';
      }
      await Future.wait([
        // 👇 Replace all old tokens with the new one
        FirebaseFirestore.instance.collection('users').doc(uId).update({
          'fcmTokens': [fcmDeviceToken],
        }),
        CacheHelper.saveData(key: 'uId', value: uId),
      ]);
      emit(LoginSuccessState(uId));
    } catch (error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          emit(LoginErrorState(error: 'un registered account'));
        } else if (error.code == 'wrong-password') {
          emit(LoginErrorState(error: 'wrong password'));
        } else {
          emit(LoginErrorState(error: 'something went wrong'));
        }
      } else {
        emit(LoginErrorState(error: 'An error occurred: $error'));
      }
    }
  }

  /// ================= Create/Login Guest =================
  Future<GuestUserModel> loginAsGuest() async {
    // Generate a unique guest ID
    final guestId = const Uuid().v4();

    // Get FCM token
    final fcmToken = await FirebaseMessaging.instance.getToken();

    // Create guest user
    final guest = GuestUserModel(guestId: guestId, createdAt: DateTime.now());

    // Save to Firestore
    await FirebaseFirestore.instance.collection('users').doc(guestId).set({
      ...guest.toMap(),
      'fcmTokens': [fcmToken],
    });

    // Cache guest ID locally
    await CacheHelper.saveData(key: 'uId', value: guestId);
    await CacheHelper.saveData(key: 'isGuest', value: true);

    return guest;
  }

  /// ================= Delete Guest Account =================
  Future<void> deleteGuestAccount(String guestId) async {
    try {
      // Remove Firestore document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(guestId)
          .delete();

      // Clear cached data
      await CacheHelper.removeData(key: 'uId');
      await CacheHelper.removeData(key: 'isGuest');
    } catch (e) {
      throw Exception("Failed to delete guest account: $e");
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> googleSignIn(BuildContext context) async {
    emit(SignInWithGoogleLoadingState());
    UserCredential userCredential = await signInWithGoogle();
    try {
      if (userCredential.user != null) {
        uId = userCredential.user!.uid;
        String username =
            userCredential.user!.displayName ??
            userCredential.user!.email ??
            'Anonymous';
        DocumentSnapshot<Map<String, dynamic>>? value = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(uId)
            .get();
        if (!context.mounted) return;
        if (!value.exists) {
          navigateAndFinish(context: context, screen: Signup());
        } else {
          await Future.wait([
            FirebaseFirestore.instance.collection('users').doc(uId).update({
              'fcmTokens': [fcmDeviceToken],
            }),
            CacheHelper.saveData(key: 'uId', value: uId),
          ]);
          emit(SignInWithGoogleSuccessState());
          if (!context.mounted) return;
          navigateAndFinish(context: context, screen: const Layout());
        }
      }
    } catch (error) {
      emit(SignInWithGoogleErrorState(error: 'something went wrong: $error'));
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider(
      "apple.com",
    ).credential(idToken: appleCredential.identityToken, rawNonce: rawNonce);

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  Future<void> appleSignIn(BuildContext context) async {
    emit(SignInWithAppleLoadingState());
    UserCredential userCredential = await signInWithApple();
    try {
      if (userCredential.user != null) {
        uId = userCredential.user!.uid;
        String username = userCredential.user!.displayName.toString();
        DocumentSnapshot<Map<String, dynamic>>? value = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(uId)
            .get();
        if (!context.mounted) return;
        if (value.exists) {
          await Future.wait([
            FirebaseFirestore.instance.collection('users').doc(uId).update({
              'fcmTokens': [fcmDeviceToken],
            }),
            CacheHelper.saveData(key: 'uId', value: uId),
          ]);
          emit(SignInWithAppleSuccessState());
          if (!context.mounted) return;
          navigateAndFinish(context: context, screen: const Layout());
        }
      }
    } catch (error) {
      emit(SignInWithAppleErrorState(error: 'something went wrong: $error'));
    }
  }

  void forgetPassword({required String email}) async {
    try {
      emit(LoginForgetPasswordLoadingState());
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(LoginForgetPasswordSuccessState());
    } catch (error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          emit(
            LoginForgetPasswordErrorState(
              error: 'هذا البريد الالكتروني غير مسجل',
            ),
          );
        } else {
          emit(
            LoginForgetPasswordErrorState(error: 'حدث خطأ ما,حاول مره اخري'),
          );
        }
      } else {
        emit(LoginForgetPasswordErrorState(error: 'An error occurred: $error'));
      }
    }
  }
}
