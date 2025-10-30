import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lugeasy/core/util/log_util.dart';
import 'package:lugeasy/data/datasources/remote/intro_services.dart';
import 'package:lugeasy/data/models/login_response.dart';
import 'package:lugeasy/data/models/root_response.dart';
import 'package:lugeasy/view/navigation_route.dart';
import 'package:lugeasy/view/navigation_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_view_model.g.dart';

sealed class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginFailure extends LoginState {
  final String message;
  const LoginFailure(this.message);
}

class LoginSuccess extends LoginState {
  final String message;
  const LoginSuccess(this.message);
}

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  LoginState build() {
    return const LoginInitial();
  }

  Future<void> googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
        // 이 옵션이 serverAuthCode를 활성화함
        serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID']!,
      ).signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth?.accessToken,
      //   idToken: googleAuth?.idToken,
      // );

      // final token = await FirebaseAuth.instance.signInWithCredential(
      //   credential,
      // );

      final idToken = googleAuth?.idToken;
      if (idToken == null) {
        logger.d("ID 토큰이 null입니다.");
        return;
      }
      login(idToken, "GOOGLE");
    } catch (error) {
      state = LoginFailure(error.toString());
    }
  }

  Future<void> login(String token, String type) async {
    logger.d("ID 토큰: $token");
    await IntroServices().login(token, type).then((result) {
      if (result is Success<LoginResponse>) {
        state = LoginSuccess("로그인 성공");
        logger.d("로그인 성공: ${result.data}");
        NavigationService().navigateClear(NavigationRoute.mainContainer);
      } else if (result is Error<LoginResponse>) {
        logger.d("로그인 실패: ${result.message}");
      }
    }).catchError((error) {
      logger.d("로그인 예외 발생: ${error.toString()}");
      state = LoginFailure(error.toString());
    });
  }
}
