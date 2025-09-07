import 'package:flutter/material.dart';
import 'package:gahezha/generated/l10n.dart';

class PreparingOrderPage extends StatelessWidget {
  const PreparingOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              "${S.current.we_are_preparing_your_order}...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
