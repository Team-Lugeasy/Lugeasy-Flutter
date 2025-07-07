// locale_provider.dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

const _localeStorageKey = 'app_locale';

/// 지원하는 언어 목록
const supportedLocales = [
  Locale('ko'), // 한국어
  Locale('en'), // 영어
];

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  FutureOr<Locale> build() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeStorageKey);
    return Locale(code ?? 'ko'); // 기본값은 'ko'
  }

  Future<void> updateLocale(Locale newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeStorageKey, newLocale.languageCode);
    state = AsyncValue.data(newLocale);
  }
}
