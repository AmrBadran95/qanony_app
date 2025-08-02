import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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

  Future<File> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = path.join(
      dir.path,
      'compressed_${path.basename(file.path)}',
    );

    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 60,
    );

    if (result != null) {
      return File(result.path);
    } else {
      return file;
    }
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

    final compressedFile = await compressImage(file);

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(compressedFile.path),
      'upload_preset': _uploadPreset,
      'folder': folder,
      'public_id': publicId,
    });

    final response = await _dio.post(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
      data: formData,
    );

    if (response.statusCode == 200) {
      final url = response.data['secure_url'];
      return '$url?f_auto,q_auto';
    } else {
      return null;
    }
  }
}
