import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'package:trash2heal_shared/services/firebase_service.dart';
import 'router/app_router.dart';


import 'package:flutter_localizations/flutter_localizations.dart';



import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Toggle ini untuk mematikan inisialisasi Firebase (mis. supaya loading awal cepat).
// WARNING: ketika dimatikan, fitur yang tergantung Firebase (auth, Firestore, dsb.)
// tidak akan berfungsi.
const bool kDisableFirebase = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Load konfigurasi dari .env
  await AppConfig.initialize();

  // 2) Initialize Firebase untuk semua platform (Web, Android, iOS)
  if (!kDisableFirebase) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // 3) Initialize service Firebase (Firestore, FCM, Crashlytics, dll) secara async
    // supaya splash tidak lama menunggu.
    Future.microtask(() => FirebaseService.initialize());
  }

  // 4) Set orientasi & system UI (skip di Web)
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // 5) Jalankan aplikasi
  runApp(
    const ProviderScope(
      child: Trash2HealApp(),
    ),
  );
}


class Trash2HealApp extends ConsumerWidget {
  const Trash2HealApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,

      // ✅ FIX: Gunakan locale 'id' (bukan 'id_ID')
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ✅ FIX: Supported locales dengan format yang benar
      supportedLocales: const [
        Locale('id'), // Indonesian (tanpa country code)
        Locale('en', 'US'), // English US
      ],

      // ✅ FIX: Default locale
      locale: const Locale('id'),

      builder: (context, child) {
        // Error widget customization
        ErrorWidget.builder = (details) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Something went wrong',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConfig.isDev
                          ? details.exceptionAsString()
                          : 'Please restart the app',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        };

        return child ?? const SizedBox.shrink();
      },
    );
  }
}
