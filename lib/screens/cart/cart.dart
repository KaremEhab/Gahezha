import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/cart/checkout.dart';
import 'package:gahezha/screens/products/widgets/product_details_sheet.dart';
import 'package:iconly/iconly.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  // Dummy multi-shop cart data
  List<Map<String, dynamic>> cartShops = [
    {
      "shopId": "shop1",
      "shopName": "Nike",
      "shopLogo": "https://picsum.photos/100/100?random=43",
      "expanded": true,
      "orders": [
        {
          "id": "1",
          "name": "Nike Joyride",
          "price": 230,
          "quantity": 5,
          "image": "https://picsum.photos/100/100?random=19",
        },
        {
          "id": "2",
          "name": "Air Max 270",
          "price": 450,
          "quantity": 2,
          "image": "https://picsum.photos/100/100?random=20",
        },
      ],
    },
    {
      "shopId": "shop2",
      "shopName": "Adidas",
      "shopLogo": "https://picsum.photos/100/100?random=44",
      "expanded": true,
      "orders": [
        {
          "id": "3",
          "name": "Adidas Ultraboost",
          "price": 300,
          "quantity": 3,
          "image": "https://picsum.photos/100/100?random=21",
        },
      ],
    },
  ];

  double get totalPrice => cartShops.fold(
    0,
    (sum, shop) =>
        sum +
        (shop['orders'] as List).fold(
          0,
          (shopSum, order) => shopSum + order['price'] * order['quantity'],
        ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        leadingWidth: 53,
        leading: Padding(
          padding: EdgeInsets.fromLTRB(
            lang == 'en' ? 7 : 0,
            6,
            lang == 'ar' ? 7 : 0,
            6,
          ),
          child: Material(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(radius),
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: () {},
              child: Center(
                child: Icon(IconlyBold.delete, color: Colors.red, size: 20),
              ),
            ),
          ),
        ),
        title: Text("My Cart"),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: lang == 'en' ? 7 : 0,
              left: lang == 'ar' ? 7 : 0,
            ),
            child: Material(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(radius),
              child: InkWell(
                borderRadius: BorderRadius.circular(radius),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(13),
                  child: Icon(Icons.add_shopping_cart_rounded, size: 16),
                ),
              ),
            ),
          ),
        ],
      ),
      body: cartShops.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty 😔",
                style: TextStyle(fontSize: 18),
              ),
            )
          : SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: cartShops.map((shop) {
                  return Column(
                    children: [
                      // Shop Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(7, 10, 7, 5),
                        child: Material(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(radius),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(radius),
                            onTap: () {
                              setState(() {
                                shop['expanded'] = !(shop['expanded'] as bool);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        child: CustomCachedImage(
                                          imageUrl: shop['shopLogo'],
                                          height: double.infinity,
                                          borderRadius: BorderRadius.circular(
                                            200,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        shop['shopName'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${(shop['orders'] as List).length} items",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      AnimatedRotation(
                                        turns: (shop['expanded'] as bool)
                                            ? 0.5
                                            : 0,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        child: const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Orders List
                      if (shop['expanded'] as bool)
                        Column(
                          children: (shop['orders'] as List)
                              .map<Widget>(
                                (order) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: Material(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(radius),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(
                                        radius,
                                      ),
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled:
                                              true, // ✅ makes it fullscreen-like
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(sheetRadius),
                                            ),
                                          ),
                                          builder: (_) {
                                            return ProductDetailsSheet(
                                              productName: order['name'],
                                              productImage: order['image'],
                                              productPrice: 12.99,
                                              description:
                                                  "This is a freshly prepared delicious item with high quality ingredients. Perfect for your cravings!",
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            radius,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            CustomCachedImage(
                                              imageUrl: order['image'],
                                              width: 60,
                                              height: 60,
                                              borderRadius:
                                                  BorderRadius.circular(radius),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    order['name'],
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "Price: \$${order['price']} x ${order['quantity']}",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // New Increment/Decrement UI
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      radius,
                                                    ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // Decrement Button
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (order['quantity'] >
                                                            1) {
                                                          order['quantity']--;
                                                        }
                                                      });
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          radius,
                                                        ),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 6,
                                                          ),
                                                      child: Icon(
                                                        Icons.remove,
                                                        size: 18,
                                                        color: primaryBlue,
                                                      ),
                                                    ),
                                                  ),

                                                  // Quantity Display
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                        ),
                                                    child: Text(
                                                      '${order['quantity']}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),

                                                  // Increment Button
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        order['quantity']++;
                                                      });
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          radius,
                                                        ),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 6,
                                                          ),
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 18,
                                                        color: primaryBlue,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),

      // Total & Checkout
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        height: 65,
        child: Material(
          borderRadius: BorderRadius.circular(radius),
          color: primaryBlue,
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CheckoutPage(total: totalPrice, cartShops: cartShops),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: const [
                      Text(
                        "Place order",
                        style: TextStyle(
                          height: 0.8,
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 18,
                        ),
                        child: SizedBox(
                          width: 2,
                          height: 40,
                          child: Material(color: Colors.white24),
                        ),
                      ),
                      Icon(IconlyLight.buy, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
