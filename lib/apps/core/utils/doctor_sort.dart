import 'package:doctor_hunt/apps/core/models/doctor_model.dart';

/// Also the `sort` query value of the Doctors tab route.
enum DoctorSort { popular, topRated }

// Sorted in Dart (small clinic dataset), so Firestore needs no composite index.
List<DoctorModel> sortDoctors(List<DoctorModel> doctors, DoctorSort sort) {
  return switch (sort) {
    DoctorSort.popular => sortByPopularity(doctors),
    DoctorSort.topRated => sortByTopRated(doctors),
  };
}

/// `reviewsCount` desc, ties broken by `rating` desc.
List<DoctorModel> sortByPopularity(List<DoctorModel> doctors) =>
    [...doctors]..sort((a, b) {
      final byReviews = b.reviewsCount.compareTo(a.reviewsCount);
      return byReviews != 0 ? byReviews : b.rating.compareTo(a.rating);
    });

/// `rating` desc, ties broken by `reviewsCount` desc.
List<DoctorModel> sortByTopRated(List<DoctorModel> doctors) => [...doctors]
  ..sort((a, b) {
    final byRating = b.rating.compareTo(a.rating);
    return byRating != 0 ? byRating : b.reviewsCount.compareTo(a.reviewsCount);
  });
