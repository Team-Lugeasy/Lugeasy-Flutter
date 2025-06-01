import 'package:flutter/material.dart';
import 'package:lugeasy/services/model/review.dart';
import 'package:lugeasy/view/main/map/bottomsheet/hostdetailsheet/review/listitem/host_review_tile.dart';

class HostReviewList extends StatelessWidget {
  HostReviewList({super.key});

  final List<Review> reviews = [
    Review.fromJson({
      'review_id': 1,
      'profile_image': '',
      'reviewer_name': 'River',
      'created_at': '2days ago',
      'contents':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, s...'
    }),
    Review.fromJson({
      'review_id': 2,
      'profile_image': '',
      'reviewer_name': 'Liver',
      'created_at': '2days ago',
      'contents':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, s...'
    }),
    Review.fromJson({
      'review_id': 3,
      'profile_image': '',
      'reviewer_name': 'River',
      'created_at': '2days ago',
      'contents':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, s...'
    }),
    Review.fromJson({
      'review_id': 4,
      'profile_image': '',
      'reviewer_name': 'River',
      'created_at': '2days ago',
      'contents':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, s...'
    }),
    Review.fromJson({
      'review_id': 5,
      'profile_image': '',
      'reviewer_name': 'River',
      'created_at': '2days ago',
      'contents':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, s...'
    }),
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
