import 'package:flutter/material.dart';
import 'package:lugeasy/data/models/review.dart';
import 'package:lugeasy/core/constants.dart';

class HostReviewTile extends StatelessWidget {
  final Review review;

  const HostReviewTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final hasImage = review.profileImage.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 이미지
          hasImage
              ? CircleAvatar(
                  backgroundImage: NetworkImage(review.profileImage),
                  radius: 24,
                )
              : defaultProfileIcon(iconSize: 24),
          const SizedBox(width: 12),

          // 텍스트 영역
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.reviewerName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  review.createdAt,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  review.contents,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
