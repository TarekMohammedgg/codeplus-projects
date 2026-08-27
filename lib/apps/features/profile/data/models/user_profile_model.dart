class UserProfileModel {
  const UserProfileModel({
    this.name = '',
    this.contactNumber = '',
    this.dateOfBirth = '',
    this.location = '',
    this.avatarUrl,
  });

  final String name;
  final String contactNumber;
  final String dateOfBirth;
  final String location;
  final String? avatarUrl;
}
