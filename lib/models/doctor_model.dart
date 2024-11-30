class Education {
  String? degree;
  String? institution;
  int? yearOfCompletion;
  String? certificatePath;

  Education({
    this.degree,
    this.institution,
    this.yearOfCompletion,
    this.certificatePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institution': institution,
      'yearOfCompletion': yearOfCompletion,
      'certificatePath': certificatePath,
    };
  }
}

class DoctorDetailsModel {
  String? fullName;
  int? age;
  DateTime? dateOfBirth;
  String? email;
  String? gender;
  String? hospitalName;
  int? yearOfExperience;
  List<String>? availableDays;
  DateTime? workingTimeStart; // Start time
  DateTime? workingTimeEnd; // End time
  double? consultationFees;
  String? imagePath;
  List<Education>? educations;

  DoctorDetailsModel({
    this.fullName,
    this.age,
    this.dateOfBirth,
    this.email,
    this.gender,
    this.hospitalName,
    this.yearOfExperience,
    this.availableDays,
    this.workingTimeStart,
    this.workingTimeEnd,
    this.consultationFees,
    this.imagePath,
    this.educations,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'age': age,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'email': email,
      'gender': gender,
      'hospitalName': hospitalName,
      'yearOfExperience': yearOfExperience,
      'availableDays': availableDays,
      'workingTimeStart': workingTimeStart?.toIso8601String(),
      'workingTimeEnd': workingTimeEnd?.toIso8601String(),
      'consultationFees': consultationFees,
      'imagePath': imagePath,
      'educations': educations?.map((e) => e.toJson()).toList(),
    };
  }
}
