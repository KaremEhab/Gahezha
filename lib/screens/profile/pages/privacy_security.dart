import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:iconly/iconly.dart';

class PrivacyAndPolicyPage extends StatelessWidget {
  const PrivacyAndPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Privacy Policy",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            _buildIntroCard(),
            const SizedBox(height: 16),
            _buildSection(
              icon: IconlyLight.document,
              title: "1. Information We Collect",
              description:
                  "• Personal details such as your name, email address, phone number.\n"
                  "• Data related to your shop, orders, and products.\n"
                  "• Usage information including app interactions and device details.",
              theme: theme,
            ),
            _buildSection(
              icon: IconlyLight.info_circle,
              title: "2. How We Use Your Information",
              description:
                  "• To provide and improve our services.\n"
                  "• To process your orders.\n"
                  "• To communicate with you regarding updates, promotions, and support.\n"
                  "• To comply with legal obligations.",
              theme: theme,
            ),
            _buildSection(
              icon: IconlyLight.shield_done,
              title: "3. Data Sharing",
              description:
                  "We do not sell or rent your personal data. We may share your information with trusted third parties such as delivery partners, and legal authorities when required.",
              theme: theme,
            ),
            _buildSection(
              icon: IconlyLight.lock,
              title: "4. Data Security",
              description:
                  "We implement strong security measures to protect your data. However, no method of transmission or storage is 100% secure, and we cannot guarantee absolute security.",
              theme: theme,
            ),
            _buildSection(
              icon: IconlyLight.user,
              title: "5. Your Rights",
              description:
                  "You may update or delete your personal information at any time through your account settings or by contacting our support team.",
              theme: theme,
            ),
            _buildSection(
              icon: IconlyLight.time_circle,
              title: "6. Changes to This Policy",
              description:
                  "We may update this Privacy Policy from time to time. Any changes will be reflected in the app, and continued use means you agree to the updated terms.",
              theme: theme,
            ),
            _buildSection(
              icon: IconlyLight.message,
              title: "Contact Us",
              description:
                  "If you have any questions about this Privacy Policy, please contact us at support@gahezha.com",
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return const Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        "At Gahezha, your privacy is very important to us. This Privacy Policy explains how we collect, use, and protect your information when you use our app and services.",
        style: TextStyle(
          fontSize: 15,
          height: 1.5,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String description,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryBlue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
