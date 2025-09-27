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

  /// `Create Shop`
  String get create_shop {
    return Intl.message('Create Shop', name: 'create_shop', desc: '', args: []);
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

  /// `Order Details`
  String get order_details {
    return Intl.message(
      'Order Details',
      name: 'order_details',
      desc: '',
      args: [],
    );
  }

  /// `Your order`
  String get your_order {
    return Intl.message('Your order', name: 'your_order', desc: '', args: []);
  }

  /// `PENDING`
  String get pending {
    return Intl.message('PENDING', name: 'pending', desc: '', args: []);
  }

  /// `Pending`
  String get pending_lower {
    return Intl.message('Pending', name: 'pending_lower', desc: '', args: []);
  }

  /// `ACCEPTED`
  String get accepted {
    return Intl.message('ACCEPTED', name: 'accepted', desc: '', args: []);
  }

  /// `REJECTED`
  String get rejected {
    return Intl.message('REJECTED', name: 'rejected', desc: '', args: []);
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Reject`
  String get reject {
    return Intl.message('Reject', name: 'reject', desc: '', args: []);
  }

  /// `PREPARING`
  String get preparing {
    return Intl.message('PREPARING', name: 'preparing', desc: '', args: []);
  }

  /// `PICKUP`
  String get pickup {
    return Intl.message('PICKUP', name: 'pickup', desc: '', args: []);
  }

  /// `DELIVERED`
  String get delivered {
    return Intl.message('DELIVERED', name: 'delivered', desc: '', args: []);
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

  /// `Take a picture`
  String get take_a_picture {
    return Intl.message(
      'Take a picture',
      name: 'take_a_picture',
      desc: '',
      args: [],
    );
  }

  /// `Choose from gallery`
  String get choose_from_gallery {
    return Intl.message(
      'Choose from gallery',
      name: 'choose_from_gallery',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get guest {
    return Intl.message('Guest', name: 'guest', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Guest Account`
  String get guest_account {
    return Intl.message(
      'Guest Account',
      name: 'guest_account',
      desc: '',
      args: [],
    );
  }

  /// `You need an account to view orders`
  String get you_need_account_to_view_orders {
    return Intl.message(
      'You need an account to view orders',
      name: 'you_need_account_to_view_orders',
      desc: '',
      args: [],
    );
  }

  /// `You need an account to add items to cart`
  String get you_need_account_to_add_items_cart {
    return Intl.message(
      'You need an account to add items to cart',
      name: 'you_need_account_to_add_items_cart',
      desc: '',
      args: [],
    );
  }

  /// `You need an account to see your cart items`
  String get you_need_account_to_see_cart_items {
    return Intl.message(
      'You need an account to see your cart items',
      name: 'you_need_account_to_see_cart_items',
      desc: '',
      args: [],
    );
  }

  /// `Create account to place your first order`
  String get create_account_to_place_first_order {
    return Intl.message(
      'Create account to place your first order',
      name: 'create_account_to_place_first_order',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get first_name {
    return Intl.message('First Name', name: 'first_name', desc: '', args: []);
  }

  /// `Last Name`
  String get last_name {
    return Intl.message('Last Name', name: 'last_name', desc: '', args: []);
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Phone Number`
  String get phone_number {
    return Intl.message(
      'Phone Number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter your password`
  String get reEnter_password {
    return Intl.message(
      'Re-enter your password',
      name: 'reEnter_password',
      desc: '',
      args: [],
    );
  }

  /// `Shop Name`
  String get shop_name {
    return Intl.message('Shop Name', name: 'shop_name', desc: '', args: []);
  }

  /// `Shop Category`
  String get shop_category {
    return Intl.message(
      'Shop Category',
      name: 'shop_category',
      desc: '',
      args: [],
    );
  }

  /// `Shop Location`
  String get shop_location {
    return Intl.message(
      'Shop Location',
      name: 'shop_location',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Preparing Time`
  String get preparing_time {
    return Intl.message(
      'Preparing Time',
      name: 'preparing_time',
      desc: '',
      args: [],
    );
  }

  /// `Opening Hours`
  String get opening_hours {
    return Intl.message(
      'Opening Hours',
      name: 'opening_hours',
      desc: '',
      args: [],
    );
  }

  /// `Enter your shop name`
  String get enter_shop_name {
    return Intl.message(
      'Enter your shop name',
      name: 'enter_shop_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter your shop category`
  String get enter_shop_category {
    return Intl.message(
      'Enter your shop category',
      name: 'enter_shop_category',
      desc: '',
      args: [],
    );
  }

  /// `Enter your shop location`
  String get enter_shop_location {
    return Intl.message(
      'Enter your shop location',
      name: 'enter_shop_location',
      desc: '',
      args: [],
    );
  }

  /// `See your active orders`
  String get see_your_active_orders {
    return Intl.message(
      'See your active orders',
      name: 'see_your_active_orders',
      desc: '',
      args: [],
    );
  }

  /// `Create an account first`
  String get create_account_first {
    return Intl.message(
      'Create an account first',
      name: 'create_account_first',
      desc: '',
      args: [],
    );
  }

  /// `SAR`
  String get sar {
    return Intl.message('SAR', name: 'sar', desc: '', args: []);
  }

  /// `Shops`
  String get shops {
    return Intl.message('Shops', name: 'shops', desc: '', args: []);
  }

  /// `All Shops`
  String get all_shops {
    return Intl.message('All Shops', name: 'all_shops', desc: '', args: []);
  }

  /// `Pending Shops`
  String get pending_shops {
    return Intl.message(
      'Pending Shops',
      name: 'pending_shops',
      desc: '',
      args: [],
    );
  }

  /// `Accepted Shops`
  String get accepted_shops {
    return Intl.message(
      'Accepted Shops',
      name: 'accepted_shops',
      desc: '',
      args: [],
    );
  }

  /// `Rejected Shops`
  String get rejected_shops {
    return Intl.message(
      'Rejected Shops',
      name: 'rejected_shops',
      desc: '',
      args: [],
    );
  }

  /// `Recent Orders`
  String get recent_orders {
    return Intl.message(
      'Recent Orders',
      name: 'recent_orders',
      desc: '',
      args: [],
    );
  }

  /// `Recent Reports`
  String get recent_reports {
    return Intl.message(
      'Recent Reports',
      name: 'recent_reports',
      desc: '',
      args: [],
    );
  }

  /// `See all`
  String get see_all {
    return Intl.message('See all', name: 'see_all', desc: '', args: []);
  }

  /// `All Reports`
  String get all_reports {
    return Intl.message('All Reports', name: 'all_reports', desc: '', args: []);
  }

  /// `Reports`
  String get reports {
    return Intl.message('Reports', name: 'reports', desc: '', args: []);
  }

  /// `Resolved`
  String get resolved {
    return Intl.message('Resolved', name: 'resolved', desc: '', args: []);
  }

  /// `Dismissed`
  String get dismissed {
    return Intl.message('Dismissed', name: 'dismissed', desc: '', args: []);
  }

  /// `Fraudulent Activity`
  String get fraudulent_activity {
    return Intl.message(
      'Fraudulent Activity',
      name: 'fraudulent_activity',
      desc: '',
      args: [],
    );
  }

  /// `Report Status`
  String get report_status {
    return Intl.message(
      'Report Status',
      name: 'report_status',
      desc: '',
      args: [],
    );
  }

  /// `Respond To Reporter`
  String get respond_to_reporter {
    return Intl.message(
      'Respond To Reporter',
      name: 'respond_to_reporter',
      desc: '',
      args: [],
    );
  }

  /// `Type your response here...`
  String get type_response_here {
    return Intl.message(
      'Type your response here...',
      name: 'type_response_here',
      desc: '',
      args: [],
    );
  }

  /// `Send Response & Update`
  String get send_response_and_update {
    return Intl.message(
      'Send Response & Update',
      name: 'send_response_and_update',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Deleted`
  String get deleted {
    return Intl.message('Deleted', name: 'deleted', desc: '', args: []);
  }

  /// `Block`
  String get block {
    return Intl.message('Block', name: 'block', desc: '', args: []);
  }

  /// `Unblock`
  String get unblock {
    return Intl.message('Unblock', name: 'unblock', desc: '', args: []);
  }

  /// `Report`
  String get report {
    return Intl.message('Report', name: 'report', desc: '', args: []);
  }

  /// `Disable`
  String get disable {
    return Intl.message('Disable', name: 'disable', desc: '', args: []);
  }

  /// `Enable`
  String get enable {
    return Intl.message('Enable', name: 'enable', desc: '', args: []);
  }

  /// `Gahezha`
  String get gahezha {
    return Intl.message('Gahezha', name: 'gahezha', desc: '', args: []);
  }

  /// `Gahezha Accounts`
  String get gahezha_accounts {
    return Intl.message(
      'Gahezha Accounts',
      name: 'gahezha_accounts',
      desc: '',
      args: [],
    );
  }

  /// `Customers`
  String get customers {
    return Intl.message('Customers', name: 'customers', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Blocked`
  String get blocked {
    return Intl.message('Blocked', name: 'blocked', desc: '', args: []);
  }

  /// `Reported`
  String get reported {
    return Intl.message('Reported', name: 'reported', desc: '', args: []);
  }

  /// `Disabled`
  String get disabled {
    return Intl.message('Disabled', name: 'disabled', desc: '', args: []);
  }

  /// `Enabled`
  String get enabled {
    return Intl.message('Enabled', name: 'enabled', desc: '', args: []);
  }

  /// `This account has been blocked and reported`
  String get this_account_has_been_blocked_and_reported {
    return Intl.message(
      'This account has been blocked and reported',
      name: 'this_account_has_been_blocked_and_reported',
      desc: '',
      args: [],
    );
  }

  /// `This account has been reported`
  String get this_account_has_been_reported {
    return Intl.message(
      'This account has been reported',
      name: 'this_account_has_been_reported',
      desc: '',
      args: [],
    );
  }

  /// `This account has been disabled`
  String get this_account_has_been_disabled {
    return Intl.message(
      'This account has been disabled',
      name: 'this_account_has_been_disabled',
      desc: '',
      args: [],
    );
  }

  /// `This account has been blocked`
  String get this_account_has_been_blocked {
    return Intl.message(
      'This account has been blocked',
      name: 'this_account_has_been_blocked',
      desc: '',
      args: [],
    );
  }

  /// `time`
  String get time {
    return Intl.message('time', name: 'time', desc: '', args: []);
  }

  /// `times`
  String get times {
    return Intl.message('times', name: 'times', desc: '', args: []);
  }

  /// `Shop Menu`
  String get shop_menu {
    return Intl.message('Shop Menu', name: 'shop_menu', desc: '', args: []);
  }

  /// `Shop Products`
  String get shop_products {
    return Intl.message(
      'Shop Products',
      name: 'shop_products',
      desc: '',
      args: [],
    );
  }

  /// `No products yet.`
  String get no_products_yet {
    return Intl.message(
      'No products yet.',
      name: 'no_products_yet',
      desc: '',
      args: [],
    );
  }

  /// `No orders yet.`
  String get no_orders_yet {
    return Intl.message(
      'No orders yet.',
      name: 'no_orders_yet',
      desc: '',
      args: [],
    );
  }

  /// `Extra Pickles`
  String get extra_pickles {
    return Intl.message(
      'Extra Pickles',
      name: 'extra_pickles',
      desc: '',
      args: [],
    );
  }

  /// `No Vegetables`
  String get no_vegetables {
    return Intl.message(
      'No Vegetables',
      name: 'no_vegetables',
      desc: '',
      args: [],
    );
  }

  /// `Extra Mushrooms`
  String get extra_mushrooms {
    return Intl.message(
      'Extra Mushrooms',
      name: 'extra_mushrooms',
      desc: '',
      args: [],
    );
  }

  /// `Extra Pepperoni`
  String get extra_pepperoni {
    return Intl.message(
      'Extra Pepperoni',
      name: 'extra_pepperoni',
      desc: '',
      args: [],
    );
  }

  /// `Extra Milk`
  String get extra_milk {
    return Intl.message('Extra Milk', name: 'extra_milk', desc: '', args: []);
  }

  /// `Whipped Cream`
  String get whipped_cream {
    return Intl.message(
      'Whipped Cream',
      name: 'whipped_cream',
      desc: '',
      args: [],
    );
  }

  /// `Hot`
  String get hot {
    return Intl.message('Hot', name: 'hot', desc: '', args: []);
  }

  /// `Iced`
  String get iced {
    return Intl.message('Iced', name: 'iced', desc: '', args: []);
  }

  /// `Decaf`
  String get decaf {
    return Intl.message('Decaf', name: 'decaf', desc: '', args: []);
  }

  /// `Add Product`
  String get add_product {
    return Intl.message('Add Product', name: 'add_product', desc: '', args: []);
  }

  /// `Edit Product`
  String get edit_product {
    return Intl.message(
      'Edit Product',
      name: 'edit_product',
      desc: '',
      args: [],
    );
  }

  /// `Images`
  String get images {
    return Intl.message('Images', name: 'images', desc: '', args: []);
  }

  /// `Add your product's images`
  String get add_your_product_images {
    return Intl.message(
      'Add your product\'s images',
      name: 'add_your_product_images',
      desc: '',
      args: [],
    );
  }

  /// `Product Name`
  String get product_name {
    return Intl.message(
      'Product Name',
      name: 'product_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter product's name`
  String get enter_product_name {
    return Intl.message(
      'Enter product\'s name',
      name: 'enter_product_name',
      desc: '',
      args: [],
    );
  }

  /// `Product Description`
  String get product_description {
    return Intl.message(
      'Product Description',
      name: 'product_description',
      desc: '',
      args: [],
    );
  }

  /// `Enter product's description`
  String get enter_product_description {
    return Intl.message(
      'Enter product\'s description',
      name: 'enter_product_description',
      desc: '',
      args: [],
    );
  }

  /// `Product Price`
  String get product_price {
    return Intl.message(
      'Product Price',
      name: 'product_price',
      desc: '',
      args: [],
    );
  }

  /// `Enter product's price`
  String get enter_product_price {
    return Intl.message(
      'Enter product\'s price',
      name: 'enter_product_price',
      desc: '',
      args: [],
    );
  }

  /// `Product Quantity`
  String get product_quantity {
    return Intl.message(
      'Product Quantity',
      name: 'product_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Enter product's quantity`
  String get enter_product_quantity {
    return Intl.message(
      'Enter product\'s quantity',
      name: 'enter_product_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Specifications`
  String get specifications {
    return Intl.message(
      'Specifications',
      name: 'specifications',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Enter specification name`
  String get enter_specification_name {
    return Intl.message(
      'Enter specification name',
      name: 'enter_specification_name',
      desc: '',
      args: [],
    );
  }

  /// `Edit Option`
  String get edit_option {
    return Intl.message('Edit Option', name: 'edit_option', desc: '', args: []);
  }

  /// `Enter option name`
  String get enter_option_name {
    return Intl.message(
      'Enter option name',
      name: 'enter_option_name',
      desc: '',
      args: [],
    );
  }

  /// `Extra Price`
  String get extra_price {
    return Intl.message('Extra Price', name: 'extra_price', desc: '', args: []);
  }

  /// `Enter extra Price (0 for none)`
  String get enter_extra_price {
    return Intl.message(
      'Enter extra Price (0 for none)',
      name: 'enter_extra_price',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Add Option`
  String get add_option {
    return Intl.message('Add Option', name: 'add_option', desc: '', args: []);
  }

  /// `Add Specification`
  String get add_specification {
    return Intl.message(
      'Add Specification',
      name: 'add_specification',
      desc: '',
      args: [],
    );
  }

  /// `Add-ons`
  String get add_ons {
    return Intl.message('Add-ons', name: 'add_ons', desc: '', args: []);
  }

  /// `Edit Add-On`
  String get edit_add_on {
    return Intl.message('Edit Add-On', name: 'edit_add_on', desc: '', args: []);
  }

  /// `Add Add-ons`
  String get add_add_ons {
    return Intl.message('Add Add-ons', name: 'add_add_ons', desc: '', args: []);
  }

  /// `Edit Shop`
  String get edit_shop {
    return Intl.message('Edit Shop', name: 'edit_shop', desc: '', args: []);
  }

  /// `Delete My Shop`
  String get delete_shop {
    return Intl.message(
      'Delete My Shop',
      name: 'delete_shop',
      desc: '',
      args: [],
    );
  }

  /// `Click back again to exit.`
  String get click_again_to_exit {
    return Intl.message(
      'Click back again to exit.',
      name: 'click_again_to_exit',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for approval...`
  String get waiting_for_approval {
    return Intl.message(
      'Waiting for approval...',
      name: 'waiting_for_approval',
      desc: '',
      args: [],
    );
  }

  /// `You have`
  String get you_have {
    return Intl.message('You have', name: 'you_have', desc: '', args: []);
  }

  /// `orders to pickup`
  String get orders_to_pickup {
    return Intl.message(
      'orders to pickup',
      name: 'orders_to_pickup',
      desc: '',
      args: [],
    );
  }

  /// `Ready to Pickup`
  String get ready_to_pickup {
    return Intl.message(
      'Ready to Pickup',
      name: 'ready_to_pickup',
      desc: '',
      args: [],
    );
  }

  /// `Fast Food`
  String get fast_food {
    return Intl.message('Fast Food', name: 'fast_food', desc: '', args: []);
  }

  /// `Bakery`
  String get bakery {
    return Intl.message('Bakery', name: 'bakery', desc: '', args: []);
  }

  /// `Cafe`
  String get cafe {
    return Intl.message('Cafe', name: 'cafe', desc: '', args: []);
  }

  /// `Supermarket`
  String get supermarket {
    return Intl.message('Supermarket', name: 'supermarket', desc: '', args: []);
  }

  /// `Grocery`
  String get grocery {
    return Intl.message('Grocery', name: 'grocery', desc: '', args: []);
  }

  /// `Dessert`
  String get dessert {
    return Intl.message('Dessert', name: 'dessert', desc: '', args: []);
  }

  /// `Juice Bar`
  String get juice_bar {
    return Intl.message('Juice Bar', name: 'juice_bar', desc: '', args: []);
  }

  /// `Pizza`
  String get pizza {
    return Intl.message('Pizza', name: 'pizza', desc: '', args: []);
  }

  /// `Sushi`
  String get sushi {
    return Intl.message('Sushi', name: 'sushi', desc: '', args: []);
  }

  /// `Seafood`
  String get seafood {
    return Intl.message('Seafood', name: 'seafood', desc: '', args: []);
  }

  /// `Clothing`
  String get clothing {
    return Intl.message('Clothing', name: 'clothing', desc: '', args: []);
  }

  /// `Electronics`
  String get electronics {
    return Intl.message('Electronics', name: 'electronics', desc: '', args: []);
  }

  /// `Mobile Phones`
  String get mobile_phones {
    return Intl.message(
      'Mobile Phones',
      name: 'mobile_phones',
      desc: '',
      args: [],
    );
  }

  /// `Home Appliances`
  String get home_appliances {
    return Intl.message(
      'Home Appliances',
      name: 'home_appliances',
      desc: '',
      args: [],
    );
  }

  /// `Books`
  String get books {
    return Intl.message('Books', name: 'books', desc: '', args: []);
  }

  /// `Stationery`
  String get stationery {
    return Intl.message('Stationery', name: 'stationery', desc: '', args: []);
  }

  /// `Toys`
  String get toys {
    return Intl.message('Toys', name: 'toys', desc: '', args: []);
  }

  /// `Beauty & Cosmetics`
  String get beauty_cosmetics {
    return Intl.message(
      'Beauty & Cosmetics',
      name: 'beauty_cosmetics',
      desc: '',
      args: [],
    );
  }

  /// `Jewelry`
  String get jewelry {
    return Intl.message('Jewelry', name: 'jewelry', desc: '', args: []);
  }

  /// `Sports`
  String get sports {
    return Intl.message('Sports', name: 'sports', desc: '', args: []);
  }

  /// `Fitness`
  String get fitness {
    return Intl.message('Fitness', name: 'fitness', desc: '', args: []);
  }

  /// `Pharmacy`
  String get pharmacy {
    return Intl.message('Pharmacy', name: 'pharmacy', desc: '', args: []);
  }

  /// `Flowers`
  String get flowers {
    return Intl.message('Flowers', name: 'flowers', desc: '', args: []);
  }

  /// `Gifts`
  String get gifts {
    return Intl.message('Gifts', name: 'gifts', desc: '', args: []);
  }

  /// `Furniture`
  String get furniture {
    return Intl.message('Furniture', name: 'furniture', desc: '', args: []);
  }

  /// `Pet Shop`
  String get pet_shop {
    return Intl.message('Pet Shop', name: 'pet_shop', desc: '', args: []);
  }

  /// `Music & Instruments`
  String get music_instruments {
    return Intl.message(
      'Music & Instruments',
      name: 'music_instruments',
      desc: '',
      args: [],
    );
  }

  /// `Car Accessories`
  String get car_accessories {
    return Intl.message(
      'Car Accessories',
      name: 'car_accessories',
      desc: '',
      args: [],
    );
  }

  /// `Shoes`
  String get shoes {
    return Intl.message('Shoes', name: 'shoes', desc: '', args: []);
  }

  /// `Handmade Crafts`
  String get handmade_crafts {
    return Intl.message(
      'Handmade Crafts',
      name: 'handmade_crafts',
      desc: '',
      args: [],
    );
  }

  /// `Ice Cream`
  String get ice_cream {
    return Intl.message('Ice Cream', name: 'ice_cream', desc: '', args: []);
  }

  /// `Fast Casual`
  String get fast_casual {
    return Intl.message('Fast Casual', name: 'fast_casual', desc: '', args: []);
  }

  /// `Organic Food`
  String get organic_food {
    return Intl.message(
      'Organic Food',
      name: 'organic_food',
      desc: '',
      args: [],
    );
  }

  /// `Vegan`
  String get vegan {
    return Intl.message('Vegan', name: 'vegan', desc: '', args: []);
  }

  /// `Tea House`
  String get tea_house {
    return Intl.message('Tea House', name: 'tea_house', desc: '', args: []);
  }

  /// `Dessert Cafe`
  String get dessert_cafe {
    return Intl.message(
      'Dessert Cafe',
      name: 'dessert_cafe',
      desc: '',
      args: [],
    );
  }

  /// `Bakery & Coffee`
  String get bakery_coffee {
    return Intl.message(
      'Bakery & Coffee',
      name: 'bakery_coffee',
      desc: '',
      args: [],
    );
  }

  /// `Street Food`
  String get street_food {
    return Intl.message('Street Food', name: 'street_food', desc: '', args: []);
  }

  /// `Bar`
  String get bar {
    return Intl.message('Bar', name: 'bar', desc: '', args: []);
  }

  /// `Night Club`
  String get night_club {
    return Intl.message('Night Club', name: 'night_club', desc: '', args: []);
  }

  /// `Internet Cafe`
  String get internet_cafe {
    return Intl.message(
      'Internet Cafe',
      name: 'internet_cafe',
      desc: '',
      args: [],
    );
  }

  /// `Photography Studio`
  String get photography_studio {
    return Intl.message(
      'Photography Studio',
      name: 'photography_studio',
      desc: '',
      args: [],
    );
  }

  /// `Bookstore & Cafe`
  String get bookstore_cafe {
    return Intl.message(
      'Bookstore & Cafe',
      name: 'bookstore_cafe',
      desc: '',
      args: [],
    );
  }

  /// `Copied to clipboard`
  String get copied_to_clipboard {
    return Intl.message(
      'Copied to clipboard',
      name: 'copied_to_clipboard',
      desc: '',
      args: [],
    );
  }

  /// `Shop not fulfilling orders`
  String get admin_shop_not_fulfilling_orders {
    return Intl.message(
      'Shop not fulfilling orders',
      name: 'admin_shop_not_fulfilling_orders',
      desc: '',
      args: [],
    );
  }

  /// `Shop rejecting/cancelling orders too often`
  String get admin_shop_rejecting_orders_too_often {
    return Intl.message(
      'Shop rejecting/cancelling orders too often',
      name: 'admin_shop_rejecting_orders_too_often',
      desc: '',
      args: [],
    );
  }

  /// `Wrong items sent / missing items`
  String get admin_wrong_items_sent {
    return Intl.message(
      'Wrong items sent / missing items',
      name: 'admin_wrong_items_sent',
      desc: '',
      args: [],
    );
  }

  /// `Shop not responsive to customers`
  String get admin_shop_not_responsive {
    return Intl.message(
      'Shop not responsive to customers',
      name: 'admin_shop_not_responsive',
      desc: '',
      args: [],
    );
  }

  /// `Customers reporting bad behavior`
  String get admin_customers_reporting_bad_behavior {
    return Intl.message(
      'Customers reporting bad behavior',
      name: 'admin_customers_reporting_bad_behavior',
      desc: '',
      args: [],
    );
  }

  /// `Fake or invalid orders`
  String get admin_fake_or_invalid_orders {
    return Intl.message(
      'Fake or invalid orders',
      name: 'admin_fake_or_invalid_orders',
      desc: '',
      args: [],
    );
  }

  /// `Customer disputes on items or pickup`
  String get admin_customer_disputes {
    return Intl.message(
      'Customer disputes on items or pickup',
      name: 'admin_customer_disputes',
      desc: '',
      args: [],
    );
  }

  /// `Order not picked up`
  String get admin_order_not_picked_up {
    return Intl.message(
      'Order not picked up',
      name: 'admin_order_not_picked_up',
      desc: '',
      args: [],
    );
  }

  /// `Order missing items`
  String get admin_order_missing_items {
    return Intl.message(
      'Order missing items',
      name: 'admin_order_missing_items',
      desc: '',
      args: [],
    );
  }

  /// `Miscommunication between shop and customer`
  String get admin_miscommunication {
    return Intl.message(
      'Miscommunication between shop and customer',
      name: 'admin_miscommunication',
      desc: '',
      args: [],
    );
  }

  /// `Order delayed beyond expected prep time`
  String get admin_order_delayed {
    return Intl.message(
      'Order delayed beyond expected prep time',
      name: 'admin_order_delayed',
      desc: '',
      args: [],
    );
  }

  /// `Technical issues (app crashes, wrong data)`
  String get admin_technical_issues {
    return Intl.message(
      'Technical issues (app crashes, wrong data)',
      name: 'admin_technical_issues',
      desc: '',
      args: [],
    );
  }

  /// `Customer didn’t pick up order`
  String get shop_customer_not_picked_up {
    return Intl.message(
      'Customer didn’t pick up order',
      name: 'shop_customer_not_picked_up',
      desc: '',
      args: [],
    );
  }

  /// `Customer provided wrong info (phone number, name)`
  String get shop_customer_wrong_info {
    return Intl.message(
      'Customer provided wrong info (phone number, name)',
      name: 'shop_customer_wrong_info',
      desc: '',
      args: [],
    );
  }

  /// `Customer complained about items unnecessarily`
  String get shop_customer_complained_unnecessarily {
    return Intl.message(
      'Customer complained about items unnecessarily',
      name: 'shop_customer_complained_unnecessarily',
      desc: '',
      args: [],
    );
  }

  /// `Order contains unclear instructions`
  String get shop_order_unclear_instructions {
    return Intl.message(
      'Order contains unclear instructions',
      name: 'shop_order_unclear_instructions',
      desc: '',
      args: [],
    );
  }

  /// `Unable to prepare order on time`
  String get shop_unable_to_prepare_order {
    return Intl.message(
      'Unable to prepare order on time',
      name: 'shop_unable_to_prepare_order',
      desc: '',
      args: [],
    );
  }

  /// `Extra items or missing items reported`
  String get shop_extra_or_missing_items {
    return Intl.message(
      'Extra items or missing items reported',
      name: 'shop_extra_or_missing_items',
      desc: '',
      args: [],
    );
  }

  /// `Order notifications not received`
  String get shop_order_notifications_not_received {
    return Intl.message(
      'Order notifications not received',
      name: 'shop_order_notifications_not_received',
      desc: '',
      args: [],
    );
  }

  /// `App crashes during order handling`
  String get shop_app_crashes {
    return Intl.message(
      'App crashes during order handling',
      name: 'shop_app_crashes',
      desc: '',
      args: [],
    );
  }

  /// `Wrong items received`
  String get customer_wrong_items_received {
    return Intl.message(
      'Wrong items received',
      name: 'customer_wrong_items_received',
      desc: '',
      args: [],
    );
  }

  /// `Items missing`
  String get customer_items_missing {
    return Intl.message(
      'Items missing',
      name: 'customer_items_missing',
      desc: '',
      args: [],
    );
  }

  /// `Order prepared late / not ready on time`
  String get customer_order_late {
    return Intl.message(
      'Order prepared late / not ready on time',
      name: 'customer_order_late',
      desc: '',
      args: [],
    );
  }

  /// `Poor quality of items`
  String get customer_poor_quality {
    return Intl.message(
      'Poor quality of items',
      name: 'customer_poor_quality',
      desc: '',
      args: [],
    );
  }

  /// `Rude shop staff`
  String get customer_rude_staff {
    return Intl.message(
      'Rude shop staff',
      name: 'customer_rude_staff',
      desc: '',
      args: [],
    );
  }

  /// `Wrong shop information`
  String get customer_wrong_shop_info {
    return Intl.message(
      'Wrong shop information',
      name: 'customer_wrong_shop_info',
      desc: '',
      args: [],
    );
  }

  /// `Unresponsive shop`
  String get customer_shop_unresponsive {
    return Intl.message(
      'Unresponsive shop',
      name: 'customer_shop_unresponsive',
      desc: '',
      args: [],
    );
  }

  /// `App crashes`
  String get customer_app_crashes {
    return Intl.message(
      'App crashes',
      name: 'customer_app_crashes',
      desc: '',
      args: [],
    );
  }

  /// `Notifications not working`
  String get customer_notifications_not_working {
    return Intl.message(
      'Notifications not working',
      name: 'customer_notifications_not_working',
      desc: '',
      args: [],
    );
  }

  /// `Order tracking issues`
  String get customer_order_tracking_issues {
    return Intl.message(
      'Order tracking issues',
      name: 'customer_order_tracking_issues',
      desc: '',
      args: [],
    );
  }

  /// `Create Report`
  String get create_report {
    return Intl.message(
      'Create Report',
      name: 'create_report',
      desc: '',
      args: [],
    );
  }

  /// `Edit Report`
  String get edit_report {
    return Intl.message('Edit Report', name: 'edit_report', desc: '', args: []);
  }

  /// `Delete Report`
  String get delete_report {
    return Intl.message(
      'Delete Report',
      name: 'delete_report',
      desc: '',
      args: [],
    );
  }

  /// `Report Type`
  String get report_type {
    return Intl.message('Report Type', name: 'report_type', desc: '', args: []);
  }

  /// `Assign to`
  String get assign_to {
    return Intl.message('Assign to', name: 'assign_to', desc: '', args: []);
  }

  /// `Report description`
  String get report_description {
    return Intl.message(
      'Report description',
      name: 'report_description',
      desc: '',
      args: [],
    );
  }

  /// `Report Customer`
  String get report_customer {
    return Intl.message(
      'Report Customer',
      name: 'report_customer',
      desc: '',
      args: [],
    );
  }

  /// `Report Shop`
  String get report_shop {
    return Intl.message('Report Shop', name: 'report_shop', desc: '', args: []);
  }

  /// `Report Gahezha`
  String get report_app {
    return Intl.message(
      'Report Gahezha',
      name: 'report_app',
      desc: '',
      args: [],
    );
  }

  /// `No reports found`
  String get no_reports_found {
    return Intl.message(
      'No reports found',
      name: 'no_reports_found',
      desc: '',
      args: [],
    );
  }

  /// `Once you add products to cart, it will appear here.`
  String get once_you_add_products_cart {
    return Intl.message(
      'Once you add products to cart, it will appear here.',
      name: 'once_you_add_products_cart',
      desc: '',
      args: [],
    );
  }

  /// `Once you place an order, it will appear here.`
  String get once_you_place_new_orders {
    return Intl.message(
      'Once you place an order, it will appear here.',
      name: 'once_you_place_new_orders',
      desc: '',
      args: [],
    );
  }

  /// `Gahezha Support Team`
  String get gahezha_support_team {
    return Intl.message(
      'Gahezha Support Team',
      name: 'gahezha_support_team',
      desc: '',
      args: [],
    );
  }

  /// `Commission`
  String get commission {
    return Intl.message('Commission', name: 'commission', desc: '', args: []);
  }

  /// `About Me`
  String get about_me {
    return Intl.message('About Me', name: 'about_me', desc: '', args: []);
  }

  /// `No active orders`
  String get no_active_orders {
    return Intl.message(
      'No active orders',
      name: 'no_active_orders',
      desc: '',
      args: [],
    );
  }

  /// `This shop has not added any products yet.`
  String get no_products_added_yet {
    return Intl.message(
      'This shop has not added any products yet.',
      name: 'no_products_added_yet',
      desc: '',
      args: [],
    );
  }

  /// `Join Gahezha and open your shop`
  String get join_gahezha_and_open_shop {
    return Intl.message(
      'Join Gahezha and open your shop',
      name: 'join_gahezha_and_open_shop',
      desc: '',
      args: [],
    );
  }

  /// `No customers`
  String get no_customers {
    return Intl.message(
      'No customers',
      name: 'no_customers',
      desc: '',
      args: [],
    );
  }

  /// `No shops`
  String get no_shops {
    return Intl.message('No shops', name: 'no_shops', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Paid`
  String get paid {
    return Intl.message('Paid', name: 'paid', desc: '', args: []);
  }

  /// `Remaining`
  String get remaining {
    return Intl.message('Remaining', name: 'remaining', desc: '', args: []);
  }

  /// `Click to pay`
  String get click_to_pay {
    return Intl.message(
      'Click to pay',
      name: 'click_to_pay',
      desc: '',
      args: [],
    );
  }

  /// `Paid commission successfully`
  String get paid_commission_successfully {
    return Intl.message(
      'Paid commission successfully',
      name: 'paid_commission_successfully',
      desc: '',
      args: [],
    );
  }

  /// `No notifications`
  String get no_notifications {
    return Intl.message(
      'No notifications',
      name: 'no_notifications',
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
