import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/product_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/authentication/signup.dart';
import 'package:gahezha/screens/products/customer/widgets/product_details_sheet.dart';
import 'package:gahezha/screens/cart/widgets/cart_popup.dart';
import 'package:iconly/iconly.dart';

class ShopDetailsPage extends StatefulWidget {
  final String shopName;

  const ShopDetailsPage({super.key, required this.shopName});

  @override
  State<ShopDetailsPage> createState() => _ShopDetailsPageState();
}

class _ShopDetailsPageState extends State<ShopDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openCartPopup() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // ✅ makes background visible
        barrierDismissible: true,
        pageBuilder: (_, __, ___) => const CartPopup(),
      ),
    );
  }

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
          // "https://www.sargento.com/assets/Uploads/Recipe/Image/cheddarbaconcheeseburger__FocusFillWyIwLjAwIiwiMC4wMCIsODAwLDQ3OF0_CompressedW10.jpg",
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton:
            currentUserType == UserType.customer ||
                currentUserType == UserType.guest
            ? Hero(
                tag: "cartHero",
                child: FloatingActionButton.extended(
                  heroTag: null, // ✅ disable default FAB Hero
                  elevation: 0,
                  onPressed: _openCartPopup,
                  backgroundColor: primaryBlue,
                  icon: const Icon(IconlyLight.buy, color: Colors.white),
                  label: Text(
                    S.current.cart,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            : null,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: true,
              expandedHeight: 300,
              elevation: 0,
              title: innerBoxIsScrolled ? Text(widget.shopName) : null,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: innerBoxIsScrolled
                      ? Colors.white
                      : Colors.black.withOpacity(0.1),
                  shape: const CircleBorder(), // keeps it circular
                ),
                icon: Icon(
                  Icons.arrow_back,
                  color: innerBoxIsScrolled ? Colors.black : Colors.white,
                ),
              ),
              actions: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  margin: EdgeInsetsGeometry.directional(end: 10),
                  decoration: BoxDecoration(
                    color: innerBoxIsScrolled
                        ? Colors.transparent
                        : Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  child: Row(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: innerBoxIsScrolled
                            ? Colors.black
                            : Colors.white,
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.green,
                        ),
                      ),
                      Text(
                        S.current.open,
                        style: TextStyle(
                          color: innerBoxIsScrolled
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // widget.productImages == null || widget.productImages.isEmpty
                    //     ? Container(
                    //   height: double.infinity,
                    //   decoration: BoxDecoration(
                    //     color: Colors.grey.shade200,
                    //   ),
                    //   child: Center(
                    //     child: Icon(
                    //       IconlyBroken.image,
                    //       size: 50,
                    //     ),
                    //   ),
                    // )
                    //     :
                    CustomCachedImage(
                      imageUrl: "https://picsum.photos/600/300",
                      height: double.infinity,
                    ),
                    Container(color: Colors.black.withOpacity(0.4)),
                    Positioned(
                      bottom: 65,
                      left: 16,
                      right: 16,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // widget.productImages == null || widget.productImages.isEmpty
                          //     ? Container(
                          //   height: 70,
                          //   width: 70,
                          //   decoration: BoxDecoration(
                          //     color: Colors.grey.shade200,
                          //     borderRadius: BorderRadius.circular(radius),
                          //   ),
                          //   child: Center(
                          //     child: Icon(
                          //       IconlyBroken.image,
                          //       size: 50,
                          //     ),
                          //   ),
                          // )
                          //     :
                          CustomCachedImage(
                            imageUrl: "https://picsum.photos/80",
                            height: 70,
                            width: 70,
                            borderRadius: BorderRadius.circular(radius),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.shopName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "4.7",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "• ${S.current.flowers_gifts}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Material(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: primaryBlue,
                    labelColor: primaryBlue,
                    unselectedLabelColor: Colors.grey,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    tabs: [
                      Tab(text: S.current.menu),
                      Tab(text: S.current.info),
                    ],
                  ),
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              // -------------------- MENU --------------------
              ListView.builder(
                padding: const EdgeInsets.only(
                  top: 15,
                  right: 10,
                  left: 10,
                  bottom: 120,
                ),
                itemCount: fakeProducts.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
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
                              product: fakeProducts[index],
                            );
                          },
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ---------- Product Image ----------
                            fakeProducts[index].images == null ||
                                    fakeProducts[index].images.isEmpty
                                ? Container(
                                    height: 120,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(
                                        radius,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(IconlyBroken.image, size: 50),
                                    ),
                                  )
                                : CustomCachedImage(
                                    imageUrl: fakeProducts[index].images.first,
                                    height: 120,
                                    width: 110,
                                    borderRadius: BorderRadius.circular(radius),
                                  ),

                            // ---------- Product Info ----------
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fakeProducts[index].name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      fakeProducts[index].description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                        height: 1.4,
                                      ),
                                    ),

                                    // ---------- Price & Button ----------
                                    Row(
                                      children: [
                                        Text(
                                          "${S.current.sar} ${fakeProducts[index].price}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const Spacer(),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            minimumSize: const Size(60, 34),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                color: Colors.blue.shade400,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (currentUserType ==
                                                UserType.guest) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                    "Create an account first",
                                                  ),
                                                  action: SnackBarAction(
                                                    label: "Sign Up",
                                                    textColor: primaryBlue,
                                                    onPressed: () {
                                                      navigateTo(
                                                        context: context,
                                                        screen: Signup(
                                                          isGuestMode: true,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Text(S.current.add),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // -------------------- INFO --------------------
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.current.shop_info,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(IconlyLight.location, color: primaryBlue),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text("123 Main Street, Cairo, Egypt"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(IconlyLight.bag, color: primaryBlue),
                        const SizedBox(width: 8),
                        Text("~ 24 - 38 ${S.current.minuets}"),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(IconlyLight.time_circle, color: primaryBlue),
                        const SizedBox(width: 8),
                        Text(
                          "${S.current.open}: 10 ${S.current.am} - 11 ${S.current.pm}",
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(IconlyLight.call, color: primaryBlue),
                        const SizedBox(width: 8),
                        const Text("+20 123 456 789"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      S.current.pickup_instructions,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.current.pickup_instructions_subtitle,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
