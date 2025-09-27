import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:iconly/iconly.dart';

class PickImageSource extends StatelessWidget {
  const PickImageSource({
    super.key,
    required this.galleryButton,
    required this.cameraButton,
  });

  final void Function() galleryButton, cameraButton;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(IconlyBold.camera, color: primaryBlue, size: 35),
            title: Text(S.current.take_a_picture),
            trailing: Icon(forwardIcon(), color: Colors.black54),
            onTap: cameraButton,
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(IconlyBold.image, color: primaryBlue, size: 35),
            title: Text(S.current.choose_from_gallery),
            trailing: Icon(forwardIcon(), color: Colors.black54),
            onTap: galleryButton,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}