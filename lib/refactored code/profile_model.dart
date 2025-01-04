class UserProfile {
  final String? firstName;
  final String? lastName;
  final String? currentJob;
  final String? preferredJob;
  final String? location;
  final String? phone;
  final String? customImageUrl;

  UserProfile(
     {
    this.firstName,
    this.lastName,
    this.location,
    this.phone,
    this.customImageUrl,
       this.currentJob, this.preferredJob,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(

      firstName: map['firstName'],
      lastName: map['lastName'],
      location: map['location'],
      phone: map['phone'],
      currentJob: map['currentJob'],
      preferredJob: map['preferredJob'],

      customImageUrl: map['customImageUrl'],
    );
  }
}