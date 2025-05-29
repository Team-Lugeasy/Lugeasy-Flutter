import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lugeasy/util/log_util.dart';
import 'package:lugeasy/view/login/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "env/.env");
  requestLocationPermission();
  await FlutterNaverMap().init(
      clientId: dotenv.env['NAVER_CLIENT_ID']!,
      onAuthFailed: (ex) => switch (ex) {
            NQuotaExceededException(:final message) =>
              logger.d("사용량 초과 (message: $message)"),
            NUnauthorizedClientException() ||
            NClientUnspecifiedException() ||
            NAnotherAuthFailedException() =>
              logger.d("인증 실패: $ex"),
          });

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
      logger.d('Firebase 초기화 시도');
    } else {
      rethrow;
    }
  }

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginPage(),
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
