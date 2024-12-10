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

enum RequestStatus {
  pending,
  approved,
  rejected,
}

extension RequestStatusExtension on RequestStatus {
  String get displayName {
    switch (this) {
      case RequestStatus.pending:
        return 'Pending Review';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.rejected:
        return 'Rejected';
    }
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
  // List<String>? availableDays;
  // DateTime? workingTimeStart; // Start time
  // DateTime? workingTimeEnd; // End time
  String? specialty;
  String? imagePath;
  List<Education>? educations;
  String? requestId;
  RequestStatus requestStatus = RequestStatus.pending;

  DoctorDetailsModel({
    this.fullName,
    this.age,
    this.dateOfBirth,
    this.email,
    this.gender,
    this.hospitalName,
    this.yearOfExperience,
    // this.availableDays,
    // this.workingTimeStart,
    // this.workingTimeEnd,
    this.specialty,
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
      // 'availableDays': availableDays,
      // 'workingTimeStart': workingTimeStart?.toIso8601String(),
      // 'workingTimeEnd': workingTimeEnd?.toIso8601String(),
      'specialty': specialty,
      'imagePath': imagePath,
      'educations': educations?.map((e) => e.toJson()).toList(),
      'requestId': requestId,
      'requestStatus': requestStatus
          .toString()
          .split('.')
          .last, // Optional: Serialize enum as a string
    };
  }

  factory DoctorDetailsModel.fromJson(Map<String, dynamic> json) {
    return DoctorDetailsModel(
      fullName: json['fullName'],
      age: json['age'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      email: json['email'],
      gender: json['gender'],
      hospitalName: json['hospitalName'],
      yearOfExperience: json['yearOfExperience'],
      // availableDays: json['availableDays'] != null
      //     ? List<String>.from(json['availableDays'])
      //     : null,
      // workingTimeStart: json['workingTimeStart'] != null
      //     ? DateTime.parse(json['workingTimeStart'])
      //     : null,
      // workingTimeEnd: json['workingTimeEnd'] != null
      //     ? DateTime.parse(json['workingTimeEnd'])
      //     : null,
      specialty: json['specialty'],
      imagePath: json['imagePath'],
      educations: json['educations'] != null
          ? (json['educations'] as List)
              .map((e) => Education(
                    degree: e['degree'],
                    institution: e['institution'],
                    yearOfCompletion: e['yearOfCompletion'],
                    certificatePath: e['certificatePath'],
                  ))
              .toList()
          : null,
    )..requestStatus = RequestStatus.values.firstWhere(
        (status) => status.toString().split('.').last == json['requestStatus'],
        orElse: () => RequestStatus.pending,
      );
  }
}
