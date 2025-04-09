import 'package:flutter/material.dart';
import 'package:lugeasy/common/constants.dart';

class HostUserInfo extends StatelessWidget {
  final String name;
  final String profileImage;
  final String description;
  final double reviewRate;
  final int reviewCount;
  final String address;

  const HostUserInfo({
    super.key,
    required this.name,
    required this.profileImage,
    required this.description,
    required this.reviewRate,
    required this.reviewCount,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: profileImage.isEmpty
              ? defaultProfileIcon(iconSize: 52)
              : CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(profileImage),
                ),
        ),
        SizedBox(height: 50),
        Text(name, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(description, style: TextStyle(color: Colors.black)),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$reviewRate", style: TextStyle(fontWeight: FontWeight.normal)),
            SizedBox(width: 4),
            Icon(Icons.star, size: 16, color: Colors.black),
            SizedBox(width: 8),
            Container(
              width: 1,
              height: 16,
              color: const Color(0x4D000000), // 블랙 30%
            ),
            SizedBox(width: 8),
            Text("Review ($reviewCount)",
                style: TextStyle(color: Colors.black)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 16, color: Colors.black),
            SizedBox(width: 4),
            Text(address, style: TextStyle(color: Colors.black)),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
