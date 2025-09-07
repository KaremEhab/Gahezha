import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/generated/l10n.dart';
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
        title: Text(
          S.current.privacy_policy,
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
              title: S.current.privacy_section1_title,
              description: S.current.privacy_section1_desc,
              theme: theme,
            ),
            _buildSection(
              icon: IconlyLight.info_circle,
              title: S.current.privacy_section2_title,
              description: S.current.privacy_section2_desc,
              theme: theme,
            ),
            _buildSection(
              icon: IconlyLight.shield_done,
              title: S.current.privacy_section3_title,
              description: S.current.privacy_section3_desc,
              theme: theme,
            ),
            _buildSection(
              icon: IconlyLight.lock,
              title: S.current.privacy_section4_title,
              description: S.current.privacy_section4_desc,
              theme: theme,
            ),
            _buildSection(
              icon: IconlyLight.user,
              title: S.current.privacy_section5_title,
              description: S.current.privacy_section5_desc,
              theme: theme,
            ),
            _buildSection(
              icon: IconlyLight.time_circle,
              title: S.current.privacy_section6_title,
              description: S.current.privacy_section6_desc,
              theme: theme,
            ),
            _buildSection(
              icon: IconlyLight.message,
              title: S.current.privacy_contact_title,
              description: S.current.privacy_contact_desc,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        S.current.privacy_intro,
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
