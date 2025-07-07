import 'package:flutter/material.dart';
import 'package:lugeasy/common/constants.dart';
import 'package:lugeasy/services/model/host.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                          '${AppLocalizations.of(context)!.review}  ${host.reviewCount}',
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
