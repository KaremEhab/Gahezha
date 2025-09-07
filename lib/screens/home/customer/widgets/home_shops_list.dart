import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/shops/shop_details.dart';
import 'package:gahezha/screens/shops/widgets/shop_card.dart';
import 'package:iconly/iconly.dart';

class AnimatedShopsList extends StatelessWidget {
  const AnimatedShopsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 10),
      itemCount: 6,
      itemBuilder: (context, index) {
        // Alternate animation direction based on index
        final animation = index.isEven
            ? FadeInRightBig(
                duration: Duration(milliseconds: 400 + index * 150),
                child: ShopCard(),
              )
            : FadeInLeftBig(
                duration: Duration(milliseconds: 400 + index * 150),
                child: ShopCard(),
              );

        return animation;
      },
    );
  }
}
