import 'package:flutter/material.dart';
import 'package:lugeasy/services/model/host.dart';
import 'listitem/host_list_tile.dart';

class HostListSheet extends StatelessWidget {
  // 호스트 클릭 시 호출되는 콜백
  final void Function(Host) onHostTap;

  HostListSheet({super.key, required this.onHostTap});

  // 임시로 하드코딩된 호스트 목록 (향후 API로 대체 예정)
  final List<Host> hosts = [
    Host.fromJson({
      'name': 'Taerin Kim',
      'profile_image': '',
      'review_rate': 4.9,
      'review_count': 119,
      'address': '24 Saleh Al-Mahmoud Street, Yanbu',
      'description': 'Reliable host near the station',
      'latitude': 37.5642135,
      'longitude': 127.0016985
    }),
    Host.fromJson({
      'name': 'Liver Lee',
      'profile_image': '',
      'review_rate': 4.8,
      'review_count': 82,
      'address': '50 Namsan-gil, Seoul',
      'description': 'Clean and safe luggage service',
      'latitude': 37.57,
      'longitude': 127.001
    }),
    Host.fromJson({
      'name': 'Jisu Yoo',
      'profile_image': '',
      'review_rate': 5.0,
      'review_count': 65,
      'address': '12-3 Gangnam-daero, Seoul',
      'description': 'Kind host in center of Seoul',
      'latitude': 37.575,
      'longitude': 127.0008
    })
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // 전체 리스트 패딩 설정 (상단 0, 좌우 16, 하단 30)
      padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 30),
      itemCount: hosts.length,
      // 각 아이템 사이에 구분선 삽입
      separatorBuilder: (_, __) => const Divider(height: 0.5),
      itemBuilder: (context, index) {
        final host = hosts[index];
        return HostListTile(
          host: host,
          onTap: () => onHostTap(host), // 선택 시 콜백 실행
        );
      },
    );
  }
}
