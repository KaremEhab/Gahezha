import 'package:flutter/material.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/shop_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/shops/shop_details.dart';
import 'package:iconly/iconly.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({super.key, this.shopModel});

  final ShopModel? shopModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        height: 270,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShopDetailsPage(shopModel: shopModel!),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Shop Image with gradient & overlay ---
                Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      shopModel!.shopBanner == null ||
                              shopModel!.shopBanner.isEmpty
                          ? Container(
                              height: 160,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(18),
                                ),
                              ),
                              child: Center(
                                child: Icon(IconlyBroken.image, size: 50),
                              ),
                            )
                          : CustomCachedImage(
                              imageUrl: shopModel!.shopBanner,
                              height: double.infinity,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(18),
                              ),
                            ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.5),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                      // Positioned(
                      //   top: 10,
                      //   right: 10,
                      //   child: Material(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(50),
                      //     child: InkWell(
                      //       borderRadius: BorderRadius.circular(50),
                      //       onTap: () {},
                      //       child: const Padding(
                      //         padding: EdgeInsets.all(8),
                      //         child: Icon(
                      //           IconlyBold.delete,
                      //           color: Colors.redAccent,
                      //           size: 20,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),

                // --- Shop Details ---
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Row
                        Row(
                          children: [
                            const Icon(
                              Icons.storefront,
                              color: Colors.blueAccent,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                shopModel!.shopName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: shopModel!.shopStatus
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                shopModel!.shopStatus
                                    ? S.current.open
                                    : S.current.closed,
                                style: TextStyle(
                                  color: shopModel!.shopStatus
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),
                        Text(
                          "${shopModel!.shopCategory} · ${S.current.opening_hours}: ${shopModel!.openingHoursFrom} ${S.current.am} - ${shopModel!.openingHoursTo} ${S.current.pm}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Info Row
                        Row(
                          children: [
                            const Icon(
                              IconlyBold.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              shopModel!.shopRate.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Icon(
                              IconlyLight.time_circle,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${shopModel!.preparingTimeFrom}-${shopModel!.preparingTimeTo} ${S.current.min}",
                            ),
                            const Spacer(),

                            // Gradient CTA
                            // Container(
                            //   decoration: BoxDecoration(
                            //     gradient: LinearGradient(
                            //       colors: [
                            //         primaryBlue,
                            //         primaryBlue.withOpacity(0.7),
                            //       ],
                            //     ),
                            //     borderRadius: BorderRadius.circular(10),
                            //   ),
                            //   child: Material(
                            //     color: Colors.transparent,
                            //     child: InkWell(
                            //       borderRadius: BorderRadius.circular(10),
                            //       onTap: () {},
                            //       child: const Padding(
                            //         padding: EdgeInsets.symmetric(
                            //           horizontal: 14,
                            //           vertical: 8,
                            //         ),
                            //         child: Text(
                            //           "Order Now",
                            //           style: TextStyle(
                            //             color: Colors.white,
                            //             fontWeight: FontWeight.w600,
                            //             fontSize: 13,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
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
      ),
    );
  }
}
