import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gahezha/constants/cache_helper.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/admin/admin_state.dart';
import 'package:gahezha/models/shop_model.dart';
import 'package:gahezha/models/user_model.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit._privateConstructor() : super(AdminInitial());

  static final AdminCubit _instance = AdminCubit._privateConstructor();

  factory AdminCubit() => _instance;

  static AdminCubit get instance => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
