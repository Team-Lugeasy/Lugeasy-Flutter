import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lugeasy/providers/match/match_provider.dart';
import 'package:lugeasy/providers/match/past_match_provider.dart';
import 'package:lugeasy/data/models/match.dart';
import 'package:lugeasy/util/log_util.dart';

class MatchingPage extends ConsumerStatefulWidget {
  const MatchingPage({super.key});

  @override
  ConsumerState<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends ConsumerState<MatchingPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
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
      logger.d("nextpage");
      ref.read(pastMatchListProvider.notifier).nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncMatchs = ref.watch(matchListProvider);
    final asyncPastMatchs = ref.watch(pastMatchListProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Matching")),
      body: asyncMatchs.when(
        data: (list) {
          return asyncPastMatchs.when(
            data: (pastList) {
              return SingleChildScrollView(
                controller: _scrollController, // 컨트롤러 연결
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Section(title: "Requests", items: list.pendingList),
                    Section(title: "Confirmed", items: list.completeList),
                    Section(title: "Past matching", items: pastList),
                    SizedBox(height: 8),
                  ],
                ),
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('오류 발생: $e')),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('오류 발생: $e')),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final List<Match> items;

  Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: MatchingItem(data: item),
              )),
        ],
      ),
    );
  }
}

// 개별 아이템
class MatchingItem extends StatelessWidget {
  final Match data;

  MatchingItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Image.network(
                data.profileImage,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 48,
                    height: 48,
                    color: Colors.grey[300],
                    child: Icon(Icons.person, size: 24, color: Colors.white),
                  );
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        data.timeStamp,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    data.message,
                    style: TextStyle(fontSize: 14),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
