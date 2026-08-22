class FindDoctorItem {
  final String id;
  final String name;
  final String specialty;
  final int experienceYears;
  final int ratingPercent;
  final int patientStoriesCount;
  final String nextAvailableTime;
  final String? image;
  final bool isFavorite;

  const FindDoctorItem({
    required this.id,
    required this.name,
    required this.specialty,
    required this.experienceYears,
    required this.ratingPercent,
    required this.patientStoriesCount,
    required this.nextAvailableTime,
    this.image,
    this.isFavorite = false,
  });

  FindDoctorItem copyWith({
    String? id,
    String? name,
    String? specialty,
    int? experienceYears,
    int? ratingPercent,
    int? patientStoriesCount,
    String? nextAvailableTime,
    String? image,
    bool? isFavorite,
  }) {
    return FindDoctorItem(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      experienceYears: experienceYears ?? this.experienceYears,
      ratingPercent: ratingPercent ?? this.ratingPercent,
      patientStoriesCount: patientStoriesCount ?? this.patientStoriesCount,
      nextAvailableTime: nextAvailableTime ?? this.nextAvailableTime,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
