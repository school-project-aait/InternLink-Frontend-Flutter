import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:internlink_flutter_application/features/admin/presenation/screens/add_internship_screen.dart';
import 'package:internlink_flutter_application/features/student/presentation/screens/profile_screen.dart';
import 'package:internlink_flutter_application/features/student/presentation/screens/student_internship_list_screen.dart';
import 'core/utils/secure_storage.dart';
import 'features/admin/admin_dashboard.dart';
import 'features/admin/domain/entities/internship.dart';
import 'features/admin/presenation/screens/admin_dashboard.dart';
import 'features/admin/presenation/screens/status_determiner_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/student/presentation/screens/apply_internship_screen.dart';


final appInitializedProvider = StateProvider<bool>((ref) => false);

final routerProvider = Provider<GoRouter>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final isInitialized = ref.watch(appInitializedProvider);

  return GoRouter(
    initialLocation: '/signup',
    redirect: (context, state) async {
      if (!isInitialized) return null;
      if (state.uri.path == '/') return '/login';

      final token = await secureStorage.getToken();
      final publicRoutes = ['/login', '/signup'];
      if (token == null) {
        // Allow staying on public routes
        if (publicRoutes.contains(state.uri.path)) {
          return null;
        }
        return '/login';
      }
      // if (token == null) return '/login';

      try {
        final role = _decodeTokenRole(token);
        // Redirect away from public routes when authenticated
        if (publicRoutes.contains(state.uri.path)) {
          return role == 'admin' ? '/admin' : '/student';
        }
        // if (state.uri.path == '/login' && role != null) {
        //   return role == 'admin' ? '/admin' : '/student';
        // }
        return null;
      } catch (e) {
        await secureStorage.clearToken();
        return '/login';
      }
    },
    routes: [
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SignUpScreen(),
        ),
      ),
      // GoRoute(
      //   path: '/',
      //   redirect: (context, state) => '/login',
      // ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child:  LoginScreen(),
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
            path: 'applications/status',
            pageBuilder: (context, state) {
              final extras = state.extra as Map<String, VoidCallback>?;

              final onLogout = extras?['onLogout'] ?? () {};
              final onBackToDashboard = extras?['onBackToDashboard'] ?? () {};

              return MaterialPage(
                key: state.pageKey,
                child: StatusDeterminerScreen(
                  onLogout: onLogout,
                  onBackToDashboard: onBackToDashboard,
                ),
              );
            },
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
          child: const StudentInternshipListScreen(),
        ),
        routes: [
          GoRoute(
            path: 'applications/:internshipId',
            pageBuilder: (context, state) {
              final internshipId = state.pathParameters['internshipId'];
              if (internshipId == null || int.tryParse(internshipId) == null) {
                return MaterialPage(
                  key: state.pageKey,
                  child: Scaffold(
                    body: Center(child: Text('Invalid internship ID')),
                  ),
                );
              }
              return MaterialPage(
                key: state.pageKey,
                child: CreateApplicationScreen(
                  internshipId: int.parse(internshipId),
                ),
              );
            },
          ),
          GoRoute(
            path: 'profile',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
          ),
        ],
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