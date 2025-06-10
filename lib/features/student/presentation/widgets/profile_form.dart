import 'package:flutter/material.dart';
import '../../domain/entities/user_profile.dart';

class ProfileForm extends StatefulWidget {
  final UserProfile profile;
  final void Function(UserProfile) onSave;
  final VoidCallback onDelete;

  const ProfileForm({
    required this.profile,
    required this.onSave,
    required this.onDelete,
    super.key,
  });

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController genderController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    emailController = TextEditingController(text: widget.profile.email);
    phoneController = TextEditingController(text: widget.profile.phone);
    addressController = TextEditingController(text: widget.profile.address);
    genderController = TextEditingController(text: widget.profile.gender);
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Personal Information Section
          const Text(
            'Personal Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildTextField('Full name', nameController),
          const SizedBox(height: 12),

          // Gender Section
          const Text(
            'Gender',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildTextField('Gender', genderController),
          const SizedBox(height: 12),
          // Email section
          const Text(
            'Email',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildTextField('Email', emailController),
          const SizedBox(height: 16),

          // Contact Number Section
          const Text(
            'Contact number',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildTextField('Contact number', phoneController),
          const SizedBox(height: 16),

          // Address Section
          const Text(
            'Address',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildTextField('Address', addressController),
          const SizedBox(height: 16),

          // Change Password Section
          const Text(
            'Change password',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildTextField('New password', passwordController,
              obscureText: true),
          const SizedBox(height: 24),

          // Action Buttons
          ElevatedButton(
            onPressed: () {
              widget.onSave(
                UserProfile(
                  id: widget.profile.id,
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  address: addressController.text,
                  gender: genderController.text,
                ),
              );
            },
            child: const Text("Update Profile"),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: widget.onDelete,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
    );
  }
}
