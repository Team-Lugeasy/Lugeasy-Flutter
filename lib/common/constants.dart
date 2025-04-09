import 'package:flutter/material.dart';

CircleAvatar defaultProfileIcon({double iconSize = 52}) {
  return CircleAvatar(
    backgroundColor: const Color(0xFFDBDBDB),
    radius: iconSize,
    child: Icon(
      Icons.person,
      size: iconSize,
      color: const Color(0xFFC5C5C5),
    ),
  );
}
