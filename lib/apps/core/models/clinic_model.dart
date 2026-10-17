import 'package:latlong2/latlong.dart';

import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class ClinicModel {
  const ClinicModel({
    required this.addressAr,
    required this.addressEn,
    this.location,
  });

  final String addressAr;
  final String addressEn;
  final LatLng? location;

  String get localizedAddress =>
      LocaleSettings.currentLocale == AppLocale.ar ? addressAr : addressEn;
}
