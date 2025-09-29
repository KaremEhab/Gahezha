import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/cart/cart_cubit.dart';
import 'package:gahezha/cubits/product/product_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/cart_model.dart';
import 'package:gahezha/models/product_model.dart';
import 'package:gahezha/models/shop_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/authentication/signup.dart';
import 'package:gahezha/screens/products/customer/widgets/product_details_sheet.dart';
import 'package:gahezha/screens/cart/widgets/cart_popup.dart';
import 'package:iconly/iconly.dart';

class ShopDetailsPage extends StatefulWidget {
  const ShopDetailsPage({super.key, required this.shopModel});

  final ShopModel shopModel;

  @override
  State<ShopDetailsPage> createState() => _ShopDetailsPageState();
}

class _ShopDetailsPageState extends State<ShopDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey _fabKey = GlobalKey();
  final GlobalKey addButtonKey = GlobalKey();
  final imageKey = GlobalKey();

  bool displayProducts = false;

  Future<void> runAddToCartAnimation(
    BuildContext context,
    String imageUrl,
    Offset startOffset, {
    double startWidth = 50,
    double startHeight = 50,
  }) async {
    final overlay = Overlay.of(context);

    final RenderBox fabBox =
        _fabKey.currentContext!.findRenderObject() as RenderBox;
    final fabPosition = fabBox.localToGlobal(Offset.zero);

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedAddToCart(
          startOffset: startOffset,
          endOffset:
              fabPosition +
              Offset(fabBox.size.width / 2, fabBox.size.height / 2),
          imageUrl: imageUrl,
          startWidth: startWidth,
          startHeight: startHeight,
        );
      },
    );

    overlay.insert(overlayEntry);
    await Future.delayed(const Duration(milliseconds: 700));
    overlayEntry.remove();
  }

  @override
  void initState() {
    super.initState();
    ProductCubit.instance.getAllProductsByShopId(widget.shopModel.id);
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
        floatingActionButton:
            currentUserType == UserType.customer ||
                currentUserType == UserType.guest
            ? Hero(
                tag: "cartHero",
                key: _fabKey,
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
              title: innerBoxIsScrolled
                  ? Text(widget.shopModel.shopName)
                  : null,
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
                          backgroundColor: widget.shopModel.shopStatus
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      Text(
                        widget.shopModel.shopStatus
                            ? S.current.open
                            : S.current.closed,
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
                    widget.shopModel.shopBanner == null ||
                            widget.shopModel.shopBanner.isEmpty
                        ? Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                            ),
                            child: Center(
                              child: Icon(IconlyBroken.image, size: 50),
                            ),
                          )
                        : CustomCachedImage(
                            // key: imageKey, // ← Add this
                            imageUrl: widget.shopModel.shopBanner,
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
                          widget.shopModel.shopLogo == null ||
                                  widget.shopModel.shopLogo.isEmpty
                              ? Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(radius),
                                  ),
                                  child: Center(
                                    child: Icon(IconlyBroken.image, size: 30),
                                  ),
                                )
                              : Material(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(
                                    radius + 2,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: CustomCachedImage(
                                      imageUrl: widget.shopModel.shopLogo,
                                      height: 70,
                                      width: 70,
                                      borderRadius: BorderRadius.circular(
                                        radius,
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.shopModel.shopName,
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
                                    Text(
                                      widget.shopModel.shopRate.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "• ${widget.shopModel.shopCategory}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
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
              BlocConsumer<ProductCubit, ProductState>(
                listener: (context, state) {
                  // You can remove displayProducts boolean if using state directly
                },
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AllProductsLoaded) {
                    final products = ProductCubit.instance.allProducts;
                    if (products.isEmpty) {
                      return const Center(
                        child: Text(
                          "Empty Products",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.only(
                          top: 15,
                          right: 10,
                          left: 10,
                          bottom: MediaQuery.of(context).size.height * 0.4,
                        ),
                        itemCount: ProductCubit.instance.allProducts.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final product =
                              ProductCubit.instance.allProducts[index];
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
                                      isShopOpen: widget.shopModel.shopStatus,
                                      productModel: product,
                                      shopName: widget.shopModel.shopName,
                                      shopLogo: widget.shopModel.shopLogo,
                                      shopPhone:
                                          widget.shopModel.shopPhoneNumber,
                                      preparingTimeFrom:
                                          widget.shopModel.preparingTimeFrom,
                                      preparingTimeTo:
                                          widget.shopModel.preparingTimeTo,
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
                                    product.images == null ||
                                            product.images.isEmpty
                                        ? Container(
                                            height: 120,
                                            width: 110,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(radius),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                IconlyBroken.image,
                                                size: 50,
                                              ),
                                            ),
                                          )
                                        : CustomCachedImage(
                                            key: imageKey, // ← Add this
                                            imageUrl: product.images.first,
                                            height: 120,
                                            width: 110,
                                            borderRadius: BorderRadius.circular(
                                              radius,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              product.description,
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
                                                SizedBox(
                                                  height: 50,
                                                  child: Center(
                                                    child: Text(
                                                      "${S.current.sar} ${product.price}",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                if(widget.shopModel.shopStatus)
                                                TextButton(
                                                  key: addButtonKey, // add this
                                                  style: TextButton.styleFrom(
                                                    minimumSize: const Size(
                                                      60,
                                                      34,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 14,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      side: BorderSide(
                                                        color: Colors
                                                            .blue
                                                            .shade400,
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () async {
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
                                                            textColor:
                                                                primaryBlue,
                                                            onPressed: () {
                                                              navigateTo(
                                                                context:
                                                                    context,
                                                                screen: Signup(
                                                                  isGuestMode:
                                                                      true,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      final selectedSpecs = product
                                                          .specifications
                                                          .map((spec) {
                                                            final key = spec
                                                                .keys
                                                                .first; // e.g., "Size"
                                                            final values =
                                                                spec[key] ?? [];

                                                            // Pick only the first value in a List
                                                            final firstValueList =
                                                                values
                                                                    .isNotEmpty
                                                                ? [values.first]
                                                                : <
                                                                    Map<
                                                                      String,
                                                                      dynamic
                                                                    >
                                                                  >[];

                                                            return {
                                                              key:
                                                                  firstValueList,
                                                            };
                                                          })
                                                          .toList();

                                                      final RenderBox imageBox =
                                                          imageKey.currentContext!
                                                                  .findRenderObject()
                                                              as RenderBox;
                                                      final imagePosition =
                                                          imageBox
                                                              .localToGlobal(
                                                                Offset.zero,
                                                              );

                                                      if (product
                                                          .images
                                                          .isNotEmpty) {
                                                        runAddToCartAnimation(
                                                          context,
                                                          product.images.first,
                                                          imagePosition,
                                                          startWidth: 110,
                                                          startHeight: 120,
                                                        );
                                                      }

                                                      await CartCubit.instance
                                                          .addToCart(
                                                            product.shopId,
                                                            widget
                                                                .shopModel
                                                                .shopName,
                                                            widget
                                                                .shopModel
                                                                .shopLogo,
                                                            widget
                                                                .shopModel
                                                                .shopPhoneNumber,
                                                            widget
                                                                .shopModel
                                                                .preparingTimeFrom,
                                                            widget
                                                                .shopModel
                                                                .preparingTimeTo,
                                                            CartItem(
                                                              productId:
                                                                  product.id,
                                                              name:
                                                                  product.name,
                                                              basePrice:
                                                                  product.price,
                                                              quantity: 1,
                                                              productUrl:
                                                                  product
                                                                      .images
                                                                      .isEmpty
                                                                  ? ''
                                                                  : product
                                                                        .images
                                                                        .first,
                                                              specifications:
                                                                  selectedSpecs,
                                                              selectedAddOns:
                                                                  [],
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
                      );
                    }
                  } else if (state is ProductFailure) {
                    return Center(
                      child: Text(
                        "Error: ${state.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    // Fallback for initial or unknown states
                    return const SizedBox.shrink();
                  }
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
                        Expanded(child: Text(widget.shopModel.shopLocation)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(IconlyLight.bag, color: primaryBlue),
                        const SizedBox(width: 8),
                        Text(
                          "~ ${widget.shopModel.preparingTimeFrom} - ${widget.shopModel.preparingTimeTo} ${S.current.minuets}",
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(IconlyLight.time_circle, color: primaryBlue),
                        const SizedBox(width: 8),
                        Text(
                          "${widget.shopModel.shopStatus ? S.current.open : S.current.closed}: ${widget.shopModel.openingHoursFrom} ${S.current.am} - ${widget.shopModel.openingHoursTo} ${S.current.pm}",
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(IconlyLight.call, color: primaryBlue),
                        const SizedBox(width: 8),
                        Text(widget.shopModel.shopPhoneNumber),
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.65),
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

class AnimatedAddToCart extends StatefulWidget {
  final Offset startOffset;
  final Offset endOffset;
  final String imageUrl;
  final double startWidth;
  final double startHeight;

  const AnimatedAddToCart({
    super.key,
    required this.startOffset,
    required this.endOffset,
    required this.imageUrl,
    required this.startWidth,
    required this.startHeight,
  });

  @override
  State<AnimatedAddToCart> createState() => _AnimatedAddToCartState();
}

class _AnimatedAddToCartState extends State<AnimatedAddToCart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _widthAnimation;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _positionAnimation = Tween<Offset>(
      begin: widget.startOffset,
      end: widget.endOffset,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _widthAnimation = Tween<double>(
      begin: widget.startWidth,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _heightAnimation = Tween<double>(
      begin: widget.startHeight,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _positionAnimation.value.dx,
          top: _positionAnimation.value.dy,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: SizedBox(
              width: _widthAnimation.value,
              height: _heightAnimation.value,
              child: Image.network(widget.imageUrl, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
