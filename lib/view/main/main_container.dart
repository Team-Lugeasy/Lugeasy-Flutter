import 'package:flutter/material.dart';
import 'package:lugeasy/common/value_listenable_builder2.dart';
import 'package:lugeasy/view/main/map/bottomsheet/host_bottom_sheet.dart';
import 'package:lugeasy/view/main/map/bottomsheet/hostdetailsheet/bottom_action_bar.dart';
import 'package:lugeasy/view/main/map/map_page.dart';
import 'package:lugeasy/view/main/matching/matching_page.dart';
import 'package:lugeasy/view/main/mypage/my_page.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  _MainContainerState createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;
  final ValueNotifier<bool> _mapDetailVisible = ValueNotifier(false);

  @override
  void dispose() {
    _mapDetailVisible.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      MatchingPage(),
      MapPage(isDetailVisible: _mapDetailVisible),
      MyPage(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMap = _selectedIndex == 1;

    return Stack(
      children: [
        Scaffold(
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Matching'),
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Mypage'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
        ValueListenableBuilder2<bool, double>(
          first: _mapDetailVisible,
          second: HostBottomSheetState.sheetHeightRatio,
          builder: (context, isDetail, ratio, _) {
            final shouldShow = isMap && isDetail && ratio > 0.1;

            return shouldShow
                ? const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: BottomActionBar(),
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
