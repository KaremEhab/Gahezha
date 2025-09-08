import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/models/shop_model.dart';

part 'shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  ShopCubit._privateConstructor() : super(ShopInitial());

  static final ShopCubit _instance = ShopCubit._privateConstructor();

  factory ShopCubit() => _instance;

  static ShopCubit get instance => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Get current logged-in shop
  Future<void> getCurrentShop() async {
    try {
      emit(ShopLoading());

      final user = _auth.currentUser;
      if (user == null) {
        emit(ShopError("No shop logged in"));
        return;
      }

      final doc = await _firestore.collection("shops").doc(user.uid).get();

      if (!doc.exists) {
        emit(ShopError("Shop not found in database"));
        return;
      }

      currentShopModel = ShopModel.fromMap(doc.data()!);
      log(currentShopModel!.toMap().toString());

      emit(ShopLoaded(currentShopModel!));
    } catch (e) {
      emit(ShopError(e.toString()));
    }
  }

  /// ✅ Get all shops
  Future<void> getAllShops() async {
    try {
      emit(ShopLoading());

      final querySnapshot = await _firestore.collection("shops").get();

      final shops = querySnapshot.docs
          .map((doc) => ShopModel.fromMap(doc.data()))
          .toList();

      emit(ShopsLoaded(shops));
    } catch (e) {
      emit(ShopError(e.toString()));
    }
  }
}
