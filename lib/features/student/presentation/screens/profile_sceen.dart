import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/user.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();

  String selectedGender = 'Other';
  

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUser().then((_) {
      final user = userProvider.user;
      if (user != null) {
        nameController.text = user.fullName;
        emailController.text = user.email;
        dobController.text = user.dob;
        contactController.text = user.contactNumber;
        addressController.text = user.address;
        selectedGender = user.gender;
      }
    });
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(dobController.text) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "InternLink",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Logout logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: StadiumBorder(),
                    ),
                    child: const Text("Logout"),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Form Card
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                "Personal Information",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            _buildField('Full Name', nameController),
                            _buildDropdown(),
                            _buildField(
                              'Email',
                              emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            _buildDateField(),
                            _buildField(
                              'Contact Number',
                              contactController,
                              keyboardType: TextInputType.phone,
                            ),
                            _buildField(
                              'Address',
                              addressController,
                              maxLines: 2,
                            ),
                            _buildField(
                              'Change Password',
                              passwordController,
                              obscureText: true,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final updatedUser = User(
                                    fullName: nameController.text,
                                    gender: selectedGender,
                                    email: emailController.text,
                                    dob: dobController.text,
                                    contactNumber: contactController.text,
                                    address: addressController.text,
                                    password: passwordController.text,
                                  );
                                  userProvider.updateUser(updatedUser);
                                }
                              },
                              icon: const Icon(
                                Icons.save,
                                color: Colors.blue,
                              ),
                              label: const Text(
                                'Update Profile',
                                style: TextStyle(color: Colors.blue),
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(
                                  double.infinity,
                                  50,
                                ),
                                side: const BorderSide(color: Colors.blue),
                              ),
                            ),
                            const SizedBox(height: 10),
                            OutlinedButton.icon(
                              onPressed: () {
                                 userProvider.deleteUser();
                                },
                              icon: const Icon(Icons.delete, color: Colors.red),
                              label: const Text(
                                'Delete Account',
                                style: TextStyle(color: Colors.red),
                              ),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                side: const BorderSide(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator:
                (value) => value == null || value.isEmpty ? 'Required' : null,
            decoration: InputDecoration(
              hintText: 'Enter ${label.toLowerCase()}',
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: selectedGender,
            items:
                ['Male', 'Female', 'Other']
                    .map(
                      (gender) =>
                          DropdownMenuItem(value: gender, child: Text(gender)),
                    )
                    .toList(),
            onChanged: (value) {
                if (value != null) {
                  setState(() => selectedGender = value);
                }
            },

            decoration: const InputDecoration(
              hintText: 'Enter gender',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Date of Birth',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: dobController,
            readOnly: true,
            onTap: _pickDate,
            validator:
                (value) => value == null || value.isEmpty ? 'Required' : null,
            decoration: const InputDecoration(
              hintText: 'Select date of birth',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
        ],
      ),
    );
  }
}
