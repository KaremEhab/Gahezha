import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/firebase_options.dart';
import 'package:gahezha/main.dart';
import 'package:gahezha/screens/authentication/login.dart';
import 'package:gahezha/screens/layout/layout.dart';
import 'package:gahezha/screens/onboarding/onboarding_screen.dart';
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
    await setupFCM();

    // لو في uid موجود مسبقاً
    if (uId.isNotEmpty) {
      await UserCubit.instance.getCurrentUser();
    }

    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    if (uId.isEmpty && !skipOnboarding) {
      navigateAndFinish(context: context, screen: const Onboarding());
    } else if (uId.isEmpty && skipOnboarding) {
      navigateAndFinish(context: context, screen: const Login());
      await GoogleSignIn().signOut();
    } else {
      navigateAndFinish(context: context, screen: const Layout());
    }
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
