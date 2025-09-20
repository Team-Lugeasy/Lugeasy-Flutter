import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 기본 이미지 생성 전 임시 사용할 아이콘 추가
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

// Map - 바텀 시트 비율 설정
const double kBottomSheetMinRatio = 0.05; // 최소
const double kBottomSheetMaxRatio = 0.84; // 최대
const double kBottomSheetListRatio = 0.3; // 리스트 보기
const double kBottomSheetDetailRatio = 0.5; // 상세 보기

class Constants {
  static final double horizontalPadding = 20.w;
  static final double iconSize = 24.w;
}
