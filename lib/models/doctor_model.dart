class User {
  String? imagePath; // Changed from imageUrl to imagePath for local storage
  String? fullName;
  int? age;
  DateTime? dateOfBirth;
  String? email;
  String? gender;

  User({
    this.imagePath,
    this.fullName,
    this.age,
    this.dateOfBirth,
    this.email,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'fullName': fullName,
      'age': age,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'email': email,
      'gender': gender,
    };
  }
}
