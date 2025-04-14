import 'package:flutter/material.dart';
import 'package:lugeasy/common/constants.dart';

class HostReviewTile extends StatelessWidget {
  final Map<String, String> review;

  const HostReviewTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final hasImage =
        review['profile_image'] != null && review['profile_image']!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 이미지
          hasImage
              ? CircleAvatar(
                  backgroundImage: NetworkImage(review['profile_image']!),
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
                  review['reviewer_name'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  review['created_at'] ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  review['contents'] ?? '',
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
