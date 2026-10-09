import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/models/doctor_model.dart';
import 'package:doctor_hunt/apps/core/services/doctor_service.dart';

void main() {
  test('newDoctorData writes only the locked doctor fields', () {
    // act
    final data = newDoctorData(
      fullNameAr: ' د. سارة ',
      fullNameEn: ' Dr. Sara ',
      specialtyId: 'dentistry',
      consultationFee: 30,
      imageUrl: ' https://res.cloudinary.com/x/sara ',
    );

    // assert
    expect(data.keys.toSet(), {
      'fullName',
      'specialtyId',
      'imageUrl',
      'consultationFee',
      'rating',
      'reviewsCount',
      'isActive',
      'createdAt',
      'updatedAt',
    });
    expect(data['fullName'], {'ar': 'د. سارة', 'en': 'Dr. Sara'});
    expect(data['imageUrl'], 'https://res.cloudinary.com/x/sara');
    expect(data['consultationFee'], 30);
    expect(data['rating'], 0);
    expect(data['reviewsCount'], 0);
    expect(data['isActive'], isTrue);
  });

  test('newDoctorData stores an empty image url as null', () {
    // act
    final data = newDoctorData(
      fullNameAr: 'أ',
      fullNameEn: 'A',
      specialtyId: 's',
      consultationFee: 10,
      imageUrl: '  ',
    );

    // assert
    expect(data['imageUrl'], isNull);
  });

  test('DoctorModel parses consultationFee', () {
    // act
    final doctor = DoctorModel.fromFirestore('doc_1', {
      'fullName': {'ar': 'أ', 'en': 'A'},
      'specialtyId': 'dentistry',
      'consultationFee': 45,
    });

    // assert
    expect(doctor.consultationFee, 45);
    expect(doctor.consultationFee, 45);
  });
}
