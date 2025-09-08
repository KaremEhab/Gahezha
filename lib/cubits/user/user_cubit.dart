import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gahezha/constants/cache_helper.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/authentication/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit._privateConstructor() : super(UserInitial());

  static final UserCubit _instance = UserCubit._privateConstructor();

  factory UserCubit() => _instance;

  static UserCubit get instance => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Get current logged-in user
  Future<void> getCurrentUser() async {
    try {
      emit(UserLoading());

      final user = _auth.currentUser;
      if (user == null) {
        emit(UserError("No user logged in"));
        return;
      }

      final doc = await _firestore.collection("users").doc(user.uid).get();

      if (!doc.exists) {
        emit(UserError("User not found in database"));
        return;
      }

      currentUserModel = UserModel.fromMap(doc.data()!);

      currentUserType = currentUserModel!.userType;
      CacheHelper.saveData(key: "currentUserType", value: currentUserType.name);

      await CacheHelper.saveData(
        key: 'currentUserModel',
        value: currentUserModel!.toMap(),
      );

      log(currentUserModel!.toMap().toString());

      emit(UserLoaded(currentUserModel!));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  /// ✅ Get all users
  Future<void> getAllUsers() async {
    try {
      emit(UserLoading());

      final querySnapshot = await _firestore.collection("users").get();

      final users = querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();

      emit(UsersLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  /// ✅ Get guest user by ID
  Future<void> getGuestById(String guestId) async {
    try {
      emit(UserLoading());

      final doc = await _firestore.collection("guests").doc(guestId).get();

      if (!doc.exists) {
        emit(UserError("Guest not found"));
        return;
      }

      currentGuestModel = GuestUserModel.fromMap(doc.data()!);
      await CacheHelper.saveData(
        key: 'GuestUserModel',
        value: currentGuestModel!.toMap(),
      );
      emit(GuestLoaded(currentGuestModel!));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> editUserData({
    String? profileUrl,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    Gender? gender,
    bool? notificationsEnabled,
    UserType? userType,
    bool silentUpdate = true, // ✅ جديد: يمنع emit لو true
  }) async {
    try {
      if (uId == null) {
        if (!silentUpdate) emit(UserUpdatingError("No user logged in"));
        return;
      }

      final Map<String, dynamic> updatedData = {};

      if (profileUrl != null) updatedData['profileUrl'] = profileUrl;
      if (firstName != null) updatedData['firstName'] = firstName;
      if (lastName != null) updatedData['lastName'] = lastName;
      if (email != null) updatedData['email'] = email;
      if (phoneNumber != null) updatedData['phoneNumber'] = phoneNumber;
      if (gender != null) updatedData['gender'] = gender.name;
      if (notificationsEnabled != null) {
        updatedData['notificationsEnabled'] = notificationsEnabled;
      }
      if (userType != null) updatedData['userType'] = userType.name;

      if (updatedData.isEmpty) {
        if (!silentUpdate) emit(UserUpdatingError("No fields to update"));
        return;
      }

      // ✅ Update Firestore
      await _firestore.collection("users").doc(uId).update(updatedData);

      // ✅ Update local model
      currentUserModel = currentUserModel!.copyWith(
        profileUrl: profileUrl,
        firstName: firstName,
        lastName: lastName,
        email: email,
        gender: gender,
        phoneNumber: phoneNumber,
        notificationsEnabled: notificationsEnabled,
        userType: userType,
      );

      // ✅ Save to cache
      await CacheHelper.saveData(
        key: 'currentUserModel',
        value: currentUserModel!.toMap(),
      );

      currentUserType = currentUserModel!.userType;
      CacheHelper.saveData(key: "currentUserType", value: currentUserType.name);

      // 🔄 Emit فقط لو التحديث مش silent
      if (!silentUpdate) {
        emit(UserUpdated(currentUserModel!));
      }
    } catch (e) {
      if (!silentUpdate) emit(UserUpdatingError(e.toString()));
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      log("Picked image path: ${pickedFile.path}");

      try {
        final dio = Dio();

        // مثال باستخدام ImgBB API (مجانًا حتى 32MB للصورة)
        const apiKey = "YOUR_IMGBB_API_KEY"; // سجل من imgbb.com
        final formData = FormData.fromMap({
          "image": await MultipartFile.fromFile(pickedFile.path),
        });

        final response = await dio.post(
          "https://api.imgbb.com/1/upload?key=$apiKey",
          data: formData,
        );

        if (response.statusCode == 200) {
          final uploadedUrl = response.data["data"]["url"];
          log("✅ Image uploaded: $uploadedUrl");

          // هنا بقى تحفظ الرابط في Cubit أو Firestore
          // UserCubit.instance.editUserData(profileUrl: uploadedUrl);
        } else {
          log("❌ Upload failed: ${response.statusCode}");
        }
      } catch (e) {
        log("⚠️ Error uploading image: $e");
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    final savedUid = uId;

    currentShopModel = null;
    currentUserModel = null;
    currentGuestModel = null;

    navigateAndFinish(context: context, screen: const Login());
    await GoogleSignIn().signOut(); // force account picker

    if (savedUid == null || savedUid.isEmpty) {
      log("No valid uId found, skipping FCM update");
      return;
    }

    try {
      await Future.wait([
        CacheHelper.removeData(key: 'uId'),
        CacheHelper.removeData(key: 'currentShopModel'),
        CacheHelper.removeData(key: 'currentUserModel'),
        CacheHelper.removeData(key: 'currentGuestModel'),

        // Replace all old tokens with the new one
        FirebaseFirestore.instance.collection('users').doc(savedUid).update({
          'fcmTokens': [],
        }),
      ]);

      log("Logged out successfully");
    } catch (e) {
      log('Logout error: $e');
    }
  }
}
