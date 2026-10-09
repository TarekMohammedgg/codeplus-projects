import 'package:image_picker/image_picker.dart';

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
