import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/cache_helper.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/shop/shop_cubit.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/models/shop_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/authentication/signup.dart';
import 'package:gahezha/screens/layout/layout.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';
part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit._privateConstructor() : super(SignupInitialState());

  static final SignupCubit _instance = SignupCubit._privateConstructor();

  factory SignupCubit() => _instance;

  static SignupCubit get instance => _instance;

  void userSignup({
    required String email,
    required Gender gender,
    required String firstName,
    required String lastName,
    required String password,
    required String phoneNumber,
    DateTime? birthdate,
    String? emirate,
    int? age,
  }) async {
    emit(SignupLoadingState());

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user?.uid;
      if (uid == null) {
        emit(SignupErrorState(error: 'Failed to create user'));
        return;
      }

      await userCreate(
        userId: uid,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        gender: gender,
        email: email,
      );

      await CacheHelper.saveData(key: 'uId', value: uid);

      await UserCubit.instance.getCurrentUser();

      emit(SignupSuccessState(uid)); // <-- emit only AFTER Firestore succeeds
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        emit(SignupErrorState(error: 'كلمه السر ضعيفه'));
      } else if (error.code == 'email-already-in-use') {
        emit(SignupErrorState(error: 'Email already in use'));
      } else {
        emit(SignupErrorState(error: 'An error occurred, try again later'));
      }
    } catch (e) {
      emit(SignupErrorState(error: 'An error occurred: $e'));
    }
  }

  Future<void> userCreate({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required Gender gender,
  }) async {
    emit(SignupCreateUserLoadingState());

    final profileUrl = gender == Gender.male
        ? "https://res.cloudinary.com/dl0wayiab/image/upload/v1757279014/samples/man-portrait.jpg"
        : "https://res.cloudinary.com/dl0wayiab/image/upload/v1757279013/samples/outdoor-woman.jpg";

    final model = UserModel(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      gender: gender,
      profileUrl: profileUrl,
      phoneNumber: phoneNumber,
      userType: UserType.customer,
      notificationsEnabled: true,
    );

    currentUserModel = model;

    try {
      // Get FCM token for this device
      final fcmToken = await FirebaseMessaging.instance.getToken();

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        ...model.toMap(),
        'fcmTokens': [fcmToken],
      });

      await CacheHelper.saveData(key: 'uId', value: userId);
      emit(SignupCreateUserSuccessState());
    } catch (e) {
      emit(SignupCreateUserErrorState(e.toString()));
    }
  }

  /// ✅ Shop Signup
  void shopSignup({
    required String email,
    required String password,
    required String shopName,
    required String shopCategory,
    required String shopLocation,
    required int preparingTimeFrom,
    required int preparingTimeTo,
    required int openingHoursFrom,
    required int openingHoursTo,
    required String shopPhoneNumber,
    String? referredByUserId,
  }) async {
    emit(SignupLoadingState());

    try {
      // FirebaseAuth signup
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user?.uid;
      if (uid == null) {
        emit(SignupErrorState(error: 'Failed to create shop'));
        return;
      }

      await shopCreate(
        shopId: uid,
        shopName: shopName,
        shopCategory: shopCategory,
        shopLocation: shopLocation,
        preparingTimeFrom: preparingTimeFrom,
        preparingTimeTo: preparingTimeTo,
        openingHoursFrom: openingHoursFrom,
        openingHoursTo: openingHoursTo,
        shopPhoneNumber: shopPhoneNumber,
        shopEmail: email,
        referredByUserId: referredByUserId,
      );

      uId = uid;
      await CacheHelper.saveData(key: 'uId', value: uId);

      await ShopCubit.instance.getCurrentShop();

      emit(SignupSuccessState(uId));
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        emit(SignupErrorState(error: 'كلمه السر ضعيفه'));
      } else if (error.code == 'email-already-in-use') {
        emit(SignupErrorState(error: 'Shop Email already in use'));
      } else {
        emit(SignupErrorState(error: 'An error occurred, try again later'));
      }
    } catch (e) {
      emit(SignupErrorState(error: 'An error occurred: $e'));
    }
  }

  /// ✅ Create Shop Document in Firestore
  Future<void> shopCreate({
    required String shopId,
    required String shopName,
    required String shopCategory,
    required String shopLocation,
    required int preparingTimeFrom,
    required int preparingTimeTo,
    required int openingHoursFrom,
    required int openingHoursTo,
    required String shopPhoneNumber,
    required String shopEmail,
    String? referredByUserId,
  }) async {
    emit(SignupCreateUserLoadingState());

    final shopLogo =
        "https://res.cloudinary.com/dl0wayiab/image/upload/v1757279013/samples/breakfast.jpg";
    final shopBanner =
        "https://res.cloudinary.com/dl0wayiab/image/upload/v1757279016/cld-sample-4.jpg";

    final model = ShopModel(
      id: Uuid().v4(),
      shopName: shopName,
      shopLogo: shopLogo,
      shopBanner: shopBanner,
      shopCategory: shopCategory,
      shopLocation: shopLocation,
      preparingTimeFrom: preparingTimeFrom,
      preparingTimeTo: preparingTimeTo,
      openingHoursFrom: openingHoursFrom,
      openingHoursTo: openingHoursTo,
      shopRate: 0.0,
      shopPhoneNumber: shopPhoneNumber,
      shopEmail: shopEmail,
      shopAcceptanceStatus: ShopAcceptanceStatus.pending,
      shopStatus: false, // يبدأ مغلق مثلاً
      blocked: false, // يبدأ مغلق مثلاً
      disabled: false, // يبدأ مغلق مثلاً
      notificationsEnabled: true,
      referredByUserId: referredByUserId,
      createdAt: DateTime.now(),
    );

    try {
      // FCM token
      final fcmToken = await FirebaseMessaging.instance.getToken();

      await FirebaseFirestore.instance.collection('shops').doc(shopId).set({
        ...model.toMap(),
        'shopId': shopId,
        'fcmTokens': [fcmToken],
        'createdAt': FieldValue.serverTimestamp(),
      });

      uId = shopId;
      await CacheHelper.saveData(key: 'uId', value: uId);
      emit(SignupCreateUserSuccessState());
    } catch (e) {
      emit(SignupCreateUserErrorState(e.toString()));
    }
  }

  Future<UserCredential> signUpWithGoogle() async {
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

  Future<void> googleSignUp(BuildContext context) async {
    emit(SignUpWithGoogleLoadingState());
    UserCredential userCredential = await signUpWithGoogle();
    try {
      if (userCredential.user != null) {
        uId = userCredential.user!.uid;
        String username =
            userCredential.user!.displayName ??
            userCredential.user!.email ??
            'Guest';
        DocumentSnapshot<Map<String, dynamic>>? value = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(uId)
            .get();
        if (!context.mounted) return;
        if (!value.exists) {
          // New Google user
          await userCreate(
            userId: uId,
            firstName: userCredential.user?.displayName ?? "Guest",
            lastName: userCredential.user?.displayName ?? "Guest",
            email: userCredential.user?.email ?? "",
            phoneNumber: userCredential.user?.phoneNumber ?? "",
            gender: Gender.male,
          );
        } else {
          // Existing user: add/update FCM token
          final fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(uId)
                .update({
                  'fcmTokens': FieldValue.arrayUnion([fcmToken]),
                });
          }
        }
      }
    } catch (error) {
      emit(SignUpWithGoogleErrorState(error: 'something went wrong: $error'));
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
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

  Future<UserCredential> signUpWithApple() async {
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

  Future<void> appleSignUp(BuildContext context) async {
    emit(SignUpWithAppleLoadingState());
    UserCredential userCredential = await signUpWithApple();
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
        if (!value.exists) {
          navigateAndFinish(context: context, screen: Signup());
        } else {
          emit(SignUpWithAppleSuccessState());
          navigateAndFinish(context: context, screen: const Layout());
        }
      }
    } catch (error) {
      emit(SignUpWithAppleErrorState(error: 'something went wrong: $error'));
    }
  }
}
