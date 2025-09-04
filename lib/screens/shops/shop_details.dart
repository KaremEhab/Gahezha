import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/products/widgets/product_details_sheet.dart';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: Hero(
          tag: "cartHero",
          child: FloatingActionButton.extended(
            heroTag: null, // ✅ disable default FAB Hero
            elevation: 0,
            onPressed: _openCartPopup,
            backgroundColor: primaryBlue,
            icon: const Icon(IconlyLight.buy, color: Colors.white),
            label: const Text("Cart", style: TextStyle(color: Colors.white)),
          ),
        ),
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
                        "Open",
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
                                  children: const [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "4.7",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "• Flowers & Gifts",
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
                    tabs: const [
                      Tab(text: "Menu"),
                      Tab(text: "Info"),
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
                itemCount: 8,
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
                              productName: "Product ${index + 1}",
                              productImage:
                                  "https://picsum.photos/400?random=$index",
                              productPrice: 12.99,
                              description:
                                  "This is a freshly prepared delicious item with high quality ingredients. Perfect for your cravings!",
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
                            CustomCachedImage(
                              imageUrl:
                                  "https://picsum.photos/120?random=$index",
                              height: 120,
                              width: 110,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(14),
                                right: Radius.circular(14),
                              ),
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
                                      "Product ${index + 1}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      "A tasty and freshly prepared item for you.",
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
                                        const Text(
                                          "\$12.99",
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
                                          onPressed: () {},
                                          child: const Text("Add"),
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
                    const Text(
                      "Shop Info",
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
                        const Text("~ 24 - 38 Minuets"),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(IconlyLight.time_circle, color: primaryBlue),
                        const SizedBox(width: 8),
                        const Text("Open: 10 AM - 11 PM"),
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
                    const Text(
                      "Pickup Instructions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Order online and collect from the counter when ready. "
                      "Show your order ID at pickup point.",
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
