import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class CloudinaryService {
  final ImagePicker _picker = ImagePicker();
  final Dio _dio = Dio();

  final String _cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
  final String _uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET']!;

  Future<File?> pickImage({required bool fromCamera}) async {
    final picked = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null) return null;
    return File(picked.path);
  }

  Future<String?> uploadImage({
    required File file,
    required String type,
    required String userId,
  }) async {
    final folder = type == 'profile'
        ? 'lawyers/profile_photos'
        : 'lawyers/id_cards';

    final publicId = type == 'profile' ? 'profile_$userId' : 'card_$userId';

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'upload_preset': _uploadPreset,
      'folder': folder,
      'public_id': publicId,
    });

    final response = await _dio.post(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
      data: formData,
    );

    if (response.statusCode == 200) {
      return response.data['secure_url'];
    } else {
      return null;
    }
  }
}
