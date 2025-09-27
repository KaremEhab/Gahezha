import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gahezha/constants/cache_helper.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/admin/admin_cubit.dart';
import 'package:gahezha/cubits/shop/shop_cubit.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/firebase_options.dart';
import 'package:gahezha/main.dart';
import 'package:gahezha/models/shop_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/authentication/login.dart';
import 'package:gahezha/screens/layout/layout.dart';
import 'package:gahezha/screens/onboarding/onboarding_screen.dart';
import 'package:gahezha/waiting_for_approval.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GahezhaSplash extends StatefulWidget {
  const GahezhaSplash({super.key});

  @override
  State<GahezhaSplash> createState() => _GahezhaSplashState();
}

class _GahezhaSplashState extends State<GahezhaSplash> {
  @override
  void initState() {
    super.initState();
    _setupAndNavigate();
  }

  Future<void> _setupAndNavigate() async {
    if (uId.isNotEmpty) {
      UserType? type;
      DocumentSnapshot<Map<String, dynamic>>? doc;

      // 1️⃣ Check Shops collection
      final shopDoc = await FirebaseFirestore.instance
          .collection('shops')

          .doc(uId)
          .get();
      if (shopDoc.exists) {
        type = UserType.shop;
        doc = shopDoc;
        await ShopCubit.instance.getCurrentShop();
      }

      // 2️⃣ Check Users collection if not shop
      if (type == null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .get();
        if (userDoc.exists) {
          type = UserType.values.firstWhere(
            (e) => e.name == userDoc.data()!['userType'], // customer / guest
            orElse: () => UserType.customer,
          );
          doc = userDoc;
          await UserCubit.instance.getCurrentUser();
        }
      }

      // 3️⃣ Check Admins collection if not shop or user
      if (type == null) {
        final adminDoc = await FirebaseFirestore.instance
            .collection('admins')
            .doc(uId)
            .get();
        if (adminDoc.exists) {
          type = UserType.admin;
          doc = adminDoc;
          await AdminCubit.instance.getCurrentAdmin();
        }
      }

      if (type != null) {
        currentUserType = type;
        await CacheHelper.saveData(
          key: "currentUserType",
          value: currentUserType.name,
        );
      } else {
        // لو الحساب غير موجود في أي collection
        uId = '';
      }
    }

    // Delay for splash animation
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    if (uId.isEmpty && !skipOnboarding) {
      navigateAndFinish(context: context, screen: const Onboarding());
    } else if (uId.isEmpty && skipOnboarding) {
      navigateAndFinish(context: context, screen: const Login());
      await GoogleSignIn().signOut();
    } else {
      if (currentUserType == UserType.shop) {
        if (currentShopModel!.shopAcceptanceStatus ==
            ShopAcceptanceStatus.accepted) {
          log('user id: $uId');
          navigateAndFinish(context: context, screen: const Layout());
        } else {
          if (!mounted) return;
          navigateAndFinish(
            context: context,
            screen: const WaitingForApprovalPage(),
          );
        }
      } else {
        log('user id: $uId');
        navigateAndFinish(context: context, screen: const Layout());
      }
    }

    log("accessToken: $accessToken -----------------------");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        titleSpacing: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [SvgPicture.asset('assets/images/logo.svg')],
          ),
        ),
      ),
    );
  }
}
