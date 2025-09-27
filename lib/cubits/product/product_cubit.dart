import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/cloudinary/cloudinary_service.dart';
import 'package:gahezha/models/product_model.dart';
import 'package:uuid/uuid.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit._privateConstructor() : super(ProductInitial());

  static final ProductCubit _instance = ProductCubit._privateConstructor();
  factory ProductCubit() => _instance;
  static ProductCubit get instance => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// ✅ Product Lists
  List<ProductModel> allProducts = [];

  Future<void> createProduct(ProductModel product, BuildContext context) async {
    emit(ProductCreatedLoading());

    try {
      // Generate unique UUID v4 for the product
      final productId = const Uuid().v4();

      final docRef = firestore.collection("products").doc(productId);

      final now = DateTime.now();

      // Build the product map
      final productMap = {
        "id": productId,
        "shopId": product.shopId,
        "name": product.name,
        "description": product.description,
        "quantity": product.quantity,
        "price": product.price,
        "specifications": product.specifications,
        "selectedAddOns": product.selectedAddOns,
        "images": product.images,
        "createdAt": FieldValue.serverTimestamp(),
      };

      // Save to Firestore
      await docRef.set(productMap);

      // Add to local list immediately
      final newProduct = ProductModel(
        id: productId,
        shopId: product.shopId,
        name: product.name,
        description: product.description,
        quantity: product.quantity,
        price: product.price,
        specifications: product.specifications,
        selectedAddOns: product.selectedAddOns,
        images: product.images,
        createdAt:
            now, // approximate, will sync with server timestamp on next fetch
      );

      allProducts.insert(0, newProduct); // add to start of the list

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Product created successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }

      emit(
        ProductCreatedSuccessfully(allProducts),
      ); // update the state with new list
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
      emit(ProductCreatedFailure("Failed to create product: $e"));
    }
  }

  /// ✅ Get Product by ID
  Future<void> getProductById(String productId) async {
    emit(ProductLoading());
    try {
      final docRef = firestore.collection("products").doc(productId);
      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        emit(ProductFailure("Product not found"));
        return;
      }

      final data = snapshot.data()!;
      final product = ProductModel.fromMap(data);

      emit(ProductLoaded(product));
    } catch (e) {
      emit(ProductFailure("Failed to load product: $e"));
    }
  }

  /// ✅ Get All Products by ShopId
  Future<void> getAllProductsByShopId(String shopId) async {
    emit(ProductLoading());
    try {
      final querySnapshot = await firestore
          .collection("products")
          .where("shopId", isEqualTo: shopId)
          .orderBy("createdAt", descending: true)
          .get();

      final products = querySnapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data()))
          .toList();

      allProducts = products;
      emit(AllProductsLoaded(products));
    } catch (e, st) {
      // Log the full error + stacktrace
      log(
        "🔥 Failed to load products by shopId: $shopId",
        error: e,
        stackTrace: st,
      );
      emit(ProductFailure("Failed to load products: $e"));
    }
  }

  /// ✅ Edit Product (supports partial updates)
  Future<void> editProduct(ProductModel product) async {
    emit(ProductEditedLoading());
    try {
      final docRef = firestore.collection("products").doc(product.id);

      final Map<String, dynamic> updateData = {};
      if (product.name.isNotEmpty) updateData["name"] = product.name;
      if (product.description.isNotEmpty)
        updateData["description"] = product.description;
      if (product.quantity != null) updateData["quantity"] = product.quantity;
      if (product.price != null) updateData["price"] = product.price;
      if (product.specifications.isNotEmpty)
        updateData["specifications"] = product.specifications;
      if (product.selectedAddOns.isNotEmpty)
        updateData["selectedAddOns"] = product.selectedAddOns;
      if (product.images.isNotEmpty) updateData["images"] = product.images;

      updateData["updatedAt"] = DateTime.now().toIso8601String();

      if (updateData.isEmpty) {
        emit(ProductEditedFailure("No fields to update"));
        return;
      }

      // Update Firestore
      await docRef.update(updateData);

      // ✅ Update the product in allProducts list
      final index = allProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        allProducts[index] = product;
      }

      emit(ProductEditedSuccessfully("Product updated successfully"));
    } catch (e) {
      emit(ProductEditedFailure("Failed to update product: $e"));
    }
  }

  /// ✅ Delete a single product by ID
  Future<void> deleteProductById(String productId) async {
    emit(ProductDeletedLoading());
    try {
      // Delete from Firestore
      await firestore.collection("products").doc(productId).delete();

      // Remove from local list
      allProducts.removeWhere((p) => p.id == productId);

      // Update state with updated list
      emit(ProductDeletedSuccessfully(allProducts));
    } catch (e) {
      emit(ProductDeletedFailure("Failed to delete product: $e"));
    }
  }

  /// ✅ Delete all products under a shop
  Future<void> deleteAllProductsByShopId(String shopId) async {
    emit(ProductLoading());
    try {
      final batch = firestore.batch();
      final productsRef = await firestore
          .collection("products")
          .where("shopId", isEqualTo: shopId)
          .get();

      for (var doc in productsRef.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      emit(ProductSuccess("All products deleted successfully"));
    } catch (e) {
      emit(ProductFailure("Failed to delete all products: $e"));
    }
  }
}
