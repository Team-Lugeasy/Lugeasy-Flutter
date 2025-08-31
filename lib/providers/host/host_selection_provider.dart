// host_selection_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lugeasy/data/models/host.dart';

part 'host_selection_provider.g.dart';

@riverpod
class HostSelectionProvider extends _$HostSelectionProvider {
  @override
  Host? build() => null;

  void select(Host host) => state = host;

  void clear() => state = null;
}

// Provider 이름을 export (한 번만 사용)
final hostNotifierProvider = hostSelectionProviderProvider;
