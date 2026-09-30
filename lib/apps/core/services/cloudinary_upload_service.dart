import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryUploadService {
  CloudinaryUploadService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  String get _cloudName => dotenv.isInitialized
      ? dotenv.maybeGet('CLOUDINARY_CLOUD_NAME') ?? ''
      : '';

  String get _uploadPreset => dotenv.isInitialized
      ? dotenv.maybeGet('CLOUDINARY_UPLOAD_PRESET') ?? ''
      : '';

  bool get isConfigured => _cloudName.isNotEmpty && _uploadPreset.isNotEmpty;

  Future<String> uploadImage({
    required Uint8List bytes,
    required String fileName,
  }) async {
    if (!isConfigured) {
      throw StateError(
        'Cloudinary is not configured. Add CLOUDINARY_CLOUD_NAME and '
        'CLOUDINARY_UPLOAD_PRESET to .env.',
      );
    }

    final uri = Uri.https(
      'api.cloudinary.com',
      '/v1_1/$_cloudName/image/upload',
    );
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        uri.toString(),
        data: FormData.fromMap({
          'upload_preset': _uploadPreset,
          'file': MultipartFile.fromBytes(bytes, filename: fileName),
        }),
      );
      final secureUrl = response.data?['secure_url'] as String?;
      if (secureUrl == null || secureUrl.trim().isEmpty) {
        throw StateError('Cloudinary returned no image URL.');
      }
      return secureUrl;
    } on DioException catch (error) {
      final responseData = error.response?.data;
      final message = responseData is Map
          ? (responseData['error'] is Map
                ? responseData['error']['message'] as String?
                : responseData['message'] as String?)
          : null;
      throw StateError(message ?? 'Cloudinary image upload failed.');
    }
  }
}
