import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/shops/shop_details.dart';
import 'package:iconly/iconly.dart';

class AnimatedShopsList extends StatelessWidget {
  const AnimatedShopsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 6,
      itemBuilder: (context, index) {
        // Alternate animation direction based on index
        final animation = index.isEven
            ? FadeInRightBig(
                duration: Duration(milliseconds: 400 + index * 150),
                child: _buildShopCard(context, index),
              )
            : FadeInLeftBig(
                duration: Duration(milliseconds: 400 + index * 150),
                child: _buildShopCard(context, index),
              );

        return animation;
      },
    );
  }

  Widget _buildShopCard(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, right: 10, left: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ShopDetailsPage(shopName: "Shop ${index + 1}"),
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
              Stack(
                children: [
                  CustomCachedImage(
                    imageUrl: "https://picsum.photos/500/250?random=$index",
                    height: 160,
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

              // --- Shop Details ---
              Padding(
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
                            "Shop ${index + 1}",
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
                          child: const Text(
                            "Open",
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
                    const Text(
                      "Fresh items & quick delivery",
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
                        const Text("25-30 min"),
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
            ],
          ),
        ),
      ),
    );
  }
}
