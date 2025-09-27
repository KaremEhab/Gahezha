import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/models/cart_model.dart';
import 'package:gahezha/models/order_model.dart';
import 'package:uuid/uuid.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  static CartCubit instance = CartCubit();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<CartShop> cartShops = [];

  /// reset cart state
  void resetCart() {
    emit(CartInitial());
  }

  /// Add product under specific shop
  Future<void> addToCart(
    String shopId,
    String shopName,
    String shopLogo,
    String shopPhone,
    int preparingTimeFrom,
    int preparingTimeTo,
    CartItem item, {
    bool popUp = false,
  }) async {
    try {
      emit(CartLoading());

      final shopRef = _firestore
          .collection('users')
          .doc(uId)
          .collection('cart')
          .doc(shopId);

      final shopDoc = await shopRef.get();

      if (!shopDoc.exists) {
        await shopRef.set({
          'shopId': shopId,
          'statusIndex': OrderStatus.pending.index,
          'shopName': shopName,
          'shopLogo': shopLogo,
          'shopPhoneNumber': shopPhone,
          'preparingTimeFrom': preparingTimeFrom,
          'preparingTimeTo': preparingTimeTo,
        });
      }

      final itemsRef = shopRef.collection('items');
      final existingItemsSnapshot = await itemsRef.get();

      CartItem? existingItem;

      // Helper to normalize specs for comparison
      String normalizeSpecs(
        List<Map<String, List<Map<String, dynamic>>>> specs,
      ) {
        final sortedSpecs = List<Map<String, List<Map<String, dynamic>>>>.from(
          specs,
        )..sort((a, b) => a.keys.first.compareTo(b.keys.first));

        final normalized = sortedSpecs.map((spec) {
          final key = spec.keys.first;
          final sortedValues =
              spec[key]!.map((v) {
                final sortedMap = Map.fromEntries(
                  v.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
                );
                return sortedMap;
              }).toList()..sort(
                (a, b) => a['name'].toString().compareTo(b['name'].toString()),
              );
          return {key: sortedValues};
        }).toList();

        return jsonEncode(normalized);
      }

      // Helper to normalize add-ons
      String normalizeAddOns(List<Map<String, dynamic>> addOns) {
        final sorted =
            addOns.map((a) {
              final sortedMap = Map.fromEntries(
                a.entries.toList()..sort((x, y) => x.key.compareTo(y.key)),
              );
              return sortedMap;
            }).toList()..sort(
              (a, b) => a['name'].toString().compareTo(b['name'].toString()),
            );

        return jsonEncode(sorted);
      }

      final itemSpecsJson = normalizeSpecs(item.specifications);
      final itemAddOnsJson = normalizeAddOns(item.selectedAddOns);

      debugPrint('=== Adding Item ===');
      debugPrint('Name: ${item.name}');
      debugPrint('Specs JSON: $itemSpecsJson');
      debugPrint('AddOns JSON: $itemAddOnsJson');

      for (var doc in existingItemsSnapshot.docs) {
        final cartItem = CartItem.fromMap(doc.data());
        final cartSpecsJson = normalizeSpecs(cartItem.specifications);
        final cartAddOnsJson = normalizeAddOns(cartItem.selectedAddOns);

        debugPrint('--- Existing Item ---');
        debugPrint('Name: ${cartItem.name}');
        debugPrint('Specs JSON: $cartSpecsJson');
        debugPrint('AddOns JSON: $cartAddOnsJson');

        if (cartItem.productId == item.productId &&
            cartSpecsJson == itemSpecsJson &&
            cartAddOnsJson == itemAddOnsJson) {
          debugPrint('Matched existing item, will increment quantity.');
          existingItem = cartItem;
          break;
        }
      }

      if (existingItem != null) {
        final updatedQuantity = existingItem.quantity + item.quantity;
        debugPrint(
          'Updating quantity from ${existingItem.quantity} to $updatedQuantity',
        );
        await itemsRef.doc(existingItem.cartId).update({
          'quantity': updatedQuantity,
        });
      } else {
        final cartId = Uuid().v4();
        debugPrint('No match found, creating new item with cartId: $cartId');
        final itemWithId = CartItem(
          cartId: cartId,
          productId: item.productId,
          name: item.name,
          basePrice: item.basePrice,
          quantity: item.quantity,
          productUrl: item.productUrl,
          specifications: item.specifications,
          selectedAddOns: item.selectedAddOns,
        );
        await itemsRef.doc(cartId).set(itemWithId.toMap());
      }

      // await getCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> incrementCartItem(String shopId, String cartId) async {
    try {
      double totalAmount = 0; // <-- total cart amount

      // Only proceed if cart is loaded
      if (state is! CartLoaded) return;

      final currentState = state as CartLoaded;

      // Find the shop
      final shopIndex = currentState.cartShops.indexWhere(
        (s) => s.shopId == shopId,
      );
      if (shopIndex == -1) return;

      final shop = currentState.cartShops[shopIndex];

      // Find the item
      final itemIndex = shop.orders.indexWhere((i) => i.cartId == cartId);
      if (itemIndex == -1) return;

      final item = shop.orders[itemIndex];

      // Increment locally
      item.quantity++;

      // Update Firestore
      final itemRef = _firestore
          .collection('users')
          .doc(uId)
          .collection('cart')
          .doc(shopId)
          .collection('items')
          .doc(cartId);
      await itemRef.update({'quantity': item.quantity});

      // Emit updated state (UI will rebuild only with new quantity)
      emit(CartLoaded([...currentState.cartShops], totalCart: totalAmount));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> decrementCartItem(String shopId, String cartId) async {
    try {
      double totalAmount = 0; // <-- total cart amount

      if (state is! CartLoaded) return;
      final currentState = state as CartLoaded;

      final shopIndex = currentState.cartShops.indexWhere(
        (s) => s.shopId == shopId,
      );
      if (shopIndex == -1) return;

      final shop = currentState.cartShops[shopIndex];

      final itemIndex = shop.orders.indexWhere((i) => i.cartId == cartId);
      if (itemIndex == -1) return;

      final item = shop.orders[itemIndex];
      final itemRef = _firestore
          .collection('users')
          .doc(uId)
          .collection('cart')
          .doc(shopId)
          .collection('items')
          .doc(cartId);

      if (item.quantity > 1) {
        // Just decrement quantity
        item.quantity--;
        await itemRef.update({'quantity': item.quantity});
      } else {
        // Quantity is 1, delete the item
        shop.orders.removeAt(itemIndex);
        await itemRef.delete();

        // If shop has no more items, delete the shop document
        if (shop.orders.isEmpty) {
          final shopRef = _firestore
              .collection('users')
              .doc(uId)
              .collection('cart')
              .doc(shopId);
          await shopRef.delete();
          currentState.cartShops.removeAt(shopIndex);
        }
      }

      emit(CartLoaded([...currentState.cartShops], totalCart: totalAmount));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  /// Update item quantity in cart
  Future<void> updateCart(
    String productId,
    int quantity, {
    bool popUp = false,
  }) async {
    try {
      emit(CartLoading());
      final docRef = _firestore
          .collection('users')
          .doc(uId)
          .collection('cart')
          .doc(productId);

      if (quantity > 0) {
        await docRef.update({'quantity': quantity});
      } else {
        await docRef.delete(); // remove if quantity 0
      }

      await getCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  /// Fetch cart from Firestore
  Future<void> getCart() async {
    try {
      cartShops = [];
      emit(CartLoading());

      final cartSnapshot = await _firestore
          .collection('users')
          .doc(uId)
          .collection('cart')
          .get();

      double totalAmount = 0; // <-- total cart amount

      for (var shopDoc in cartSnapshot.docs) {
        final shopId = shopDoc['shopId'] ?? '';
        final shopName = shopDoc['shopName'] ?? '';
        final shopLogo = shopDoc['shopLogo'] ?? '';
        final shopPhone = shopDoc['shopPhoneNumber'] ?? '';
        final preparingTimeFrom = shopDoc['preparingTimeFrom'] ?? 0;
        final preparingTimeTo = shopDoc['preparingTimeTo'] ?? 0;

        final itemsSnapshot = await shopDoc.reference.collection('items').get();

        final orders = itemsSnapshot.docs
            .map((itemDoc) => CartItem.fromMap(itemDoc.data()))
            .toList();

        // Sum total for this shop
        for (var item in orders) {
          totalAmount += (item.totalPrice);
        }

        cartShops.add(
          CartShop(
            shopId: shopId,
            status: OrderStatus.pending,
            shopName: shopName,
            shopLogo: shopLogo,
            shopPhone: shopPhone,
            preparingTimeFrom: preparingTimeFrom,
            preparingTimeTo: preparingTimeTo,
            orders: orders,
          ),
        );
      }

      emit(CartLoaded(cartShops, totalCart: totalAmount));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  /// Clear cart
  Future<void> clearCart() async {
    try {
      emit(CartLoading());

      double totalAmount = 0; // <-- total cart amount

      final cartRef = _firestore
          .collection('users')
          .doc(uId)
          .collection('cart');
      final cartSnapshot = await cartRef.get();

      for (var shopDoc in cartSnapshot.docs) {
        final itemsSnapshot = await shopDoc.reference.collection('items').get();
        for (var itemDoc in itemsSnapshot.docs) {
          await itemDoc.reference.delete();
        }
        await shopDoc.reference.delete();
      }

      cartShops.clear();
      emit(CartLoaded(cartShops, totalCart: totalAmount));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
