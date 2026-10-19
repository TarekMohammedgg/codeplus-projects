/// Firestore collection names, shared by every service and `firestore.rules`.
abstract final class FirestoreCollections {
  static const users = 'users';
  static const favorites = 'favorites';
  static const doctors = 'doctors';
  static const specialty = 'specialty';
  static const clinic = 'clinic';
  static const clinicSettingsDoc = 'settings';
  static const appointments = 'appointments';
  static const bookedSlots = 'bookedSlots';
  static const reviews = 'reviews';
}
