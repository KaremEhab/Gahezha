import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gahezha/screens/onboarding/onboarding_screen.dart';

class GahezhaSplash extends StatefulWidget {
  const GahezhaSplash({super.key});

  @override
  State<GahezhaSplash> createState() => _GahezhaSplashState();
}

class _GahezhaSplashState extends State<GahezhaSplash> {
  @override
  void initState() {
    super.initState();

    // Delay 4 seconds then navigate
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return; // prevent calling after widget disposed
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Onboarding()),
      );
    });
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
