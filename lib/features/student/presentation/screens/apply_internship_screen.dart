// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:internlink/core/widgets/custom_text_field.dart';
// import 'package:internlink/features/applications/presentation/managers/application_manager.dart';
// import 'package:internlink/features/applications/presentation/widgets/rounded_border_button.dart';
//
// class ApplyInternshipScreen extends ConsumerStatefulWidget {
//   final int internshipId;
//   final Application? application;
//
//   const ApplyInternshipScreen({
//     super.key,
//     required this.internshipId,
//     this.application,
//   });
//
//   @override
//   ConsumerState<ApplyInternshipScreen> createState() =>
//       _ApplyInternshipScreenState();
// }
//
// class _ApplyInternshipScreenState extends ConsumerState<ApplyInternshipScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _universityController;
//   late TextEditingController _degreeController;
//   late TextEditingController _graduationYearController;
//   late TextEditingController _linkedInController;
//   File? _resumeFile;
//   String? _resumeFileName;
//
//   @override
//   void initState() {
//     super.initState();
//     _universityController = TextEditingController(
//         text: widget.application?.university ?? '');
//     _degreeController =
//         TextEditingController(text: widget.application?.degree ?? '');
//     _graduationYearController = TextEditingController(
//         text: widget.application?.graduationYear.toString() ?? '');
//     _linkedInController =
//         TextEditingController(text: widget.application?.linkedIn ?? '');
//   }
//
//   @override
//   void dispose() {
//     _universityController.dispose();
//     _degreeController.dispose();
//     _graduationYearController.dispose();
//     _linkedInController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickResume() async {
//     final pickedFile =
//     await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _resumeFile = File(pickedFile.path);
//         _resumeFileName = pickedFile.name;
//       });
//     }
//   }
//
//   Future<void> _submitApplication() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_resumeFile == null && widget.application == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please upload a resume file')),
//       );
//       return;
//     }
//
//     final graduationYear = int.tryParse(_graduationYearController.text);
//     if (graduationYear == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid graduation year')),
//       );
//       return;
//     }
//
//     if (widget.application == null) {
//       // Create new application
//       final resumeBytes = await _resumeFile!.readAsBytes();
//       await ref.read(applicationManagerProvider.notifier).createNewApplication(
//         internshipId: widget.internshipId,
//         university: _universityController.text,
//         degree: _degreeController.text,
//         graduationYear: graduationYear,
//         linkedIn: _linkedInController.text,
//         resumeFile: resumeBytes,
//         fileName: _resumeFileName!,
//       );
//     } else {
//       // Update existing application
//       List<int>? resumeBytes;
//       if (_resumeFile != null) {
//         resumeBytes = await _resumeFile!.readAsBytes();
//       }
//
//       await ref.read(applicationManagerProvider.notifier).updateExistingApplication(
//         applicationId: widget.application!.id,
//         university: _universityController.text,
//         degree: _degreeController.text,
//         graduationYear: graduationYear,
//         linkedIn: _linkedInController.text,
//         resumeFile: resumeBytes,
//         fileName: _resumeFileName,
//       );
//     }
//
//     if (mounted) {
//       Navigator.of(context).pop();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(applicationManagerProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.application == null
//             ? 'Apply for Internship'
//             : 'Update Application'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               CustomTextField(
//                 controller: _universityController,
//                 label: 'University',
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your university';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               CustomTextField(
//                 controller: _degreeController,
//                 label: 'Degree',
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your degree program';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               CustomTextField(
//                 controller: _graduationYearController,
//                 label: 'Graduation Year',
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your graduation year';
//                   }
//                   final year = int.tryParse(value);
//                   if (year == null || year < 2000 || year > 2030) {
//                     return 'Enter a valid year between 2000-2030';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               CustomTextField(
//                 controller: _linkedInController,
//                 label: 'LinkedIn Profile',
//                 validator: (value) {
//                   if (value != null &&
//                       value.isNotEmpty &&
//                       !value.contains('linkedin.com')) {
//                     return 'Please enter a valid LinkedIn URL';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _pickResume,
//                 child: Text(_resumeFile != null
//                     ? _resumeFileName!
//                     : widget.application?.attachmentPath != null
//                     ? 'Resume uploaded'
//                     : 'Upload Resume'),
//               ),
//               if (state.error != null)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Text(
//                     state.error!,
//                     style: TextStyle(color: Theme.of(context).colorScheme.error),
//                   ),
//                 ),
//               const SizedBox(height: 24),
//               RoundedBorderButton(
//                 text: widget.application == null ? 'Submit' : 'Update',
//                 isLoading: state.isLoading,
//                 onPressed: _submitApplication,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }