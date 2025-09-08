import 'dart:io';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:intl/intl.dart';

class CloudinaryService {
  late final Cloudinary _cloudinary;

  CloudinaryService() {
    _cloudinary = Cloudinary.fromStringUrl(
      'cloudinary://933817115344183:YLuc7hWSzrjtcOBMWvJvt8XqImI@dl0wayiab',
    );

    _cloudinary.config.urlConfig.secure = true;
  }

  /// رفع صورة من [File] محلي
  Future<String?> uploadImage(
    File file, {
    String folder = "profiles", // ✨ الفولدر الافتراضي
    bool keepHistory = false,
  }) async {
    try {
      // ✅ اختار الاسم بناءً على نوع المستخدم
      String baseName;
      if (currentUserType == UserType.shop) {
        baseName = currentShopModel?.shopName ?? "shop";
      } else {
        baseName = currentUserModel?.fullName ?? "user";
      }

      // 👇 خلي الاسم آمن
      final safeName = baseName
          .replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')
          .toLowerCase();

      String publicId = safeName;
      if (keepHistory) {
        final timestamp = DateFormat(
          "yyyy_MM_dd_HHmmss",
        ).format(DateTime.now());
        publicId = "${safeName}_$timestamp";
      }

      final response = await _cloudinary.uploader().upload(
        file,
        params: UploadParams(
          resourceType: 'image',
          folder: folder, // ✨ الفولدر حسب النوع
          publicId: publicId,
          uniqueFilename: false,
          overwrite: !keepHistory,
        ),
      );
      return response?.data?.secureUrl;
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  /// رفع صورة من URL
  Future<String?> uploadImageFromUrl(
    String imageUrl, {
    String? publicId,
  }) async {
    try {
      final response = await _cloudinary.uploader().upload(
        imageUrl,
        params: UploadParams(
          resourceType: 'image',
          publicId: publicId,
          uniqueFilename: true,
          overwrite: false,
        ),
      );
      return response?.data?.secureUrl;
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }
}
