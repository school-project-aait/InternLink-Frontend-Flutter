import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_router.dart';
import 'core/utils/secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Force fresh login during development
  final storage = SecureStorage();
  await storage.clearToken();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // ✅ Initialize app router after first frame to trigger redirect
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appInitializedProvider.notifier).state = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
