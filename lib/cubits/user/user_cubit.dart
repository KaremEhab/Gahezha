import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/cupertino.dart';
import 'package:gahezha/constants/cache_helper.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/report/report_cubit.dart';
import 'package:gahezha/cubits/user/user_state.dart';
import 'package:gahezha/models/shop_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/authentication/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit._privateConstructor() : super(UserInitial());

  static final UserCubit _instance = UserCubit._privateConstructor();

  factory UserCubit() => _instance;

  static UserCubit get instance => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<UserModel> allCustomers = [];

  List<UserModel> blockedCustomers = [];

  List<UserModel> reportedCustomers = [];

  List<UserModel> disabledCustomers = [];

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

  void updateReportedCustomers(List<UserModel> reportedList) {
    reportedCustomers = reportedList;
    emit(UserStateAllCustomersLoaded(allCustomers, reportedCustomers));
  }

  /// ✅ Get all shops and separate blocked/disabled
  Future<void> adminGetAllCustomers() async {
    try {
      emit(UserLoading());

      final querySnapshot = await _firestore
          .collection("users")
          .where('userType', isEqualTo: UserType.customer.name)
          .orderBy("createdAt", descending: true)
          .get();

      final users = querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), userId: doc.id))
          .toList();

      allCustomers = users;
      blockedCustomers = users.where((u) => u.blocked).toList();
      disabledCustomers = users.where((u) => u.disabled).toList();

      // 🔑 Run reports processing here
      ReportCubit.instance.processCustomerReports(
        ReportCubit.instance.allReports,
      );

      emit(UsersLoaded(allCustomers));
    } catch (e, st) {
      print("Error in adminGetAllCustomers: $e");
      print(st);
      allCustomers = [];
      blockedCustomers = [];
      disabledCustomers = [];
      reportedCustomers = [];
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
    bool silentUpdate = true,
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

      // ✅ Pick the right collection
      final collectionName = (currentUserType == UserType.admin)
          ? "admins"
          : "users";

      await _firestore.collection(collectionName).doc(uId).update(updatedData);

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

      if (!silentUpdate) {
        emit(UserUpdated(currentUserModel!));
      }
    } catch (e) {
      if (!silentUpdate) emit(UserUpdatingError(e.toString()));
    }
  }

  /// ✅ Change Email (supports customer, guest, and admin)
  Future<void> changeEmail({
    required String oldEmail,
    required String newEmail,
    required String password,
  }) async {
    try {
      emit(UserUpdating());

      if (uId == null) {
        emit(UserUpdatingError("No user logged in"));
        return;
      }

      // ✅ Pick the right collection
      final collectionName = (currentUserType == UserType.admin)
          ? "admins"
          : "users";

      // ✅ If not guest, reauthenticate + update Firebase Auth email
      if (currentUserModel?.userType != UserType.guest) {
        final fb.User? user = _auth.currentUser;
        if (user == null) {
          emit(UserUpdatingError("Firebase user not found"));
          return;
        }

        // Reauthenticate first
        final cred = fb.EmailAuthProvider.credential(
          email: oldEmail,
          password: password,
        );
        await user.reauthenticateWithCredential(cred);

        // ✅ Send verification before updating email
        await user.verifyBeforeUpdateEmail(newEmail);

        // Reload to refresh user data
        await user.reload();
      }

      // ✅ Update Firestore
      await _firestore.collection(collectionName).doc(uId).update({
        "email": newEmail,
      });

      // ✅ Update local model
      currentUserModel = currentUserModel?.copyWith(email: newEmail);

      await CacheHelper.saveData(
        key: "currentUserModel",
        value: currentUserModel?.toMap(),
      );

      emit(UserUpdated(currentUserModel!));

      log(
        "✅ Verification email sent. Email will update once verified: $newEmail",
      );
    } catch (e) {
      emit(UserUpdatingError(e.toString()));
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

  String generateReferralLink(String userId) {
    // Use your working deep link host
    return "https://deep-link-hosting.vercel.app/create-shop?ref=$userId";
  }

  void shareReferral(String userId) {
    final link = generateReferralLink(userId);
    Share.share("Join Gahezha and open your shop: $link");
  }

  Future<void> logout(BuildContext context) async {
    final savedUid = uId;

    showProfileDetails = false;

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

        // ✅ Replace all old tokens with the new one
        FirebaseFirestore.instance
            .collection(currentUserType == UserType.shop ? 'shops' : 'users')
            .doc(savedUid)
            .update({'fcmTokens': []}),
      ]);

      log("Logged out successfully");
    } catch (e) {
      log('Logout error: $e');
    }
  }
}
