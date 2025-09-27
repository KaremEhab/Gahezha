import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gahezha/constants/bloc_observer.dart';
import 'package:gahezha/constants/cache_helper.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/admin/admin_cubit.dart';
import 'package:gahezha/cubits/authentication/login/login_cubit.dart';
import 'package:gahezha/cubits/authentication/signup/signup_cubit.dart';
import 'package:gahezha/cubits/cart/cart_cubit.dart';
import 'package:gahezha/cubits/locale/locale_cubit.dart';
import 'package:gahezha/cubits/order/order_cubit.dart';
import 'package:gahezha/cubits/product/product_cubit.dart';
import 'package:gahezha/cubits/profile_toggle/profile_toggle_cubit.dart';
import 'package:gahezha/cubits/report/report_cubit.dart';
import 'package:gahezha/cubits/shop/shop_cubit.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/firebase_options.dart';
import 'package:gahezha/gahezha_splash.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/theme/app_theme.dart';
import 'deep_link_service.dart';

// Navigator key for deep link navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> setupFCM() async {
  await FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();

  // Firebase Messaging token
  fcmDeviceToken = await FirebaseMessaging.instance.getToken() ?? '';

  // Cache stored data
  uId = await CacheHelper.getData(key: 'uId') ?? '';
  lang = await CacheHelper.getData(key: 'lang') ?? 'en';
  skipOnboarding = await CacheHelper.getData(key: 'skipOnboarding') ?? false;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize deep links
    DeepLinkService.instance.init(navigatorKey);
  }

  @override
  void dispose() {
    DeepLinkService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(create: (_) => SignupCubit()),
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => AdminCubit()),
        BlocProvider(create: (_) => UserCubit()),
        BlocProvider(create: (_) => ShopCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => OrderCubit()),
        BlocProvider(create: (_) => ProductCubit()),
        BlocProvider(create: (_) => ReportCubit()),
        BlocProvider(create: (_) => ProfileToggleCubit()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: buildGahezhaTheme(Brightness.light),
            locale: locale,
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            // initial route points to splash screen
            home: const GahezhaSplash(),
          );
        },
      ),
    );
  }
}

// product_page.dart
class ProductPage extends StatelessWidget {
  final String productId;
  const ProductPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product $productId')),
      body: Center(child: Text('Product ID: $productId')),
    );
  }
}

// offer_page.dart
class OfferPage extends StatelessWidget {
  final String? ref;
  const OfferPage({super.key, this.ref});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offer')),
      body: Center(child: Text('Ref: $ref')),
    );
  }
}
