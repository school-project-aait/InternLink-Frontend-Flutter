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
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController genderController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    phoneController = TextEditingController(text: widget.profile.phone ?? '');
    addressController = TextEditingController(text: widget.profile.address ?? '');
    genderController = TextEditingController(text: widget.profile.gender ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildTextField('Full name', nameController),
          const SizedBox(height: 16),
          const Text(
            'Contact number',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildTextField('Contact number', phoneController),
          const SizedBox(height: 16),
          const Text(
            'Address',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildTextField('Address', addressController),
          const SizedBox(height: 16),
          const Text(
            'Gender',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildTextField('Gender', genderController),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (widget.profile.id == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Cannot update profile without ID")),
                );
                return;
              }

              widget.onSave(
                UserProfile(
                  id: widget.profile.id!, // Non-null assertion
                  name: nameController.text,
                  email: widget.profile.email,
                  phone: phoneController.text.isEmpty ? null : phoneController.text,
                  address: addressController.text.isEmpty ? null : addressController.text,
                  gender: genderController.text.isEmpty ? null : genderController.text,
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
    );
  }
}