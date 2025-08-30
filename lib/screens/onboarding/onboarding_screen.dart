import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/locale/locale_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/screens/authentication/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> onboardingData = [
      {
        "image": "assets/images/all-restaraunts.svg",
        "title": S.of(context).discover_restaurants_title,
        "subtitle": S.of(context).discover_restaurants_subtitle,
      },
      {
        "image": "assets/images/make-order.svg",
        "title": S.of(context).make_your_order_title,
        "subtitle": S.of(context).make_your_order_subtitle,
      },
      {
        "image": "assets/images/order-confirm.svg",
        "title": S.of(context).order_confirmed_title,
        "subtitle": S.of(context).order_confirmed_subtitle,
      },
      {
        "image": "assets/images/pickup-order.svg",
        "title": S.of(context).pickup_your_order_title,
        "subtitle": S.of(context).pickup_your_order_subtitle,
      },
      {
        "image": "assets/images/eat-order.svg",
        "title": S.of(context).enjoy_your_meal_title,
        "subtitle": S.of(context).enjoy_your_meal_subtitle,
      },
    ];
    return Scaffold(
      body: Stack(
        children: [
          /// Page Content
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final data = onboardingData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 40,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: SvgPicture.asset(
                              data["image"]!,
                              height: index == 1 ? 340 : null,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            data["title"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            data["subtitle"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// Page Indicator
              SmoothPageIndicator(
                controller: _controller,
                count: onboardingData.length,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Theme.of(context).colorScheme.primary,
                  dotColor: Colors.grey.shade300,
                  spacing: 6,
                ),
              ),
            ],
          ),

          /// 🔹 Locale Dropdown (Top-Start)
          Positioned(
            top: 16,
            left: Directionality.of(context) == TextDirection.ltr ? 16 : null,
            right: Directionality.of(context) == TextDirection.rtl ? 16 : null,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: lang,
                    dropdownColor: Theme.of(
                      context,
                    ).primaryColor, // background color
                    borderRadius: BorderRadius.circular(12), // rounded corners
                    iconEnabledColor: Colors.white,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: "en",
                        child: Row(
                          spacing: 5,
                          children: [
                            const Text("🇺🇸"),
                            Text(S.of(context).en),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: "ar",
                        child: Row(
                          spacing: 5,
                          children: [
                            const Text("🇸🇦"),
                            Text(S.of(context).ar),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => lang = value);
                        context.read<LocaleCubit>().changeLocale(lang);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      /// Bottom Buttons
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Row(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_currentIndex != onboardingData.length - 1)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _controller.animateToPage(
                        onboardingData.length - 1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Row(
                      spacing: 5,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 1),
                        Text(
                          S.of(context).skip,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(forwardIcon()),
                      ],
                    ),
                  ),
                ),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentIndex == onboardingData.length - 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Login()),
                      );
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    _currentIndex == onboardingData.length - 1
                        ? S.of(context).get_started
                        : S.of(context).next,
                    style: const TextStyle(fontSize: 18),
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
