import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gahezha/constants/cache_helper.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/admin/admin_state.dart';
import 'package:gahezha/cubits/shop/shop_cubit.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/models/shop_model.dart';
import 'package:gahezha/models/user_model.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit._privateConstructor() : super(AdminInitial());

  static final AdminCubit _instance = AdminCubit._privateConstructor();

  factory AdminCubit() => _instance;

  static AdminCubit get instance => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isBlocked = false;
  bool isDisabled = false;

  /// ✅ Get current logged-in Admin
  Future<void> getCurrentAdmin() async {
    try {
      emit(AdminLoading());

      final user = _auth.currentUser;
      if (user == null) {
        emit(AdminError("No Admin logged in"));
        return;
      }

      final doc = await _firestore.collection("admins").doc(user.uid).get();

      if (!doc.exists) {
        emit(AdminError("Admin not found in database"));
        return;
      }

      currentUserModel = UserModel.fromMap(doc.data()!);
      log(currentUserModel!.toMap().toString());

      emit(AdminLoaded(currentUserModel!));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  /// ✅ Get all Admins
  Future<void> getAllAdmins() async {
    try {
      emit(AdminLoading());

      final querySnapshot = await _firestore.collection("admins").get();

      final admins = querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();

      emit(AdminsLoaded(admins));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  /// Paid Commission Balance
  Future<void> paidCommission({
    required String userId,
    required double amount,
  }) async {
    try {
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId);

      final snapshot = await userDoc.get();
      if (!snapshot.exists) {
        throw Exception("User not found");
      }

      final userData = snapshot.data()!;
      final currentPaid =
          (userData['paidCommissionBalance'] as num?)?.toDouble() ?? 0;

      // ✅ نجمع القديم + الجديد
      final updatedPaid = currentPaid + amount;

      await userDoc.update({'paidCommissionBalance': updatedPaid});

      log(
        "✅ Paid commission updated for $userId "
        "from $currentPaid → $updatedPaid",
      );

      emit(AdminPaidCommissionSuccessfully(updatedPaid));
    } catch (e) {
      log("❌ Error in paidCommission: $e");
      rethrow;
    }
  }

  /// ✅ Disable a shop
  Future<void> adminDisableAccount(
    String id,
    String userType,
    bool disable,
  ) async {
    try {
      String type = userType == "customer" ? "users" : "shops";
      await _firestore.collection(type).doc(id).update({"disabled": disable});

      emit(AdminShopDisabled(id, disable));

      // Refresh lists after action
      userType == "customer"
          ? await UserCubit.instance.adminGetAllCustomers()
          : await ShopCubit.instance.adminGetAllShops();
      isDisabled = disable;
    } catch (e) {
      emit(AdminError("Failed to disable shop: $e"));
    }
  }

  /// ✅ Block a shop
  Future<void> adminBlockAccount(String id, String userType, bool block) async {
    try {
      String type = userType == "customer" ? "users" : "shops";
      await _firestore.collection(type).doc(id).update({"blocked": block});

      emit(AdminShopBlocked(id, block));

      // Refresh lists after action
      userType == "customer"
          ? await UserCubit.instance.adminGetAllCustomers()
          : await ShopCubit.instance.adminGetAllShops();
      isBlocked = block;
    } catch (e) {
      emit(AdminError("Failed to block shop: $e"));
    }
  }

  /// ✅ Delete a shop
  Future<void> adminDeleteAccount(String userType, String id) async {
    try {
      String type = userType == "customer" ? "users" : "shops";
      await _firestore.collection(type).doc(id).delete();

      emit(AdminShopDeleted(id));

      // Refresh lists after action
      userType == "customer"
          ? await UserCubit.instance.adminGetAllCustomers()
          : await ShopCubit.instance.adminGetAllShops();
    } catch (e) {
      emit(AdminError("Failed to delete shop: $e"));
    }
  }
}
