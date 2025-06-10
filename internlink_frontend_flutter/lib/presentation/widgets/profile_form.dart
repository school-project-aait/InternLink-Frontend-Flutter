import 'package:flutter/material.dart';
import 'package:internlink_frontend_flutter/domain/entities/user_profile.dart';

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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    emailController = TextEditingController(text: widget.profile.email);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: nameController),
        TextField(controller: emailController),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
              UserProfile(
                id: widget.profile.id,
                name: nameController.text,
                email: emailController.text,
                phone: widget.profile.phone,
                address: widget.profile.address,
                gender: widget.profile.gender,
              ),
            );
          },
          child: const Text("Update"),
        ),
        ElevatedButton(
          onPressed: widget.onDelete,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
