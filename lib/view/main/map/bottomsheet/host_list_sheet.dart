import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lugeasy/providers/host/host_provider.dart';
import 'package:lugeasy/data/models/host.dart';
import 'package:lugeasy/core/constants.dart';
import 'package:lugeasy/core/extensions/context_extension.dart';
import 'package:lugeasy/core/util/log_util.dart';

class HostListTile extends StatelessWidget {
  final Host host;
  final VoidCallback onTap;

  const HostListTile({
    super.key,
    required this.host,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = host.profileImage.toString().isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30), // 위/아래 30px
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 30), // 왼쪽 여백 15 + 15
            hasImage
                ? CircleAvatar(
                    backgroundImage: NetworkImage(host.profileImage),
                    radius: 52,
                  )
                : defaultProfileIcon(iconSize: 52),
            const SizedBox(width: 20), // 텍스트 왼쪽 마진
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 15), // 오른쪽 여백
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      host.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          '${host.reviewRate} ★',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 16,
                          color: const Color(0x4D000000), // 블랙 30%
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${context.l10n.review}  ${host.reviewCount}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      host.address,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HostListSheet extends ConsumerStatefulWidget {
  // 호스트 클릭 시 호출되는 콜백
  final void Function(Host) onHostTap;

  HostListSheet({super.key, required this.onHostTap});

  @override
  ConsumerState<HostListSheet> createState() => _HostListSheetState();
}

class _HostListSheetState extends ConsumerState<HostListSheet> {
  final ScrollController _scrollController = ScrollController();
  bool _hasTriggeredNextPage = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 10) {
      // 이미 다음 페이지를 요청했으면 무시
      if (_hasTriggeredNextPage) {
        print("Scroll trigger blocked: already triggered");
        return;
      }

      _hasTriggeredNextPage = true;
      logger.d("nextpage");
      print("Scroll trigger: calling nextPage");
      ref.read(hostListProvider.notifier).nextPage();
    } else {
      // 스크롤이 끝에서 벗어나면 플래그 리셋
      if (_hasTriggeredNextPage) {
        print("Scroll trigger reset: moved away from bottom");
      }
      _hasTriggeredNextPage = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncHosts = ref.watch(hostListProvider);

    return asyncHosts.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (hosts) => ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 30),
        itemCount: hosts.length,
        separatorBuilder: (_, __) => const Divider(height: 0.5),
        itemBuilder: (context, index) {
          final host = hosts[index];
          return HostListTile(
            host: host,
            onTap: () => widget.onHostTap(host),
          );
        },
      ),
    );
  }
}
