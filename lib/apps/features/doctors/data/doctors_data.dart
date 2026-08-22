import 'package:doctor_hunt/apps/features/doctors/data/models/doctor_detail_args.dart';
import 'package:doctor_hunt/apps/features/doctors/data/models/find_doctor_model.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

List<String> defaultServices(Translations t) => [
  t.serviceOne,
  t.serviceTwo,
  t.serviceThree,
];

DoctorDetailArgs defaultDoctorDetails(Translations t) => DoctorDetailArgs(
  id: '1',
  name: 'Dr. Pediatrician',
  specialty: t.medicineSpecialist,
  services: defaultServices(t),
);

List<FindDoctorItem> doctors(Translations t) => [
  FindDoctorItem(
    id: 'doc_1',
    name: 'Dr. Shruti Kedia',
    specialty: t.dentist,
    experienceYears: 7,
    ratingPercent: 87,
    patientStoriesCount: 69,
    nextAvailableTime: '10:00 AM ${t.tomorrow}',
    image: Assets.assetsDummyDoctorsDoctor1,
    isFavorite: true,
  ),
  FindDoctorItem(
    id: 'doc_2',
    name: 'Dr. Watamaniuk',
    specialty: t.dentist,
    experienceYears: 9,
    ratingPercent: 74,
    patientStoriesCount: 78,
    nextAvailableTime: '12:00 AM ${t.tomorrow}',
    image: Assets.assetsDummyDoctorsDoctor2,
  ),
  FindDoctorItem(
    id: 'doc_3',
    name: 'Dr. Crownover',
    specialty: t.dentist,
    experienceYears: 5,
    ratingPercent: 59,
    patientStoriesCount: 86,
    nextAvailableTime: '11:00 AM ${t.tomorrow}',
    image: Assets.assetsDummyDoctorsDoctor3,
    isFavorite: true,
  ),
  FindDoctorItem(
    id: 'doc_4',
    name: 'Dr. Balestra',
    specialty: t.dentist,
    experienceYears: 6,
    ratingPercent: 87,
    patientStoriesCount: 69,
    nextAvailableTime: '01:00 PM ${t.tomorrow}',
    image: Assets.assetsDummyDoctorsDoctor4,
  ),
  FindDoctorItem(
    id: 'doc_5',
    name: 'Dr. Fillerup Grab',
    specialty: t.medicineSpecialist,
    experienceYears: 8,
    ratingPercent: 92,
    patientStoriesCount: 104,
    nextAvailableTime: '02:30 PM ${t.tomorrow}',
    image: Assets.assetsDummyDoctorsDoctor1,
  ),
  FindDoctorItem(
    id: 'doc_6',
    name: 'Dr. Blessing',
    specialty: t.dentalSpecialist,
    experienceYears: 10,
    ratingPercent: 95,
    patientStoriesCount: 120,
    nextAvailableTime: '04:00 PM ${t.tomorrow}',
    image: Assets.assetsDummyDoctorsDoctor2,
    isFavorite: true,
  ),
];
