import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/models/product_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/products/customer/widgets/product_details_sheet.dart';
import 'package:gahezha/screens/products/shop/add_products.dart';
import 'package:gahezha/screens/products/shop/edit_products.dart';
import 'package:iconly/iconly.dart';

class ShopMenuPage extends StatelessWidget {
  const ShopMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fake products for UI demo
    List<ProductModel> fakeProducts = [
      ProductModel(
        id: "141514",
        name: "Cheeseburger",
        description: "Cheeseburger description",
        quantity: 23,
        price: 8.99,
        specifications: [
          {
            "Select Size": [
              {"name": "Small", "price": 0.0},
              {"name": "Medium", "price": 2.5},
              {"name": "Large", "price": 4.0},
            ],
          },
        ],
        selectedAddOns: [
          {"name": "Extra Pickles", "price": 0.5},
          {"name": "No Vegetables", "price": 0.0},
          {"name": "Extra Mushrooms", "price": 1.0},
        ],
        images: [
          "https://www.sargento.com/assets/Uploads/Recipe/Image/cheddarbaconcheeseburger__FocusFillWyIwLjAwIiwiMC4wMCIsODAwLDQ3OF0_CompressedW10.jpg",
        ],
      ),
      ProductModel(
        id: "231412",
        name: "Pepperoni Pizza",
        description: "Pepperoni Pizza description",
        quantity: 4,
        price: 12.50,
        specifications: [
          {
            "Select Size": [
              {"name": "Small", "price": 0.0},
              {"name": "Medium", "price": 2.5},
              {"name": "Large", "price": 4.0},
            ],
          },
        ],
        selectedAddOns: [
          {"name": "Extra Cheese", "price": 2.0},
          {"name": "Extra Pepperoni", "price": 3.0},
        ],
        images: [
          "https://www.moulinex.com.eg/medias/?context=bWFzdGVyfHJvb3R8MTQzNTExfGFwcGxpY2F0aW9uL29jdGV0LXN0cmVhbXxhRFl5TDJneE9TOHhNekV4TVRjM01UVXlPVEkwTmk1aWFXNHw3NTkwMmNjYmFhZTUwZjYwNzk0ZmQyNjVmMjEzYjZiNGI3YzU1NGI3ZGNjYjM3YjYxZGY5Y2Y0ZTdjZmZkZmNj",
          "https://www.tablefortwoblog.com/wp-content/uploads/2025/06/pepperoni-pizza-recipe-photos-tablefortwoblog-7.jpg",
        ],
      ),
      ProductModel(
        id: "139401",
        name: "American Coffee",
        description: "American Coffee description",
        quantity: 20,
        price: 3.25,
        specifications: [
          {
            "How to Serve": [
              {"name": "Hot", "price": 0.0},
              {"name": "Iced", "price": 2.5},
              {"name": "Decaf", "price": 4.0},
            ],
          },
        ],
        selectedAddOns: [
          {"name": "Extra Milk", "price": 0.5},
          {"name": "Whipped Cream", "price": 1.0},
        ],
        images: [
          "https://pontevecchiosrl.it/wp-content/uploads/2021/03/caffe-americano-in-casa.jpg",
        ],
      ),
      ProductModel(
        id: "139401",
        name: "American Coffee",
        description: "American Coffee description",
        quantity: 20,
        price: 3.25,
        specifications: [],
        selectedAddOns: [],
        images: [
          // "https://pontevecchiosrl.it/wp-content/uploads/2021/03/caffe-americano-in-casa.jpg",
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop Menu"),
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
      ),
      body: fakeProducts.isEmpty
          ? const Center(child: Text("No products yet."))
          : ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 80),
              itemCount: fakeProducts.length,
              itemBuilder: (context, index) {
                final product = fakeProducts[index];
                return _ProductCard(product: product);
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBlue,
        shape: CircleBorder(),
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductPage()),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(product.id),

      // LEFT → Delete
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (c) async {
              // TODO: implement delete product
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${product.name} deleted")),
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: IconlyLight.delete,
            label: "Delete",
          ),
        ],
      ),

      // RIGHT → Edit
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (c) async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProductPage(product: product),
                ),
              );
            },
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: "Edit",
          ),
        ],
      ),

      child: ListTile(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(sheetRadius),
              ),
            ),
            builder: (_) => ProductDetailsSheet(product: product),
          );
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        leading: product.images == null || product.images.isEmpty
            ? Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: Center(child: Icon(IconlyBroken.image, size: 30)),
              )
            : CustomCachedImage(
                imageUrl: product.images.first ?? "",
                borderRadius: BorderRadius.circular(radius),
                width: 56,
                height: 56,
              ),
        title: Text(
          product.name,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          product.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          "SAR ${product.price.toStringAsFixed(2)}",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}
