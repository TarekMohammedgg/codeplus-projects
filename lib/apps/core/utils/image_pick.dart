import 'package:image_picker/image_picker.dart';

/// Picks one image from the gallery. Returns null when the user cancels and
/// throws when the picker fails, so each screen shows its own error.
Future<XFile?> pickGalleryImage({
  double? maxWidth = 1024,
  double? maxHeight = 1024,
  int imageQuality = 85,
}) {
  return ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxWidth: maxWidth,
    maxHeight: maxHeight,
    imageQuality: imageQuality,
  );
}
