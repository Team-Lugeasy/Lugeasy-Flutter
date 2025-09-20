import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lugeasy/providers/auth/locale_provider.dart';
import 'package:lugeasy/core/util/log_util.dart';
import 'package:lugeasy/view/login/login_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lugeasy/view/navigation_route.dart';
import 'package:lugeasy/view/navigation_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "env/.env");

  await requestLocationPermission();

  await FlutterNaverMap().init(
    clientId: dotenv.env['NAVER_CLIENT_ID']!,
    onAuthFailed: (ex) => switch (ex) {
      NQuotaExceededException(:final message) =>
        logger.d("사용량 초과 (message: $message)"),
      NUnauthorizedClientException() ||
      NClientUnspecifiedException() ||
      NAnotherAuthFailedException() =>
        logger.d("인증 실패: $ex"),
    },
  );

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: dotenv.env['FIREBASE_API_KEY']!,
          appId: dotenv.env['FIREBASE_APP_ID']!,
          messagingSenderId: "123456",
          projectId: "pc-api-9088886599585804524-472",
        ),
      );
      logger.d('Firebase 초기화 완료');
    }
  } catch (e) {
    if (e.toString().contains("already exists")) {
      logger.d('Firebase 이미 초기화됨');
    } else {
      rethrow;
    }
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeAsync = ref.watch(localeNotifierProvider);

    return localeAsync.when(
      data: (locale) {
        return ScreenUtilInit(
          designSize: const Size(412, 917),
          builder: (context, child) {
            return MaterialApp(
              title: 'Flutter Demo',
              locale: locale,
              supportedLocales: const [Locale("en"), Locale("ko")],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: ThemeData(
                fontFamily: 'Pretendard',
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
              home: const LoginView(),
              routes: NavigationRoute.routes,
              navigatorKey: NavigationService.navigatorKey,
            );
          },
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, _) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('로케일 로딩 실패: $error')),
        ),
      ),
    );
  }
}

Future<void> requestLocationPermission() async {
  var status = await Permission.location.request();
  if (status.isGranted) {
    logger.d('위치 권한 허용됨');
  } else {
    logger.d('위치 권한 거부됨');
  }
}
