import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gahezha/constants/cache_helper.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/models/shop_model.dart';
import 'package:uuid/uuid.dart';

part 'shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  ShopCubit._privateConstructor() : super(ShopInitial());

  static final ShopCubit _instance = ShopCubit._privateConstructor();

  factory ShopCubit() => _instance;

  static ShopCubit get instance => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Shop Lists
  List<ShopModel> allShops = [];

  List<ShopModel> hotDealerShops = [];

  List<ShopModel> pendingShops = [];

  List<ShopModel> rejectedShops = [];

  List<ShopModel> acceptedShops = [];

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

  /// ✅ Get all shops and separate hot dealers
  Future<void> customerGetAllShops() async {
    try {
      emit(ShopLoading());

      // Fetch all shops sorted by createdAt descending
      final querySnapshot = await _firestore
          .collection("shops")
          .orderBy("createdAt", descending: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        allShops = [];
        hotDealerShops = [];
        emit(AllShopsLoaded(allShops));
        return;
      }

      // Take up to 4 shops as hot dealers
      final hotDealerDocs = querySnapshot.docs.take(4).toList();
      hotDealerShops = hotDealerDocs
          .map((doc) => ShopModel.fromMap(doc.data(), id: doc.id))
          .toList();

      // Remaining shops
      final remainingDocs = querySnapshot.docs.skip(4).toList();
      allShops = remainingDocs
          .map((doc) => ShopModel.fromMap(doc.data(), id: doc.id))
          .toList();

      emit(AllShopsLoaded(allShops));
    } catch (e, stackTrace) {
      print("Error in getAllShops: $e");
      print(stackTrace);
      allShops = [];
      hotDealerShops = [];
      emit(ShopError(e.toString()));
    }
  }

  /// ✅ Get all shops
  Future<void> adminGetAllShops() async {
    try {
      emit(ShopLoading());

      // Fetch all shops sorted by createdAt descending
      final querySnapshot = await _firestore
          .collection("shops")
          .orderBy("createdAt", descending: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        allShops = [];
        emit(AllShopsLoaded(allShops));
        return;
      }

      allShops = querySnapshot.docs
          .map((doc) => ShopModel.fromMap(doc.data(), id: doc.id))
          .toList();

      emit(AllShopsLoaded(allShops));
    } catch (e, stackTrace) {
      print("Error in getAllShops: $e");
      print(stackTrace);
      allShops = [];
      emit(ShopError(e.toString()));
    }
  }

  /// ✅ Get shops by status directly from Firestore
  Future<List<ShopModel>> getShopsByStatus(ShopAcceptanceStatus status) async {
    try {
      final querySnapshot = await _firestore
          .collection("shops")
          .where(
            'shopAcceptanceStatus',
            isEqualTo: status.index,
          ) // store index in Firestore
          .orderBy('createdAt', descending: true)
          .get();

      if (querySnapshot.docs.isEmpty) return [];

      return querySnapshot.docs
          .map((doc) => ShopModel.fromMap(doc.data(), id: doc.id))
          .toList();
    } catch (e, stackTrace) {
      print("Error fetching shops by status [$status]: $e");
      print(stackTrace);
      return [];
    }
  }

  /// ✅ Fetch top 4 pending shops for home display
  Future<void> getHomePendingShops() async {
    emit(ShopLoading()); // optional: emit loading state

    try {
      final shops = await getShopsByStatus(ShopAcceptanceStatus.pending);

      // Limit to 4 if more than 4 shops exist
      final displayedShops = shops.length > 4 ? shops.take(4).toList() : shops;

      pendingShops = displayedShops; // assign the limited list
      emit(PendingShopsLoaded(pendingShops)); // emit state for UI
    } catch (e) {
      print("Error fetching home pending shops: $e");
      emit(ShopError(e.toString()));
    }
  }

  /// ✅ Fetch pending shops and store in pendingShops list
  Future<void> getPendingShops() async {
    emit(ShopLoading()); // optional: emit loading state

    try {
      final shops = await getShopsByStatus(ShopAcceptanceStatus.pending);
      pendingShops = shops; // assign fetched shops directly
      emit(PendingShopsLoaded(pendingShops)); // emit state for UI
    } catch (e) {
      print("Error fetching pending shops: $e");
      emit(ShopError(e.toString()));
    }
  }

  /// ✅ Similarly for accepted shops
  Future<void> getAcceptedShops() async {
    emit(ShopLoading());
    try {
      final shops = await getShopsByStatus(ShopAcceptanceStatus.accepted);
      acceptedShops = shops;
      emit(AcceptedShopsLoaded(acceptedShops));
    } catch (e) {
      print("Error fetching accepted shops: $e");
      emit(ShopError(e.toString()));
    }
  }

  /// ✅ Similarly for rejected shops
  Future<void> getRejectedShops() async {
    emit(ShopLoading());
    try {
      final shops = await getShopsByStatus(ShopAcceptanceStatus.rejected);
      rejectedShops = shops;
      emit(RejectedShopsLoaded(rejectedShops));
    } catch (e) {
      print("Error fetching rejected shops: $e");
      emit(ShopError(e.toString()));
    }
  }

  /// Change the acceptance status of a shop
  Future<void> changeShopAcceptanceStatus({
    required ShopModel shop,
    required ShopAcceptanceStatus newStatus,
  }) async {
    if (shop.id.isEmpty) {
      print('Error: shopId is empty');
      return;
    }

    try {
      // 1️⃣ Update Firestore
      await _firestore.collection('shops').doc(shop.id).update({
        'shopAcceptanceStatus': newStatus.index,
      });

      print('Shop ${shop.id} status updated to $newStatus');

      // 2️⃣ Remove the shop from any existing lists
      allShops.removeWhere((s) => s.id == shop.id);
      pendingShops.removeWhere((s) => s.id == shop.id);
      acceptedShops.removeWhere((s) => s.id == shop.id);
      rejectedShops.removeWhere((s) => s.id == shop.id);

      // 3️⃣ Add the shop to the new status list
      final updatedShop = shop.copyWith(shopAcceptanceStatus: newStatus);

      switch (newStatus) {
        case ShopAcceptanceStatus.accepted:
          acceptedShops.insert(0, updatedShop);
          emit(AcceptedShopsLoaded(acceptedShops));
          break;
        case ShopAcceptanceStatus.rejected:
          rejectedShops.insert(0, updatedShop);
          emit(RejectedShopsLoaded(rejectedShops));
          break;
        case ShopAcceptanceStatus.pending:
          pendingShops.insert(0, updatedShop);
          emit(PendingShopsLoaded(pendingShops));
          break;
      }
    } catch (e, stackTrace) {
      print('Error updating shop acceptance status: $e');
      print(stackTrace);
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
    num? shopRate,
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
      if (shopRate != null) {
        updatedData['shopRate'] = shopRate;
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
        id: Uuid().v4(),
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
        shopRate: shopRate ?? currentShopModel!.shopRate,
        shopPhoneNumber: shopPhoneNumber ?? currentShopModel!.shopPhoneNumber,
        shopEmail: shopEmail ?? currentShopModel!.shopEmail,
        shopStatus: shopStatus ?? currentShopModel!.shopStatus,
        blocked: currentShopModel!.blocked ?? false,
        disabled: currentShopModel!.disabled ?? false,
        shopAcceptanceStatus:
            currentShopModel!.shopAcceptanceStatus ??
            ShopAcceptanceStatus.pending,
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
