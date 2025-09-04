// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `AR`
  String get ar {
    return Intl.message('AR', name: 'ar', desc: '', args: []);
  }

  /// `EN`
  String get en {
    return Intl.message('EN', name: 'en', desc: '', args: []);
  }

  /// `Discover Restaurants`
  String get discover_restaurants_title {
    return Intl.message(
      'Discover Restaurants',
      name: 'discover_restaurants_title',
      desc: '',
      args: [],
    );
  }

  /// `Find the best restaurants near you with just a few taps.`
  String get discover_restaurants_subtitle {
    return Intl.message(
      'Find the best restaurants near you with just a few taps.',
      name: 'discover_restaurants_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Make Your Order`
  String get make_your_order_title {
    return Intl.message(
      'Make Your Order',
      name: 'make_your_order_title',
      desc: '',
      args: [],
    );
  }

  /// `Choose your favorite meals and place your order instantly.`
  String get make_your_order_subtitle {
    return Intl.message(
      'Choose your favorite meals and place your order instantly.',
      name: 'make_your_order_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Order Confirmed`
  String get order_confirmed_title {
    return Intl.message(
      'Order Confirmed',
      name: 'order_confirmed_title',
      desc: '',
      args: [],
    );
  }

  /// `Get notified as soon as your order is accepted.`
  String get order_confirmed_subtitle {
    return Intl.message(
      'Get notified as soon as your order is accepted.',
      name: 'order_confirmed_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Pickup Your Order`
  String get pickup_your_order_title {
    return Intl.message(
      'Pickup Your Order',
      name: 'pickup_your_order_title',
      desc: '',
      args: [],
    );
  }

  /// `Collect your order quickly and conveniently.`
  String get pickup_your_order_subtitle {
    return Intl.message(
      'Collect your order quickly and conveniently.',
      name: 'pickup_your_order_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy Your Meal`
  String get enjoy_your_meal_title {
    return Intl.message(
      'Enjoy Your Meal',
      name: 'enjoy_your_meal_title',
      desc: '',
      args: [],
    );
  }

  /// `Eat or drink and enjoy your delicious experience.`
  String get enjoy_your_meal_subtitle {
    return Intl.message(
      'Eat or drink and enjoy your delicious experience.',
      name: 'enjoy_your_meal_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Get Started`
  String get get_started {
    return Intl.message('Get Started', name: 'get_started', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Welcome Back`
  String get welcome_back {
    return Intl.message(
      'Welcome Back',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Login to continue using Gahezha`
  String get login_continue {
    return Intl.message(
      'Login to continue using Gahezha',
      name: 'login_continue',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgot_password {
    return Intl.message(
      'Forgot Password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dont_have_account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Google`
  String get google {
    return Intl.message('Google', name: 'google', desc: '', args: []);
  }

  /// `Apple`
  String get apple {
    return Intl.message('Apple', name: 'apple', desc: '', args: []);
  }

  /// `Continue with Google`
  String get continue_with_google {
    return Intl.message(
      'Continue with Google',
      name: 'continue_with_google',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message('or', name: 'or', desc: '', args: []);
  }

  /// `Sign Up`
  String get sign_up {
    return Intl.message('Sign Up', name: 'sign_up', desc: '', args: []);
  }

  /// `Create Account`
  String get create_account {
    return Intl.message(
      'Create Account',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// `Sign up to start using Gahezha`
  String get signup_continue {
    return Intl.message(
      'Sign up to start using Gahezha',
      name: 'signup_continue',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get full_name {
    return Intl.message('Full Name', name: 'full_name', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get already_have_account {
    return Intl.message(
      'Already have an account?',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Order online, collect in no time 📦`
  String get home_catchy_text {
    return Intl.message(
      'Order online, collect in no time 📦',
      name: 'home_catchy_text',
      desc: '',
      args: [],
    );
  }

  /// `You have 2 orders to pickup`
  String get home_active_orders {
    return Intl.message(
      'You have 2 orders to pickup',
      name: 'home_active_orders',
      desc: '',
      args: [],
    );
  }

  /// `Restaurant`
  String get restaurant {
    return Intl.message('Restaurant', name: 'restaurant', desc: '', args: []);
  }

  /// `Restaurants`
  String get restaurants {
    return Intl.message('Restaurants', name: 'restaurants', desc: '', args: []);
  }

  /// `Fast food • 20 mins`
  String get home_restaurant_subtitle {
    return Intl.message(
      'Fast food • 20 mins',
      name: 'home_restaurant_subtitle',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
