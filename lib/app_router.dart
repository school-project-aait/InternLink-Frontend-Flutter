import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:internlink_flutter_application/features/admin/presenation/screens/add_internship_screen.dart';
import 'package:internlink_flutter_application/features/student/presentation/screens/student_internship_list_screen.dart';
import 'core/utils/secure_storage.dart';
import 'features/admin/domain/entities/internship.dart';
import 'features/admin/presenation/screens/admin_dashboard.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/student/student_dashboard.dart';
import 'features/common/waiting_screen.dart';
import 'features/common/landing_screen.dart';

final appInitializedProvider = StateProvider<bool>((ref) => false);

final routerProvider = Provider<GoRouter>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final isInitialized = ref.watch(appInitializedProvider);

  return GoRouter(
    initialLocation: '/landing',
    redirect: (context, state) async {
      if (!isInitialized) return null;

      final token = await secureStorage.getToken();
      if (token == null) {
        if (state.uri.path == '/login' || state.uri.path == '/landing') {
          return null;
        }
        return '/login';
      }

      try {
        final role = _decodeTokenRole(token);

        if (state.uri.path == '/login') {
          return role == 'admin' ? '/admin' : '/student';
        }

        if (state.uri.path == '/landing') {
          return '/waiting';
        }

        return null;
      } catch (e) {
        await secureStorage.clearToken();
        return '/login';
      }
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/landing',
      ),
      GoRoute(
        path: '/landing',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LandingPage(),
        ),
      ),
      GoRoute(
        path: '/waiting',
        pageBuilder: (context, state) {
          final nextRoute = state.extra as String?;
          return MaterialPage(
            key: state.pageKey,
            child: WaitingPage(nextRoute: nextRoute ?? '/login'),
          );
        },
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: LoginScreen(),
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
              return MaterialPage(
                key: state.pageKey,
                child: internship == null
                    ? const Scaffold(
                  body: Center(child: Text('Internship data not available')),
                )
                    : AddEditInternshipScreen(internship: internship),
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





// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:internlink_flutter_application/features/admin/presenation/screens/add_internship_screen.dart';
// import 'package:internlink_flutter_application/features/student/presentation/screens/student_internship_list_screen.dart';
// import 'core/utils/secure_storage.dart';
// import 'features/admin/admin_dashboard.dart';
// import 'features/admin/domain/entities/internship.dart';
// import 'features/admin/presenation/screens/admin_dashboard.dart';
// import 'features/auth/presentation/screens/login_screen.dart';
// import 'features/student/student_dashboard.dart';
// import 'features/common/waiting_screen.dart';
//
// final appInitializedProvider = StateProvider<bool>((ref) => false);
//
// final routerProvider = Provider<GoRouter>((ref) {
//   final secureStorage = ref.watch(secureStorageProvider);
//   final isInitialized = ref.watch(appInitializedProvider);
//
//   return GoRouter(
//     initialLocation: '/login',
//     redirect: (context, state) async {
//       if (!isInitialized) return null;
//       if (state.uri.path == '/') return '/login';
//
//       final token = await secureStorage.getToken();
//       if (token == null) return '/login';
//
//       try {
//         final role = _decodeTokenRole(token);
//         if (state.uri.path == '/login' && role != null) {
//           return role == 'admin' ? '/admin' : '/student';
//         }
//         return null;
//       } catch (e) {
//         await secureStorage.clearToken();
//         return '/login';
//       }
//     },
//     routes: [
//       GoRoute(
//         path: '/',
//         redirect: (context, state) => '/login',
//       ),
//       GoRoute(
//         path: '/login',
//         pageBuilder: (context, state) => MaterialPage(
//           key: state.pageKey,
//           child: LoginScreen(),
//         ),
//       ),
//       GoRoute(
//         path: '/waiting',
//         pageBuilder: (context, state) {
//           final nextRoute = state.extra as String? ?? '/login';
//           return MaterialPage(
//             key: state.pageKey,
//             child: WaitingPage(nextRoute: nextRoute),
//           );
//         },
//       ),
//       GoRoute(
//         path: '/admin',
//         pageBuilder: (context, state) => MaterialPage(
//           key: state.pageKey,
//           child: const AdminDashboard(),
//         ),
//         routes: [
//           GoRoute(
//             path: 'internships/add',
//             pageBuilder: (context, state) => MaterialPage(
//               key: state.pageKey,
//               child: const AddEditInternshipScreen(),
//             ),
//           ),
//           GoRoute(
//             path: 'internships/edit/:id',
//             pageBuilder: (context, state) {
//               final internship = state.extra as Internship?;
//               if (internship == null) {
//                 return MaterialPage(
//                   key: state.pageKey,
//                   child: Scaffold(
//                     body: Center(child: Text('Internship data not available')),
//                   ),
//                 );
//               }
//               return MaterialPage(
//                 key: state.pageKey,
//                 child: AddEditInternshipScreen(internship: internship),
//               );
//             },
//           ),
//         ],
//       ),
//       GoRoute(
//         path: '/student',
//         pageBuilder: (context, state) => MaterialPage(
//           key: state.pageKey,
//           child: StudentInternshipListScreen(),
//         ),
//       ),
//     ],
//     errorPageBuilder: (context, state) => MaterialPage(
//       key: state.pageKey,
//       child: Scaffold(
//         body: Center(
//           child: Text('Route not found: ${state.uri.path}'),
//         ),
//       ),
//     ),
//   );
// });
//
// String? _decodeTokenRole(String token) {
//   final parts = token.split('.');
//   if (parts.length != 3) throw Exception('Invalid JWT');
//   final payload = base64Url.normalize(parts[1]);
//   final decoded = utf8.decode(base64Url.decode(payload));
//   final jsonMap = jsonDecode(decoded) as Map<String, dynamic>;
//   return jsonMap['role']?.toString();
// }



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:internlink_flutter_application/features/admin/presenation/screens/add_internship_screen.dart';
// import 'package:internlink_flutter_application/features/student/presentation/screens/student_internship_list_screen.dart';
// import 'core/utils/secure_storage.dart';
// import 'features/admin/admin_dashboard.dart';
// import 'features/admin/domain/entities/internship.dart';
// import 'features/admin/presenation/screens/admin_dashboard.dart';
// import 'features/auth/presentation/screens/login_screen.dart';
// import 'features/student/student_dashboard.dart';
//
// final appInitializedProvider = StateProvider<bool>((ref) => false);
//
// final routerProvider = Provider<GoRouter>((ref) {
//   final secureStorage = ref.watch(secureStorageProvider);
//   final isInitialized = ref.watch(appInitializedProvider);
//
//   return GoRouter(
//     initialLocation: '/login',
//     redirect: (context, state) async {
//       if (!isInitialized) return null;
//       if (state.uri.path == '/') return '/login';
//
//       final token = await secureStorage.getToken();
//       if (token == null) return '/login';
//
//       try {
//         final role = _decodeTokenRole(token);
//         if (state.uri.path == '/login' && role != null) {
//           return role == 'admin' ? '/admin' : '/student';
//         }
//         return null;
//       } catch (e) {
//         await secureStorage.clearToken();
//         return '/login';
//       }
//     },
//     routes: [
//       GoRoute(
//         path: '/',
//         redirect: (context, state) => '/login',
//       ),
//       GoRoute(
//         path: '/login',
//         pageBuilder: (context, state) => MaterialPage(
//           key: state.pageKey,
//           child:  LoginScreen(),
//         ),
//       ),
//       GoRoute(
//         path: '/admin',
//         pageBuilder: (context, state) => MaterialPage(
//           key: state.pageKey,
//           child: const AdminDashboard(),
//         ),
//         routes: [
//           GoRoute(
//             path: 'internships/add',
//             pageBuilder: (context, state) => MaterialPage(
//               key: state.pageKey,
//               child: const AddEditInternshipScreen(),
//             ),
//           ),
//           GoRoute(
//             path: 'internships/edit/:id',
//             pageBuilder: (context, state) {
//               final internship = state.extra as Internship?;
//               if (internship == null) {
//                 return MaterialPage(
//                   key: state.pageKey,
//                   child: Scaffold(
//                     body: Center(child: Text('Internship data not available')),
//                   ),
//
//                 );
//
//
//
//                 }
//                   return MaterialPage(
//                   key: state.pageKey,
//                   child: AddEditInternshipScreen(internship: internship),
//                 );
//               },
//           ),
//         ],
//       ),
//       GoRoute(
//         path: '/student',
//         pageBuilder: (context, state) => MaterialPage(
//           key: state.pageKey,
//           child:  StudentInternshipListScreen(),
//         ),
//       ),
//     ],
//     errorPageBuilder: (context, state) => MaterialPage(
//       key: state.pageKey,
//       child: Scaffold(
//         body: Center(
//           child: Text('Route not found: ${state.uri.path}'),
//         ),
//       ),
//     ),
//   );
// });
//
// String? _decodeTokenRole(String token) {
//   final parts = token.split('.');
//   if (parts.length != 3) throw Exception('Invalid JWT');
//   final payload = base64Url.normalize(parts[1]);
//   final decoded = utf8.decode(base64Url.decode(payload));
//   final jsonMap = jsonDecode(decoded) as Map<String, dynamic>;
//   return jsonMap['role']?.toString();
// }