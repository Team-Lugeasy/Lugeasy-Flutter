import 'package:flutter/material.dart';
import 'package:lugeasy/view/main/map/bottomsheet/hostdetailsheet/listitem/host_review_tile.dart';

class HostReviewList extends StatelessWidget {
  const HostReviewList({super.key});

  final List<Map<String, String>> reviews = const [
    {
      'profile_image': '',
      'reviewer_name': 'River',
      'created_at': '2days ago',
      'contents':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, s...'
    },
    {
      'profile_image': '',
      'reviewer_name': 'Liver',
      'created_at': '2days ago',
      'contents':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, s...'
    },
    {
      'profile_image': '',
      'reviewer_name': 'River',
      'created_at': '2days ago',
      'contents':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, s...'
    },
    {
      'profile_image': '',
      'reviewer_name': 'River',
      'created_at': '2days ago',
      'contents':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, s...'
    },
    {
      'profile_image': '',
      'reviewer_name': 'River',
      'created_at': '2days ago',
      'contents':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, s...'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: reviews
          .map((review) => HostReviewTile(review: review))
          .toList()
          .cast<Widget>(),
    );
  }
}
