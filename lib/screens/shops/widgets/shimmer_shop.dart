import 'package:flutter/material.dart';
import 'package:gahezha/public_widgets/shimmer_box.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerShopCard extends StatelessWidget {
  const ShimmerShopCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        height: 270,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Image placeholder ---
              Expanded(
                flex: 4,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // --- Details placeholder ---
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
                          ShimmerBox(width: 120, height: 16),
                          const Spacer(),
                          ShimmerBox(width: 50, height: 16),
                        ],
                      ),
                      const SizedBox(height: 10),

                      ShimmerBox(width: double.infinity, height: 14),
                      const SizedBox(height: 6),
                      ShimmerBox(width: 180, height: 14),

                      const Spacer(),

                      // Bottom Row
                      Row(
                        children: [
                          ShimmerBox(width: 40, height: 14),
                          const SizedBox(width: 14),
                          ShimmerBox(width: 60, height: 14),
                          const Spacer(),
                          ShimmerBox(width: 80, height: 30, borderRadius: 10),
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
  }
}
