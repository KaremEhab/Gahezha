import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gahezha/constants/cache_helper.dart';
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

  /// ✅ Edit Shop Data
  Future<void> editShopData({
    String? shopName,
    String? shopLogo,
    String? shopBanner,
    String? shopCategory,
    String? shopLocation,
    int? preparingTimeFrom,
    int? preparingTimeTo,
    int? openingHoursFrom,
    int? openingHoursTo,
    String? shopPhoneNumber,
    String? shopEmail,
    bool? shopStatus,
    bool? notificationsEnabled,
    bool silentUpdate = true,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        if (!silentUpdate) emit(ShopError("No shop logged in"));
        return;
      }

      final Map<String, dynamic> updatedData = {};

      if (shopName != null) updatedData['shopName'] = shopName;
      if (shopLogo != null) updatedData['shopLogo'] = shopLogo;
      if (shopBanner != null) updatedData['shopBanner'] = shopBanner;
      if (shopCategory != null) updatedData['shopCategory'] = shopCategory;
      if (shopLocation != null) updatedData['shopLocation'] = shopLocation;
      if (preparingTimeFrom != null) {
        updatedData['preparingTimeFrom'] = preparingTimeFrom;
      }
      if (preparingTimeTo != null) {
        updatedData['preparingTimeTo'] = preparingTimeTo;
      }
      if (openingHoursFrom != null) {
        updatedData['openingHoursFrom'] = openingHoursFrom;
      }
      if (openingHoursTo != null) {
        updatedData['openingHoursTo'] = openingHoursTo;
      }
      if (shopPhoneNumber != null) {
        updatedData['shopPhoneNumber'] = shopPhoneNumber;
      }
      if (shopEmail != null) updatedData['shopEmail'] = shopEmail;
      if (shopStatus != null) updatedData['shopStatus'] = shopStatus;
      if (notificationsEnabled != null) {
        updatedData['notificationsEnabled'] = notificationsEnabled;
      }

      if (updatedData.isEmpty) {
        if (!silentUpdate) emit(ShopError("No fields to update"));
        return;
      }

      // ✅ Update Firestore
      await _firestore.collection("shops").doc(user.uid).update(updatedData);

      // ✅ Update local model
      currentShopModel = ShopModel(
        shopName: shopName ?? currentShopModel!.shopName,
        shopLogo: shopLogo ?? currentShopModel!.shopLogo,
        shopBanner: shopBanner ?? currentShopModel!.shopBanner,
        shopCategory: shopCategory ?? currentShopModel!.shopCategory,
        shopLocation: shopLocation ?? currentShopModel!.shopLocation,
        preparingTimeFrom:
            preparingTimeFrom ?? currentShopModel!.preparingTimeFrom,
        preparingTimeTo: preparingTimeTo ?? currentShopModel!.preparingTimeTo,
        openingHoursFrom:
            openingHoursFrom ?? currentShopModel!.openingHoursFrom,
        openingHoursTo: openingHoursTo ?? currentShopModel!.openingHoursTo,
        shopPhoneNumber: shopPhoneNumber ?? currentShopModel!.shopPhoneNumber,
        shopEmail: shopEmail ?? currentShopModel!.shopEmail,
        shopStatus: shopStatus ?? currentShopModel!.shopStatus,
        notificationsEnabled:
            notificationsEnabled ?? currentShopModel!.notificationsEnabled,
        createdAt: currentShopModel!.createdAt,
      );

      // ✅ Save to cache
      await CacheHelper.saveData(
        key: 'currentShopModel',
        value: currentShopModel!.toMap(),
      );

      if (!silentUpdate) {
        emit(ShopLoaded(currentShopModel!));
      }
    } catch (e) {
      if (!silentUpdate) emit(ShopError(e.toString()));
    }
  }
}
