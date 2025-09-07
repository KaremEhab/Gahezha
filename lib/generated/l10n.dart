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

  /// `Discover Shops & Restaurants`
  String get discover_shops_title {
    return Intl.message(
      'Discover Shops & Restaurants',
      name: 'discover_shops_title',
      desc: '',
      args: [],
    );
  }

  /// `Find the best shops and restaurants near you with just a few taps.`
  String get discover_shops_subtitle {
    return Intl.message(
      'Find the best shops and restaurants near you with just a few taps.',
      name: 'discover_shops_subtitle',
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

  /// `Choose your favorite products or meals and place your order instantly.`
  String get make_your_order_subtitle {
    return Intl.message(
      'Choose your favorite products or meals and place your order instantly.',
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

  /// `Enjoy Your Order`
  String get enjoy_your_order_title {
    return Intl.message(
      'Enjoy Your Order',
      name: 'enjoy_your_order_title',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy your products or meals with a great experience.`
  String get enjoy_your_order_subtitle {
    return Intl.message(
      'Enjoy your products or meals with a great experience.',
      name: 'enjoy_your_order_subtitle',
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
  String get confirm_password_title {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password_title',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter your password`
  String get confirm_password {
    return Intl.message(
      'Re-enter your password',
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

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Edit Profile`
  String get edit_profile {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `App Settings`
  String get app_settings {
    return Intl.message(
      'App Settings',
      name: 'app_settings',
      desc: '',
      args: [],
    );
  }

  /// `Account Settings`
  String get account_settings {
    return Intl.message(
      'Account Settings',
      name: 'account_settings',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Change Email`
  String get change_email {
    return Intl.message(
      'Change Email',
      name: 'change_email',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get change_password {
    return Intl.message(
      'Change Password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Privacy & Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy & Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Change Your Email`
  String get change_your_email_title {
    return Intl.message(
      'Change Your Email',
      name: 'change_your_email_title',
      desc: '',
      args: [],
    );
  }

  /// `Update your email address by entering your new email and password details below.`
  String get change_your_email_subtitle {
    return Intl.message(
      'Update your email address by entering your new email and password details below.',
      name: 'change_your_email_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Change Your Password`
  String get change_your_password_title {
    return Intl.message(
      'Change Your Password',
      name: 'change_your_password_title',
      desc: '',
      args: [],
    );
  }

  /// `Update your password address by entering your new password below.`
  String get change_your_password_subtitle {
    return Intl.message(
      'Update your password address by entering your new password below.',
      name: 'change_your_password_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Old email`
  String get old_email_title {
    return Intl.message(
      'Old email',
      name: 'old_email_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter your old email`
  String get old_email {
    return Intl.message(
      'Enter your old email',
      name: 'old_email',
      desc: '',
      args: [],
    );
  }

  /// `New email`
  String get new_email_title {
    return Intl.message(
      'New email',
      name: 'new_email_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new email`
  String get new_email {
    return Intl.message(
      'Enter your new email',
      name: 'new_email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your old password`
  String get old_password {
    return Intl.message(
      'Enter your old password',
      name: 'old_password',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get new_password_title {
    return Intl.message(
      'New password',
      name: 'new_password_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new password`
  String get new_password {
    return Intl.message(
      'Enter your new password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enter_your_email {
    return Intl.message(
      'Enter your email',
      name: 'enter_your_email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enter_your_password {
    return Intl.message(
      'Enter your password',
      name: 'enter_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Your email change request has been submitted successfully.`
  String get email_change_submitted {
    return Intl.message(
      'Your email change request has been submitted successfully.',
      name: 'email_change_submitted',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get delete_account {
    return Intl.message(
      'Delete Account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Save Changes`
  String get save_changes {
    return Intl.message(
      'Save Changes',
      name: 'save_changes',
      desc: '',
      args: [],
    );
  }

  /// `At Gahezha, your privacy is very important to us. This Privacy Policy explains how we collect, use, and protect your information when you use our app and services.`
  String get privacy_intro {
    return Intl.message(
      'At Gahezha, your privacy is very important to us. This Privacy Policy explains how we collect, use, and protect your information when you use our app and services.',
      name: 'privacy_intro',
      desc: '',
      args: [],
    );
  }

  /// `1. Information We Collect`
  String get privacy_section1_title {
    return Intl.message(
      '1. Information We Collect',
      name: 'privacy_section1_title',
      desc: '',
      args: [],
    );
  }

  /// `• Personal details such as your name, email address, phone number.\n• Data related to your shop, orders, and products.\n• Usage information including app interactions and device details.`
  String get privacy_section1_desc {
    return Intl.message(
      '• Personal details such as your name, email address, phone number.\n• Data related to your shop, orders, and products.\n• Usage information including app interactions and device details.',
      name: 'privacy_section1_desc',
      desc: '',
      args: [],
    );
  }

  /// `2. How We Use Your Information`
  String get privacy_section2_title {
    return Intl.message(
      '2. How We Use Your Information',
      name: 'privacy_section2_title',
      desc: '',
      args: [],
    );
  }

  /// `• To provide and improve our services.\n• To process your orders.\n• To communicate with you regarding updates, promotions, and support.\n• To comply with legal obligations.`
  String get privacy_section2_desc {
    return Intl.message(
      '• To provide and improve our services.\n• To process your orders.\n• To communicate with you regarding updates, promotions, and support.\n• To comply with legal obligations.',
      name: 'privacy_section2_desc',
      desc: '',
      args: [],
    );
  }

  /// `3. Data Sharing`
  String get privacy_section3_title {
    return Intl.message(
      '3. Data Sharing',
      name: 'privacy_section3_title',
      desc: '',
      args: [],
    );
  }

  /// `We do not sell or rent your personal data. We may share your information with trusted third parties such as delivery partners, and legal authorities when required.`
  String get privacy_section3_desc {
    return Intl.message(
      'We do not sell or rent your personal data. We may share your information with trusted third parties such as delivery partners, and legal authorities when required.',
      name: 'privacy_section3_desc',
      desc: '',
      args: [],
    );
  }

  /// `4. Data Security`
  String get privacy_section4_title {
    return Intl.message(
      '4. Data Security',
      name: 'privacy_section4_title',
      desc: '',
      args: [],
    );
  }

  /// `We implement strong security measures to protect your data. However, no method of transmission or storage is 100% secure, and we cannot guarantee absolute security.`
  String get privacy_section4_desc {
    return Intl.message(
      'We implement strong security measures to protect your data. However, no method of transmission or storage is 100% secure, and we cannot guarantee absolute security.',
      name: 'privacy_section4_desc',
      desc: '',
      args: [],
    );
  }

  /// `5. Your Rights`
  String get privacy_section5_title {
    return Intl.message(
      '5. Your Rights',
      name: 'privacy_section5_title',
      desc: '',
      args: [],
    );
  }

  /// `You may update or delete your personal information at any time through your account settings or by contacting our support team.`
  String get privacy_section5_desc {
    return Intl.message(
      'You may update or delete your personal information at any time through your account settings or by contacting our support team.',
      name: 'privacy_section5_desc',
      desc: '',
      args: [],
    );
  }

  /// `6. Changes to This Policy`
  String get privacy_section6_title {
    return Intl.message(
      '6. Changes to This Policy',
      name: 'privacy_section6_title',
      desc: '',
      args: [],
    );
  }

  /// `We may update this Privacy Policy from time to time. Any changes will be reflected in the app, and continued use means you agree to the updated terms.`
  String get privacy_section6_desc {
    return Intl.message(
      'We may update this Privacy Policy from time to time. Any changes will be reflected in the app, and continued use means you agree to the updated terms.',
      name: 'privacy_section6_desc',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get privacy_contact_title {
    return Intl.message(
      'Contact Us',
      name: 'privacy_contact_title',
      desc: '',
      args: [],
    );
  }

  /// `If you have any questions about this Privacy Policy, please contact us at support@gahezha.com`
  String get privacy_contact_desc {
    return Intl.message(
      'If you have any questions about this Privacy Policy, please contact us at support@gahezha.com',
      name: 'privacy_contact_desc',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message('Checkout', name: 'checkout', desc: '', args: []);
  }

  /// `Place Order`
  String get place_order {
    return Intl.message('Place Order', name: 'place_order', desc: '', args: []);
  }

  /// `Product`
  String get product {
    return Intl.message('Product', name: 'product', desc: '', args: []);
  }

  /// `Products`
  String get products {
    return Intl.message('Products', name: 'products', desc: '', args: []);
  }

  /// `Qty`
  String get quantity {
    return Intl.message('Qty', name: 'quantity', desc: '', args: []);
  }

  /// `Cart`
  String get cart {
    return Intl.message('Cart', name: 'cart', desc: '', args: []);
  }

  /// `My Cart`
  String get my_cart {
    return Intl.message('My Cart', name: 'my_cart', desc: '', args: []);
  }

  /// `Your Cart`
  String get your_cart {
    return Intl.message('Your Cart', name: 'your_cart', desc: '', args: []);
  }

  /// `Your cart is empty`
  String get your_cart_is_empty {
    return Intl.message(
      'Your cart is empty',
      name: 'your_cart_is_empty',
      desc: '',
      args: [],
    );
  }

  /// `item`
  String get item {
    return Intl.message('item', name: 'item', desc: '', args: []);
  }

  /// `items`
  String get items {
    return Intl.message('items', name: 'items', desc: '', args: []);
  }

  /// `Total Price`
  String get total_price {
    return Intl.message('Total Price', name: 'total_price', desc: '', args: []);
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Prepare Your Order`
  String get prepare_your_order {
    return Intl.message(
      'Prepare Your Order',
      name: 'prepare_your_order',
      desc: '',
      args: [],
    );
  }

  /// `We are preparing your order`
  String get we_are_preparing_your_order {
    return Intl.message(
      'We are preparing your order',
      name: 'we_are_preparing_your_order',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get order {
    return Intl.message('Order', name: 'order', desc: '', args: []);
  }

  /// `Orders`
  String get orders {
    return Intl.message('Orders', name: 'orders', desc: '', args: []);
  }

  /// `Your order`
  String get your_order {
    return Intl.message('Your order', name: 'your_order', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Accepted`
  String get accepted {
    return Intl.message('Accepted', name: 'accepted', desc: '', args: []);
  }

  /// `Rejected`
  String get rejected {
    return Intl.message('Rejected', name: 'rejected', desc: '', args: []);
  }

  /// `PREPARING`
  String get preparing {
    return Intl.message('PREPARING', name: 'preparing', desc: '', args: []);
  }

  /// `Pickup`
  String get pickup {
    return Intl.message('Pickup', name: 'pickup', desc: '', args: []);
  }

  /// `Delivered`
  String get delivered {
    return Intl.message('Delivered', name: 'delivered', desc: '', args: []);
  }

  /// `Placed on`
  String get placed_on {
    return Intl.message('Placed on', name: 'placed_on', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Viewing details of order`
  String get viewing_details_of_order {
    return Intl.message(
      'Viewing details of order',
      name: 'viewing_details_of_order',
      desc: '',
      args: [],
    );
  }

  /// `Active Orders`
  String get active_orders {
    return Intl.message(
      'Active Orders',
      name: 'active_orders',
      desc: '',
      args: [],
    );
  }

  /// `Hot Dealers`
  String get hot_dealers {
    return Intl.message('Hot Dealers', name: 'hot_dealers', desc: '', args: []);
  }

  /// `Dealer`
  String get dealer {
    return Intl.message('Dealer', name: 'dealer', desc: '', args: []);
  }

  /// `Special Offer`
  String get special_offer {
    return Intl.message(
      'Special Offer',
      name: 'special_offer',
      desc: '',
      args: [],
    );
  }

  /// `Limited Time`
  String get limited_time {
    return Intl.message(
      'Limited Time',
      name: 'limited_time',
      desc: '',
      args: [],
    );
  }

  /// `Recommended`
  String get recommended {
    return Intl.message('Recommended', name: 'recommended', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Shop`
  String get shop {
    return Intl.message('Shop', name: 'shop', desc: '', args: []);
  }

  /// `Fresh items & Quick delivery`
  String get fresh_items_quick_delivery {
    return Intl.message(
      'Fresh items & Quick delivery',
      name: 'fresh_items_quick_delivery',
      desc: '',
      args: [],
    );
  }

  /// `min`
  String get min {
    return Intl.message('min', name: 'min', desc: '', args: []);
  }

  /// `Minuets`
  String get minuets {
    return Intl.message('Minuets', name: 'minuets', desc: '', args: []);
  }

  /// `Open`
  String get open {
    return Intl.message('Open', name: 'open', desc: '', args: []);
  }

  /// `Closed`
  String get closed {
    return Intl.message('Closed', name: 'closed', desc: '', args: []);
  }

  /// `Menu`
  String get menu {
    return Intl.message('Menu', name: 'menu', desc: '', args: []);
  }

  /// `Info`
  String get info {
    return Intl.message('Info', name: 'info', desc: '', args: []);
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Flowers & Gifts`
  String get flowers_gifts {
    return Intl.message(
      'Flowers & Gifts',
      name: 'flowers_gifts',
      desc: '',
      args: [],
    );
  }

  /// `A tasty and freshly prepared items for you`
  String get tasty_items_for_you {
    return Intl.message(
      'A tasty and freshly prepared items for you',
      name: 'tasty_items_for_you',
      desc: '',
      args: [],
    );
  }

  /// `Shop Info`
  String get shop_info {
    return Intl.message('Shop Info', name: 'shop_info', desc: '', args: []);
  }

  /// `AM`
  String get am {
    return Intl.message('AM', name: 'am', desc: '', args: []);
  }

  /// `PM`
  String get pm {
    return Intl.message('PM', name: 'pm', desc: '', args: []);
  }

  /// `Pickup Instructions`
  String get pickup_instructions {
    return Intl.message(
      'Pickup Instructions',
      name: 'pickup_instructions',
      desc: '',
      args: [],
    );
  }

  /// `Order online and collect from the counter when ready.\nShow your order ID at pickup point`
  String get pickup_instructions_subtitle {
    return Intl.message(
      'Order online and collect from the counter when ready.\nShow your order ID at pickup point',
      name: 'pickup_instructions_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Thanks for joining Gahezha`
  String get thanks_for_joining {
    return Intl.message(
      'Thanks for joining Gahezha',
      name: 'thanks_for_joining',
      desc: '',
      args: [],
    );
  }

  /// `Order Ready`
  String get order_ready {
    return Intl.message('Order Ready', name: 'order_ready', desc: '', args: []);
  }

  /// `Your order is ready for pickup, come and get it.`
  String get order_pickup {
    return Intl.message(
      'Your order is ready for pickup, come and get it.',
      name: 'order_pickup',
      desc: '',
      args: [],
    );
  }

  /// `Your order has been accepted`
  String get order_accepted {
    return Intl.message(
      'Your order has been accepted',
      name: 'order_accepted',
      desc: '',
      args: [],
    );
  }

  /// `Your order has been rejected`
  String get order_rejected {
    return Intl.message(
      'Your order has been rejected',
      name: 'order_rejected',
      desc: '',
      args: [],
    );
  }

  /// `Your order has been delivered`
  String get order_delivered {
    return Intl.message(
      'Your order has been delivered',
      name: 'order_delivered',
      desc: '',
      args: [],
    );
  }

  /// `Choose Size`
  String get choose_size {
    return Intl.message('Choose Size', name: 'choose_size', desc: '', args: []);
  }

  /// `Small`
  String get small {
    return Intl.message('Small', name: 'small', desc: '', args: []);
  }

  /// `Medium`
  String get medium {
    return Intl.message('Medium', name: 'medium', desc: '', args: []);
  }

  /// `Large`
  String get large {
    return Intl.message('Large', name: 'large', desc: '', args: []);
  }

  /// `Add Extras`
  String get add_extras {
    return Intl.message('Add Extras', name: 'add_extras', desc: '', args: []);
  }

  /// `Extra Cheese`
  String get extra_cheese {
    return Intl.message(
      'Extra Cheese',
      name: 'extra_cheese',
      desc: '',
      args: [],
    );
  }

  /// `Gift Wrap`
  String get gift_wrap {
    return Intl.message('Gift Wrap', name: 'gift_wrap', desc: '', args: []);
  }

  /// `Spicy`
  String get spicy {
    return Intl.message('Spicy', name: 'spicy', desc: '', args: []);
  }

  /// `Regular`
  String get regular {
    return Intl.message('Regular', name: 'regular', desc: '', args: []);
  }

  /// `to Cart`
  String get to_cart {
    return Intl.message('to Cart', name: 'to_cart', desc: '', args: []);
  }

  /// `New Orders`
  String get new_orders {
    return Intl.message('New Orders', name: 'new_orders', desc: '', args: []);
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
