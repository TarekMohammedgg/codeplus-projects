class DoctorDetailArgs {
  final String id;
  final String name;
  final String specialty;
  final String? image;
  final double rating;
  final double hourlyRate;
  final bool isFavorite;
  final int runningCount;
  final int ongoingCount;
  final int patientCount;
  final List<String> services;

  const DoctorDetailArgs({
    required this.id,
    required this.name,
    required this.specialty,
    this.image,
    this.rating = 3.5,
    this.hourlyRate = 28.0,
    this.isFavorite = false,
    this.runningCount = 100,
    this.ongoingCount = 500,
    this.patientCount = 700,
    this.services = const [],
  });
}
