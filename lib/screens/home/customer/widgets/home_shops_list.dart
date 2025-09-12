import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/shop/shop_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/shop_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/public_widgets/shimmer_box.dart';
import 'package:gahezha/screens/shops/shop_details.dart';
import 'package:gahezha/screens/shops/widgets/shimmer_shop.dart';
import 'package:gahezha/screens/shops/widgets/shop_card.dart';
import 'package:iconly/iconly.dart';

class AnimatedShopsList extends StatelessWidget {
  const AnimatedShopsList({
    super.key,
    this.allShops,
    required this.allShopsDisplayNotifier,
  });

  final List<ShopModel>? allShops;
  final ValueNotifier<bool> allShopsDisplayNotifier;

  @override
  Widget build(BuildContext context) {
    return allShopsDisplayNotifier.value
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount: ShopCubit.instance.allShops.length,
            itemBuilder: (context, index) {
              final shopModel = ShopCubit.instance.allShops[index];

              // Alternate animation direction based on index
              final animation = index.isEven
                  ? FadeInRightBig(
                      duration: Duration(milliseconds: 400 + index * 150),
                      child: ShopCard(shopModel: shopModel),
                    )
                  : FadeInLeftBig(
                      duration: Duration(milliseconds: 400 + index * 150),
                      child: ShopCard(shopModel: shopModel),
                    );

              return animation;
            },
          )
        : ListView.builder(
            itemCount: 4, // number of shimmer cards to show
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              // Alternate animation direction based on index
              final animation = index.isEven
                  ? FadeInRightBig(
                      duration: Duration(milliseconds: 400 + index * 150),
                      child: const ShimmerShopCard(),
                    )
                  : FadeInLeftBig(
                      duration: Duration(milliseconds: 400 + index * 150),
                      child: const ShimmerShopCard(),
                    );

              return animation;
            },
          );
  }
}

class AnimatedDealerList extends StatelessWidget {
  const AnimatedDealerList({
    super.key,
    required this.dealerShops,
    required this.dealerShopsDisplayNotifier,
  });

  final List<ShopModel> dealerShops;
  final ValueNotifier<bool> dealerShopsDisplayNotifier;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: dealerShopsDisplayNotifier.value
          ? ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: ShopCubit.instance.hotDealerShops.length,
              itemBuilder: (context, index) {
                final dealerShop = ShopCubit.instance.hotDealerShops[index];

                return FadeInUp(
                  duration: Duration(milliseconds: 400 + index * 100),
                  child: Container(
                    width: 200,
                    margin: EdgeInsets.only(
                      right: 10,
                      left: index == 0 ? 10 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ShopDetailsPage(shopModel: dealerShop),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          dealerShop.shopBanner == null ||
                                  dealerShop.shopBanner.isEmpty
                              ? Container(
                                  width: double.infinity,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(IconlyBroken.image, size: 50),
                                  ),
                                )
                              : CustomCachedImage(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  imageUrl: dealerShop.shopBanner,
                                ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dealerShop.shopName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  children: [
                                    Text(
                                      "${dealerShop.shopCategory} · ",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      dealerShop.shopStatus
                                          ? S.current.open
                                          : S.current.closed,
                                      style: TextStyle(
                                        color: dealerShop.shopStatus
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 13,
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
                );
              },
            )
          : ListView.builder(
              itemCount: 4, // number of shimmer cards to show
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return FadeInUp(
                  duration: Duration(milliseconds: 400 + index * 100),
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 10,
                      left: index == 0 ? 10 : 0,
                    ),
                    child: ShimmerDealerShopCard(),
                  ),
                );
              },
            ),
    );
  }
}

class ShimmerDealerShopCard extends StatelessWidget {
  const ShimmerDealerShopCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Banner shimmer ---
          const ShimmerBox(width: double.infinity, height: 120),

          // --- Text placeholders ---
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // Shop name
                ShimmerBox(width: 140, height: 16),
                SizedBox(height: 6),

                // Category & status row
                ShimmerBox(width: 100, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
