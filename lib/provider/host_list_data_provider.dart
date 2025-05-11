import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

import 'package:lugeasy/services/model/host.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'host_list_data_provider.g.dart';

@riverpod
class HostListNotifier extends _$HostListNotifier {
  @override
  Future<List<Host>> build() async {
    // dummy data. 여기다 api 연결
    const jsonData = '''
    [
      {
        "name": "Alice",
        "profile_image": "https://example.com/alice.jpg",
        "review_rate": 4.8,
        "review_count": 120,
        "address": "123 Main Street",
        "description": "Experienced host"
      },
      {
        "name": "Bob",
        "profile_image": "https://example.com/bob.jpg",
        "review_rate": 4.6,
        "review_count": 90,
        "address": "456 Oak Avenue",
        "description": "Friendly and professional"
      }
    ]
    ''';

    final List<dynamic> parsedJson = json.decode(jsonData);
    final hosts = parsedJson.map((e) => Host.fromJson(e)).toList();
    return hosts;
  }

  // 다시 불러오기
  Future<void> refreshHosts() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}
