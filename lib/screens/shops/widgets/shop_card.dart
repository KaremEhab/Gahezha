import 'package:flutter/material.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/shops/shop_details.dart';
import 'package:iconly/iconly.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({super.key});

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
                builder: (context) => ShopDetailsPage(shopName: S.current.shop),
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
                  flex: 3,
                  child: Stack(
                    children: [
                      // widget.productImages == null || widget.productImages.isEmpty
                      //     ? Container(
                      //   height: 160,
                      //   decoration: BoxDecoration(
                      //     color: Colors.grey.shade200,
                      //     borderRadius: const BorderRadius.vertical(
                      //       top: Radius.circular(18),
                      //     ),
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
                        imageUrl: "https://picsum.photos/500/250?random=1",
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
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                IconlyBold.delete,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- Shop Details ---
                Expanded(
                  flex: 2,
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
                                S.current.shop,
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
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                S.current.open,
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),
                        Text(
                          S.current.fresh_items_quick_delivery,
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
                            const Text(
                              "4.8",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Icon(
                              IconlyBold.time_circle,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text("25-30 ${S.current.min}"),
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
