import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/product_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/authentication/signup.dart';
import 'package:gahezha/screens/cart/checkout.dart';
import 'package:gahezha/screens/products/customer/widgets/product_details_sheet.dart';
import 'package:iconly/iconly.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

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
  ];

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
        leading: currentUserType == UserType.guest
            ? null
            : Padding(
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
                      child: Icon(
                        IconlyBold.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
        title: Text(S.current.my_cart),
        actions: [
          if (currentUserType != UserType.guest)
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
      body: Builder(
        builder: (context) {
          if (currentUserType == UserType.guest) {
            // Guest view with signup button
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      IconlyLight.lock,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'You need an account to add items to cart',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        navigateTo(
                          context: context,
                          screen: Signup(isGuestMode: true),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(S.current.create_account),
                    ),
                  ],
                ),
              ),
            );
          } else if (cartShops.isEmpty) {
            // Logged-in user but cart is empty
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      IconlyLight.bag,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${S.current.your_cart_is_empty} 😔",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Add products to your cart to see them here.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Show cart content
            return SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
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
                                  shop['expanded'] =
                                      !(shop['expanded'] as bool);
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
                                          "${(shop['orders'] as List).length} ${S.current.items}",
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
                                      borderRadius: BorderRadius.circular(
                                        radius,
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(
                                          radius,
                                        ),
                                        // onTap: () {
                                        //   showModalBottomSheet(
                                        //     context: context,
                                        //     isScrollControlled:
                                        //         true, // ✅ makes it fullscreen-like
                                        //     shape: RoundedRectangleBorder(
                                        //       borderRadius: BorderRadius.vertical(
                                        //         top: Radius.circular(sheetRadius),
                                        //       ),
                                        //     ),
                                        //     builder: (_) {
                                        //       return ProductDetailsSheet(
                                        //         product: fakeProducts[index],
                                        //       );
                                        //     },
                                        //   );
                                        // },
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
                                                    BorderRadius.circular(
                                                      radius,
                                                    ),
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
                                                      "${S.current.price}: ${order['quantity']} x ${S.current.sar} ${order['price']}",
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
            );
          }
        },
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
              if (currentUserType == UserType.guest) {
                navigateTo(context: context, screen: Signup(isGuestMode: true));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CheckoutPage(total: totalPrice, cartShops: cartShops),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  currentUserType == UserType.guest
                      ? Flexible(
                          child: Text(
                            "Create account to place your first order",
                            maxLines: 2,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : Text(
                          '${S.current.sar} ${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                  Row(
                    children: [
                      currentUserType == UserType.guest
                          ? SizedBox.shrink()
                          : Text(
                              S.current.place_order,
                              style: TextStyle(
                                height: 0.8,
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      const Padding(
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
                      const Icon(IconlyLight.buy, color: Colors.white),
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
