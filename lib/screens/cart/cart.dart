import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/cart/cart_cubit.dart';
import 'package:gahezha/cubits/shop/shop_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/product_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/authentication/signup.dart';
import 'package:gahezha/screens/cart/checkout.dart';
import 'package:gahezha/screens/home/customer/customer_home.dart';
import 'package:gahezha/screens/layout/layout.dart';
import 'package:gahezha/screens/products/customer/widgets/product_details_sheet.dart';
import 'package:iconly/iconly.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  double totalCartPrice = 0;

  /// Keep track of expanded shops
  final Set<int> _expandedShops = {};

  @override
  void initState() {
    super.initState();
    // Fetch cart when page opens
    CartCubit.instance.getCart();
  }

  @override
  void dispose() {
    CartCubit.instance.resetCart();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      bloc: CartCubit.instance,
      builder: (context, state) {
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
                        onTap: () {
                          CartCubit.instance.clearCart();
                        },
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
                      onTap: () {
                        // Switch to Home page
                        final layoutState = context
                            .findAncestorStateOfType<LayoutState>();
                        layoutState?.onItemTapped(0); // go to Home page

                        // Optional: you can also scroll to top or refresh the home page
                        if (layoutState?.pages[0] is CustomerHomePage) {
                          ShopCubit.instance
                              .customerGetAllShops(); // refresh shops
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Icon(
                          IconlyLight.buy,
                          size: 16,
                        ), // changed icon to Home
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (state is CartLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CartError) {
                return Center(child: Text(state.error));
              } else if (state is CartLoaded) {
                double totalPrice = 0;
                for (var shop in state.cartShops) {
                  for (var item in shop.orders) {
                    totalPrice +=
                        item.totalPrice; // Make sure totalPrice is double
                  }
                }
                totalCartPrice = totalPrice;
                if (state.cartShops.isEmpty) {
                  return buildEmptyView(
                    S.current.no_products_yet,
                    S.current.once_you_add_products_cart,
                    IconlyLight.buy,
                  );
                }
                return Builder(
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
                    } else {
                      // Show cart content
                      return ListView.builder(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.cartShops.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 80),
                        itemBuilder: (context, shopIndex) {
                          final shop = state.cartShops[shopIndex];
                          final isExpanded = _expandedShops.contains(shopIndex);
                          return Column(
                            children: [
                              // Shop Header
                              Padding(
                                padding: const EdgeInsets.fromLTRB(7, 10, 7, 5),
                                child: Material(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(radius),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(radius),
                                    onTap: () {
                                      setState(() {
                                        if (isExpanded) {
                                          _expandedShops.remove(shopIndex);
                                        } else {
                                          _expandedShops.add(shopIndex);
                                        }
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
                                                  imageUrl: shop.shopLogo,
                                                  height: double.infinity,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        200,
                                                      ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                shop.shopName,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${shop.orders.length} ${S.current.items}",
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              AnimatedRotation(
                                                turns: isExpanded
                                                    ? 0.5
                                                    : 0, // rotate arrow
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
                                                child: const Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
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
                              if (isExpanded)
                                ...shop.orders.map((item) {
                                  return Padding(
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
                                              (item.productUrl == null ||
                                                      item.productUrl.isEmpty)
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            radius,
                                                          ),
                                                      child: SizedBox(
                                                        width: 60,
                                                        height: 60,
                                                        child: Center(
                                                          child: const Icon(
                                                            IconlyBroken.image,
                                                            size: 20,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : CustomCachedImage(
                                                      imageUrl: item.productUrl,
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
                                                      item.name,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "${S.current.sar} ${item.totalPrice}",
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
                                                        CartCubit.instance
                                                            .decrementCartItem(
                                                              shop.shopId,
                                                              item.cartId,
                                                            );
                                                      },
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            radius,
                                                          ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 6,
                                                            ),
                                                        child: Icon(
                                                          item.quantity > 1
                                                              ? Icons.remove
                                                              : IconlyBold
                                                                    .delete,
                                                          size: 18,
                                                          color:
                                                              item.quantity > 1
                                                              ? primaryBlue
                                                              : Colors.red,
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
                                                        '${item.quantity}',
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
                                                        CartCubit.instance
                                                            .incrementCartItem(
                                                              shop.shopId,
                                                              item.cartId,
                                                            );
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
                                  );
                                }).toList(),
                            ],
                          );
                        },
                      );
                    }
                  },
                );
              }
              return SizedBox();
            },
          ),
          // Total & Checkout
          bottomNavigationBar: state is CartLoaded
              ? Container(
                  margin: const EdgeInsets.all(10),
                  height: 65,
                  child: Material(
                    borderRadius: BorderRadius.circular(radius),
                    color: primaryBlue,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(radius),
                      onTap: () {
                        if (currentUserType == UserType.guest) {
                          navigateTo(
                            context: context,
                            screen: Signup(isGuestMode: true),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutPage(
                                total: state.totalCart,
                                cartShops: state.cartShops,
                              ),
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
                                    '${S.current.sar} ${state.totalCart.toStringAsFixed(2)}',
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
                                const Icon(
                                  IconlyLight.buy,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        );
      },
    );
  }
}
