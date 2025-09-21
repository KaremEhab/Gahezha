import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/cart/cart_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/authentication/signup.dart';
import 'package:gahezha/screens/cart/checkout.dart';
import 'package:iconly/iconly.dart';

class CartPopup extends StatefulWidget {
  const CartPopup({super.key});

  @override
  State<CartPopup> createState() => _CartPopupState();
}

class _CartPopupState extends State<CartPopup> {
  /// Keep track of expanded shops
  final Set<int> _expandedShops = {};

  @override
  void initState() {
    super.initState();
    // Fetch cart when popup opens
    CartCubit.instance.getCart();
  }

  @override
  void dispose() {
    CartCubit.instance.resetCart();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Hero(
          tag: "cartHero",
          child: Material(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            S.current.your_cart,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),

                  if (currentUserType != UserType.guest) ...[
                    // ✅ Cart Items
                    Expanded(
                      flex: 11,
                      child: BlocBuilder<CartCubit, CartState>(
                        bloc: CartCubit.instance,
                        builder: (context, state) {
                          if (state is CartLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is CartError) {
                            return Center(child: Text(state.error));
                          } else if (state is CartLoaded) {
                            if (state.cartShops.isEmpty) {
                              return Center(
                                child: Text(
                                  S.current.no_products_yet,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              itemCount: state.cartShops.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, shopIndex) {
                                final shop = state.cartShops[shopIndex];
                                final isExpanded = _expandedShops.contains(
                                  shopIndex,
                                );

                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: isExpanded ? 10 : 5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Shop Header
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: Material(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(
                                            radius,
                                          ),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              radius,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                if (isExpanded) {
                                                  _expandedShops.remove(
                                                    shopIndex,
                                                  );
                                                } else {
                                                  _expandedShops.add(shopIndex);
                                                }
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 10,
                                                  ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 20,
                                                        child: CustomCachedImage(
                                                          imageUrl:
                                                              shop.shopLogo,
                                                          height:
                                                              double.infinity,
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
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      AnimatedRotation(
                                                        turns: isExpanded
                                                            ? 0.5
                                                            : 0, // rotate arrow
                                                        duration:
                                                            const Duration(
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

                                      // 🔹 Shop orders (expand only if the shop is expanded)
                                      if (isExpanded)
                                        ...shop.orders.map((order) {
                                          return Padding(
                                            padding: EdgeInsets.only(bottom: 5),
                                            child: Material(
                                              color: Colors.grey.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadiusDirectional.circular(
                                                    radius,
                                                  ),
                                              child: ListTile(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                    ),
                                                leading: SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              radius,
                                                            ),
                                                        child: Image.network(
                                                          order.productUrl,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      if (order.quantity > 1)
                                                        Center(
                                                          child: CircleAvatar(
                                                            radius: 15,
                                                            backgroundColor:
                                                                Colors.white,
                                                            child: Center(
                                                              child: Text(
                                                                order.quantity >
                                                                        99
                                                                    ? "+99"
                                                                    : order
                                                                          .quantity
                                                                          .toString(),
                                                                style: TextStyle(
                                                                  color:
                                                                      primaryBlue,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                title: Text(order.name),
                                                subtitle: Wrap(
                                                  spacing: 4,
                                                  runSpacing: 2,
                                                  children: [
                                                    if (order
                                                            .specifications
                                                            .isNotEmpty ||
                                                        order
                                                            .selectedAddOns
                                                            .isNotEmpty)
                                                      Text(
                                                        [
                                                          // Specs
                                                          ...order.specifications.expand(
                                                            (
                                                              spec,
                                                            ) => spec.entries.map((
                                                              e,
                                                            ) {
                                                              final allValues = e
                                                                  .value
                                                                  .map(
                                                                    (
                                                                      v,
                                                                    ) => v['name']
                                                                        .toString(),
                                                                  )
                                                                  .toList();
                                                              return allValues
                                                                  .join(', ');
                                                            }),
                                                          ),
                                                          // Add-ons
                                                          ...order
                                                              .selectedAddOns
                                                              .map(
                                                                (a) =>
                                                                    "${a['name']}",
                                                              ),
                                                        ].join(
                                                          ' | ',
                                                        ), // single line with | between everything
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                trailing: Text(
                                                  "${S.current.sar} ${order.totalPrice.toStringAsFixed(2)}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ✅ Checkout Button
                    BlocBuilder<CartCubit, CartState>(
                      bloc: CartCubit.instance,
                      builder: (context, state) {
                        if (state is CartLoaded && state.cartShops.isNotEmpty) {
                          return ElevatedButton(
                            onPressed: () {
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "${S.current.checkout} ${S.current.sar} ${state.totalCart.toStringAsFixed(2)}",
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ] else ...[
                    // Guest view
                    Expanded(
                      flex: 11,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  IconlyLight.lock,
                                  size: 80,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'You need an account to see your cart items',
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
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
