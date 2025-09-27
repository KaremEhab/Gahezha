import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  bool darkMode = false;
  bool emailOffers = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Preferences")),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          SwitchListTile(
            value: darkMode,
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode, color: Colors.blue),
            onChanged: (val) => setState(() => darkMode = val),
          ),
          SwitchListTile(
            value: emailOffers,
            title: const Text("Email Offers & Promotions"),
            secondary: const Icon(IconlyLight.message, color: Colors.blue),
            onChanged: (val) => setState(() => emailOffers = val),
          ),
        ],
      ),
    );
  }
}
