import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  static const String url = 'https://qmqthwkommmvcubgedfd.supabase.co';
  static const String publishableKey =
      'sb_publishable_0_KAcW0PJXay1K_Kglcf8g_KmOpbufp';
  static const String doctorImagesBucket = 'doctor-images';

  static final SupabaseStorageService instance = SupabaseStorageService();

  final SupabaseClient? _client;
  final ImagePicker _picker;

  SupabaseStorageService({SupabaseClient? client, ImagePicker? picker})
    : _client = client ?? _safeClient(),
      _picker = picker ?? ImagePicker();

  static SupabaseClient? _safeClient() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  static Future<void> initialize() async {
    await Supabase.initialize(url: url, publishableKey: publishableKey);
  }

  Future<File?> pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      imageQuality: 85,
    );
    return picked != null ? File(picked.path) : null;
  }

  Future<String> upload(File file) async {
    final client = _client ?? Supabase.instance.client;
    final extension = file.path.split('.').last.toLowerCase();
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${identityHashCode(file)}.$extension';

    final storage = client.storage.from(doctorImagesBucket);
    await storage.upload(
      fileName,
      file,
      fileOptions: const FileOptions(upsert: true),
    );

    return storage.getPublicUrl(fileName);
  }
}
