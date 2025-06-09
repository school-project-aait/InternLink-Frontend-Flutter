import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserRemoteDataSource {
  final String baseUrl = 'https://your-api.com';

  Future<UserModel> getUserProfile() async {
    final response = await http.get(Uri.parse('$baseUrl/user/profile'));
    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> updateUserProfile(UserModel user) async {
    await http.put(
      Uri.parse('$baseUrl/user/profile'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
  }

  Future<void> deleteUser() async {
    await http.delete(Uri.parse('$baseUrl/user'));
  }
}
