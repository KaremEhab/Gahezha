import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/shop_model.dart';
import 'package:gahezha/screens/layout/layout.dart';
import 'package:gahezha/screens/authentication/login.dart';

class WaitingForApprovalPage extends StatefulWidget {
  const WaitingForApprovalPage({super.key});

  @override
  State<WaitingForApprovalPage> createState() => _WaitingForApprovalPageState();
}

class _WaitingForApprovalPageState extends State<WaitingForApprovalPage> {
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _shopStream;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _shopSubscription;

  @override
  void initState() {
    super.initState();
    _shopStream = FirebaseFirestore.instance
        .collection('shops')
        .doc(uId)
        .snapshots();

    _shopSubscription = _shopStream.listen((snapshot) {
      if (!mounted) return;
      if (!snapshot.exists) return;

      final data = snapshot.data();
      if (data == null) return;

      final statusIndex = data['shopAcceptanceStatus'] ?? 0;
      if (statusIndex == ShopAcceptanceStatus.accepted.index) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const Layout()));
      }
    });
  }

  @override
  void dispose() {
    _shopSubscription?.cancel(); // cancel the listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shop = currentShopModel;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 52,
                backgroundColor: Colors.grey.shade200,
                child: CircleAvatar(
                  radius: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Image.network(
                      shop?.shopLogo ?? '',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => SvgPicture.asset(
                        'assets/images/logo.svg',
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                shop?.shopName ?? 'Your Shop',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                S.current.waiting_for_approval,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                          foregroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          // Perform guest login
                        },
                        child: Text(S.current.guest),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          UserCubit.instance.logout(context);
                        },
                        child: Text(S.current.logout),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
