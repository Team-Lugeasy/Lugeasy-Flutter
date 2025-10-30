import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lugeasy/core/util/color_style.dart';
import 'package:lugeasy/core/value_listenable_builder2.dart';
import 'package:lugeasy/providers/host/host_selection_provider.dart';
import 'package:lugeasy/view/main/map/host_bottom_sheet.dart';
import 'package:lugeasy/view/main/map/components/reservation_button.dart';
import 'package:lugeasy/view/main/map/map_view.dart';
import 'package:lugeasy/view/main/matching/matching_view.dart';
import 'package:lugeasy/view/main/mypage/my_page_view.dart';

class MainContainerView extends ConsumerStatefulWidget {
  const MainContainerView({super.key});

  @override
  ConsumerState<MainContainerView> createState() => _MainContainerState();
}

class _MainContainerState extends ConsumerState<MainContainerView> {
  int _selectedIndex = 1;
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
      MatchingView(),
      MapView(isDetailVisible: _mapDetailVisible),
      MyPageView(),
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
    final selectedHost = ref.watch(hostNotifierProvider);

    return Stack(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Scaffold(
            body: _pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: _onItemTapped,
              selectedItemColor: LugeasyColorStyles.blue500,
              unselectedItemColor: LugeasyColorStyles.lightGray600,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              elevation: 0,
              enableFeedback: false,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    _selectedIndex == 0
                        ? 'assets/icon/icon_luggage_on.png'
                        : 'assets/icon/icon_luggage_off.png',
                    width: 42.w,
                    height: 42.h,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    _selectedIndex == 1
                        ? 'assets/icon/icon_map_on.png'
                        : 'assets/icon/icon_map_off.png',
                    width: 42.w,
                    height: 42.h,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    _selectedIndex == 2
                        ? 'assets/icon/icon_profile_off.png'
                        : 'assets/icon/icon_profile_off.png',
                    width: 42.w,
                    height: 42.h,
                  ),
                  label: '',
                ),
              ],
            ),
          ),
        ),
        ValueListenableBuilder2<bool, double>(
          first: _mapDetailVisible,
          second: HostBottomSheetState.sheetHeightRatio,
          builder: (context, isDetail, ratio, _) {
            final shouldShow =
                isMap && isDetail && ratio > 0.1 && selectedHost != null;

            return shouldShow
                ? Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ReservationBottomBar(host: selectedHost),
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
