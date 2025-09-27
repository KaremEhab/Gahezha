import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:gahezha/gahezha_splash.dart';
import 'package:gahezha/main.dart';
import 'package:gahezha/screens/authentication/signup.dart';
import 'package:gahezha/screens/home/customer/customer_home.dart';

class DeepLinkService {
  DeepLinkService._private();
  static final DeepLinkService instance = DeepLinkService._private();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  /// Initialize deep link listening
  Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    // Handle cold start
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri, navigatorKey);
      }
    } catch (e, st) {
      debugPrint('DeepLinkService.getInitialLink() failed: $e\n$st');
    }

    // Handle warm/foreground links
    _sub = _appLinks.uriLinkStream.listen(
      (uri) => _handleUri(uri, navigatorKey),
      onError: (err) => debugPrint('Deep link stream error: $err'),
    );
  }

  // DeepLinkService.dart
  void _handleUri(Uri uri, GlobalKey<NavigatorState> navKey) {
    debugPrint('DeepLinkService: received $uri');
    final nav = navKey.currentState;
    if (nav == null) {
      Future.microtask(() => _handleUri(uri, navKey));
      return;
    }

    final pathSegments = uri.pathSegments;

    // Example: https://deep-link-hosting.vercel.app/create-shop?ref=abc123
    if (pathSegments.isNotEmpty && pathSegments[0] == 'create-shop') {
      debugPrint('Incoming deep link: $uri');
      debugPrint('Query params: ${uri.queryParameters}');

      final referrerId = uri.queryParameters['ref'];
      nav.pushReplacement(
        MaterialPageRoute(
          builder: (_) => Signup(isShop: true, referrerId: referrerId!),
        ),
      );
      return;
    }

    // Optional: handle other links like /offer
    if (pathSegments.isNotEmpty && pathSegments[0] == 'offer') {
      final ref = uri.queryParameters['ref'];
      nav.push(MaterialPageRoute(builder: (_) => OfferPage(ref: ref)));
      return;
    }

    // Default fallback -> Home
    nav.push(MaterialPageRoute(builder: (_) => const GahezhaSplash()));
  }

  void dispose() {
    _sub?.cancel();
  }
}
