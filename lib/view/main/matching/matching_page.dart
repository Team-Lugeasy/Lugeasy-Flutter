import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MatchingPage extends StatelessWidget {
  final List<MatchingItemData> requests = [
    MatchingItemData(
      timestamp: "Today PM 03:16",
      message: "Reservation request sent to OOO.",
      imageUrl: "",
    ),
    MatchingItemData(
      timestamp: "Today AM 10:16",
      message: "Reservation request sent to OOO.",
      imageUrl: "",
    ),
  ];

  final List<MatchingItemData> confirmed = [
    MatchingItemData(
      timestamp: "3/14 AM 10:16",
      message: "Reservation with OOO confirmed.",
      imageUrl: "",
    ),
  ];

  final List<MatchingItemData> pastMatching = [
    MatchingItemData(
      timestamp: "3/12 AM 10:16",
      message: "Reservation with OOO confirmed.",
      imageUrl: "",
    ),
    MatchingItemData(
      timestamp: "2/28 AM 10:16",
      message: "Reservation with OOO confirmed.",
      imageUrl: "",
    ),
    MatchingItemData(
      timestamp: "2/19 AM 10:16",
      message: "Reservation with OOO confirmed.",
      imageUrl: "",
    ),
    MatchingItemData(
      timestamp: "1/8 AM 10:16",
      message: "Reservation with OOO confirmed.",
      imageUrl: "",
    ),
    MatchingItemData(
      timestamp: "1/7 AM 10:16",
      message: "Reservation with OOO confirmed.",
      imageUrl: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Matching")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Section(title: "Requests", items: requests),
            Section(title: "Confirmed", items: confirmed),
            Section(title: "Past matching", items: pastMatching),
            SizedBox(height: 8),
            Text(
              "See more",
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final List<MatchingItemData> items;

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

class MatchingItemData {
  final String timestamp;
  final String message;
  final String imageUrl;

  MatchingItemData({
    required this.timestamp,
    required this.message,
    required this.imageUrl,
  });
}

// 개별 아이템
class MatchingItem extends StatelessWidget {
  final MatchingItemData data;

  MatchingItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(AppLocalizations.of(context)!.matching));
  }
}
