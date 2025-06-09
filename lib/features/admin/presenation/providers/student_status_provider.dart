// lib/providers/student_status_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/student_status_state.dart';

final studentStatusProvider = StateNotifierProvider<StudentStatusNotifier, StudentStatusUiState>(
      (ref) => StudentStatusNotifier(),
);

class StudentStatusNotifier extends StateNotifier<StudentStatusUiState> {
  StudentStatusNotifier() : super(StudentStatusUiState()) {
    // Initialize by loading students
    loadStudents();
  }

  Future<void> loadStudents() async {
    try {
      // Replace with your actual data fetching logic
      // For demo, static data:
      final students = [
        StudentStatus(id: 1, name: 'Alice', email: 'alice@example.com', resumeUrl: 'https://resume.example.com/alice', status: 'Pending'),
        StudentStatus(id: 2, name: 'Bob', email: 'bob@example.com', resumeUrl: 'https://resume.example.com/bob', status: 'Accepted'),
      ];
      state = state.copyWith(students: students, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void updateStatus(int id, String newStatus) {
    try {
      final updatedStudents = state.students.map((student) {
        if (student.id == id) {
          return student.copyWith(status: newStatus);
        }
        return student;
      }).toList();
      state = state.copyWith(students: updatedStudents);
      // Add your backend update call here asynchronously if needed
    } catch (e) {
      state = state.copyWith(error: "Update failed: $e");
    }
  }
}
