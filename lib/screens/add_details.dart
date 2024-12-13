import 'package:flutter/material.dart';
import 'package:masiha_doctor/widgets/add_details/education_section.dart';
import 'package:masiha_doctor/widgets/add_details/save_button.dart';
import 'package:masiha_doctor/widgets/add_details/speciality_dropdown.dart';
import 'package:provider/provider.dart';
import '../providers/doc_details_provider.dart';
import '../widgets/add_details/profile_image.dart';
import '../widgets/add_details/text_input.dart';
import '../widgets/add_details/date_input.dart';
import '../widgets/add_details/gender_dropdown.dart';

class DoctorDetailsPage extends StatelessWidget {
  const DoctorDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Doctor Details'),
      ),
      body: Consumer<DoctorDetailsProvider>(
        builder: (context, doctorDetailsProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: doctorDetailsProvider.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileImageWidget(provider: doctorDetailsProvider),
                  const SizedBox(height: 24),
                  TextInputWidget(
                    label: 'Full Name',
                    onSaved: (value) =>
                        doctorDetailsProvider.doctor.fullName = value,
                    validator: doctorDetailsProvider.validateName,
                  ),
                  const SizedBox(height: 16),
                  TextInputWidget(
                    label: 'Age',
                    keyboardType: TextInputType.number,
                    onSaved: (value) => doctorDetailsProvider.doctor.age =
                        int.tryParse(value ?? ''),
                    validator: doctorDetailsProvider.validateAge,
                  ),
                  const SizedBox(height: 16),
                  DateInputWidget(provider: doctorDetailsProvider),
                  const SizedBox(height: 16),
                  TextInputWidget(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) =>
                        doctorDetailsProvider.doctor.email = value,
                    validator: doctorDetailsProvider.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  GenderDropdownWidget(provider: doctorDetailsProvider),
                  const SizedBox(height: 16),
                  TextInputWidget(
                    label: 'Hospital Name',
                    onSaved: (value) =>
                        doctorDetailsProvider.doctor.hospitalName = value,
                    validator: doctorDetailsProvider.validateHospitalName,
                  ),
                  const SizedBox(height: 16),
                  TextInputWidget(
                    label: 'Year of Experience',
                    keyboardType: TextInputType.number,
                    onSaved: (value) => doctorDetailsProvider
                        .doctor.yearOfExperience = int.tryParse(value ?? ''),
                    validator: doctorDetailsProvider.validateYearOfExperience,
                  ),
                  const SizedBox(height: 16),
                  // TextInputWidget(
                  //   label: 'Specialty',
                  //   onSaved: (value) =>
                  //       doctorDetailsProvider.doctor.specialty = value,
                  //   validator: doctorDetailsProvider.validateSpeciality,
                  // ),
                  SpecialtyDropdown(
                      doctorDetailsProvider: doctorDetailsProvider),
                  const SizedBox(height: 16),
                  EducationSection(provider: doctorDetailsProvider),
                  const SizedBox(height: 24),
                  NextButtonWidget(provider: doctorDetailsProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
