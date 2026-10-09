import 'package:doctor_hunt/apps/core/models/doctor_model.dart';

enum DoctorSort { popular, topRated }

List<DoctorModel> sortDoctors(List<DoctorModel> doctors, DoctorSort sort) {
  return switch (sort) {
    DoctorSort.popular => sortByPopularity(doctors),
    DoctorSort.topRated => sortByTopRated(doctors),
  };
}

List<DoctorModel> sortByPopularity(List<DoctorModel> doctors) =>
    [...doctors]..sort((a, b) {
      final byReviews = b.reviewsCount.compareTo(a.reviewsCount);
      return byReviews != 0 ? byReviews : b.rating.compareTo(a.rating);
    });

List<DoctorModel> sortByTopRated(List<DoctorModel> doctors) => [...doctors]
  ..sort((a, b) {
    final byRating = b.rating.compareTo(a.rating);
    return byRating != 0 ? byRating : b.reviewsCount.compareTo(a.reviewsCount);
  });
