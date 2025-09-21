import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/order/order_cubit.dart';
import 'package:gahezha/cubits/profile_toggle/profile_toggle_cubit.dart';
import 'package:gahezha/cubits/profile_toggle/profile_toggle_state.dart';
import 'package:gahezha/cubits/shop/shop_cubit.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/cubits/user/user_state.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/authentication/signup.dart';
import 'package:gahezha/screens/home/customer/widgets/active_orders_sheet.dart';
import 'package:gahezha/screens/home/customer/widgets/home_shops_list.dart';
import 'package:gahezha/screens/notifications/notifications.dart';
import 'package:gahezha/screens/shops/shop_details.dart';
import 'package:iconly/iconly.dart';
import 'package:animate_do/animate_do.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage>
    with AutomaticKeepAliveClientMixin<CustomerHomePage> {
  @override
  bool get wantKeepAlive => true;

  ValueNotifier<bool> allShopsDisplayNotifier = ValueNotifier(false);
  ValueNotifier<bool> dealerShopsDisplayNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    // ShopCubit.instance.getHotDealerShops();
    final orderCubit = OrderCubit.instance;
    orderCubit.getPickupOrdersStream(currentUserModel!.userId);
    ShopCubit.instance.customerGetAllShops();
  }

  @override
  void dispose() {
    // Cancel the pickup orders subscription
    OrderCubit.instance.pickupOrdersSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {
        if (state is AllShopsLoaded) {
          allShopsDisplayNotifier.value = true;
          dealerShopsDisplayNotifier.value = true;
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // ---------------- SliverAppBar ----------------
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    backgroundColor: Colors.white,
                    forceMaterialTransparency: true,
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    titleSpacing: 0,
                    flexibleSpace: Material(
                      color: Colors.white,
                      child: Column(
                        children: [
                          const SafeArea(child: SizedBox()),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BlocBuilder<
                                  ProfileToggleCubit,
                                  HomeToggleState
                                >(
                                  builder: (context, state) {
                                    return GestureDetector(
                                      onTap: () {
                                        ProfileToggleCubit.instance
                                            .homeProfileButtonToggle();
                                      },
                                      child: BlocBuilder<UserCubit, UserState>(
                                        builder: (context, state) {
                                          if (state is UserLoaded) {
                                            return CircleAvatar(
                                              radius: 22,
                                              backgroundColor:
                                                  Colors.grey.shade300,
                                              child: CircleAvatar(
                                                radius: 20,
                                                child: CustomCachedImage(
                                                  imageUrl: currentUserModel!
                                                      .profileUrl,
                                                  height: double.infinity,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        200,
                                                      ),
                                                ),
                                              ),
                                            );
                                          }
                                          return SizedBox.shrink();
                                        },
                                      ),
                                    );
                                  },
                                ),
                                SvgPicture.asset(
                                  'assets/images/logo.svg',
                                  height: 28,
                                ),
                                Stack(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const NotificationsPage(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        IconlyLight.notification,
                                        size: 28,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Positioned(
                                      right: 10,
                                      top: 10,
                                      child: Container(
                                        height: 10,
                                        width: 10,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
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
                  ),

                  // ---------------- Body ----------------
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Catchy Text
                          FadeInDown(
                            duration: const Duration(milliseconds: 600),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                S.current.home_catchy_text,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Active Orders Card
                          BlocConsumer<OrderCubit, OrderState>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              return FadeInUp(
                                duration: const Duration(milliseconds: 600),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          primaryBlue.withOpacity(0.8),
                                          primaryBlue.withOpacity(0.5),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryBlue.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(18),
                                        onTap: () {
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
                                          } else {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                      top: Radius.circular(
                                                        sheetRadius,
                                                      ),
                                                    ),
                                              ),
                                              builder: (context) =>
                                                  const ActiveOrdersBottomSheet(),
                                            );
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(18),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                IconlyBold.bag,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              const SizedBox(width: 14),
                                              Expanded(
                                                child: Text(
                                                  currentUserType ==
                                                          UserType.guest
                                                      ? "See your active orders"
                                                      : "${S.current.you_have} ${OrderCubit.instance.activeOrders} ${S.current.orders_to_pickup}", // replaced text
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 18,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 30),
                          // Hot Dealers Section
                          if (ShopCubit.instance.hotDealerShops.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                "🔥 ${S.current.hot_dealers}",
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 16),

                            AnimatedDealerList(
                              dealerShopsDisplayNotifier:
                                  dealerShopsDisplayNotifier,
                              dealerShops: ShopCubit.instance.hotDealerShops,
                            ),

                            const SizedBox(height: 20),
                          ],

                          // Recommended Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "⭐ ${S.current.recommended}",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 16),

                          AnimatedShopsList(
                            allShopsDisplayNotifier: allShopsDisplayNotifier,
                            allShops: ShopCubit.instance.allShops,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
