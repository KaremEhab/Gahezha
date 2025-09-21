import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/order_model.dart';

class PhoneCallButton extends StatelessWidget {
  final String number;

  const PhoneCallButton({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(IconlyBold.call, color: primaryBlue, size: 20),
      onPressed: () async {
        // Copy to clipboard
        await Clipboard.setData(ClipboardData(text: number));

        // Show snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.current.copied_to_clipboard}: $number'),
            duration: const Duration(seconds: 1),
          ),
        );

        // TODO: launch phone dialer if needed
        // launchUrl(Uri.parse('tel:$phone'));
      },
    );
  }
}
