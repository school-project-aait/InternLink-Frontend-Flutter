import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:internlink_flutter_application/features/admin/presenation/screens/add_internship_screen.dart';
import 'package:internlink_flutter_application/features/student/presentation/screens/student_internship_list_screen.dart';
import 'package:internlink_flutter_application/features/student/presentation/screens/profile_sceen.dart';
import 'core/utils/secure_storage.dart';
import 'features/admin/admin_dashboard.dart';
import 'features/admin/domain/entities/internship.dart';
import 'features/admin/presenation/screens/admin_dashboard.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/student/student_dashboard.dart';

final appInitializedProvider = StateProvider<bool>((ref) => false);

final routerProvider = Provider<GoRouter>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final isInitialized = ref.watch(appInitializedProvider);

  return GoRouter(
    initialLocation: '/profile',
    redirect: (context, state) async {
      if (!isInitialized) return null;
      if (state.uri.path == '/') return '/profile';

      final token = await secureStorage.getToken();
      if (token == null) return '/profile';

      try {
        final role = _decodeTokenRole(token);
        if (state.uri.path == '/profile' && role != null) {
          return role == 'admin' ? '/admin' : '/student';
        }
        return null;
      } catch (e) {
        await secureStorage.clearToken();
        return '/profile';
      }
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/profile',
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child:  ProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/admin',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const AdminDashboard(),
        ),
        routes: [
          GoRoute(
            path: 'internships/add',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const AddEditInternshipScreen(),
            ),
          ),
          GoRoute(
            path: 'internships/edit/:id',
            pageBuilder: (context, state) {
              final internship = state.extra as Internship?;
              if (internship == null) {
                return MaterialPage(
                  key: state.pageKey,
                  child: Scaffold(
                    body: Center(child: Text('Internship data not available')),
                  ),

                );



                }
                  return MaterialPage(
                  key: state.pageKey,
                  child: AddEditInternshipScreen(internship: internship),
                );
              },
          ),
        ],
      ),
      GoRoute(
        path: '/student',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child:  StudentInternshipListScreen(),
        ),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Text('Route not found: ${state.uri.path}'),
        ),
      ),
    ),
  );
});

String? _decodeTokenRole(String token) {
  final parts = token.split('.');
  if (parts.length != 3) throw Exception('Invalid JWT');
  final payload = base64Url.normalize(parts[1]);
  final decoded = utf8.decode(base64Url.decode(payload));
  final jsonMap = jsonDecode(decoded) as Map<String, dynamic>;
  return jsonMap['role']?.toString();
}