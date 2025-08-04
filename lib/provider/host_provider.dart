// host_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lugeasy/models/host.dart';

part 'host_provider.g.dart';

@riverpod
class HostNotifier extends _$HostNotifier {
  @override
  Host? build() => null;

  void select(Host host) => state = host;

  void clear() => state = null;
}
