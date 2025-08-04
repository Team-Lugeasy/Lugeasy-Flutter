import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lugeasy/common/value_listenable_builder2.dart';
import 'package:lugeasy/provider/host_provider.dart';
import 'package:lugeasy/view/main/map/bottomsheet/host_bottom_sheet.dart';
import 'package:lugeasy/view/main/map/bottomsheet/hostdetailsheet/reservation/reservation_button.dart';
import 'package:lugeasy/view/main/map/map_page.dart';
import 'package:lugeasy/view/main/matching/matching_page.dart';
import 'package:lugeasy/view/main/mypage/my_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainContainer extends ConsumerStatefulWidget {
  const MainContainer({super.key});

  @override
  ConsumerState<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends ConsumerState<MainContainer> {
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
    final selectedHost = ref.watch(hostNotifierProvider);

    return Stack(
      children: [
        Scaffold(
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.red, // 선택된 아이템 색상
            unselectedItemColor: Colors.black, // 선택 안 된 아이템 색상
            selectedLabelStyle: TextStyle(color: Colors.red),
            unselectedLabelStyle: TextStyle(color: Colors.black),
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _selectedIndex == 0
                      ? 'assets/icon_luggage_on.svg'
                      : 'assets/icon_luggage_off.svg',
                ),
                label: AppLocalizations.of(context)!.matching,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _selectedIndex == 1
                      ? 'assets/icon_map_on.svg'
                      : 'assets/icon_map_off.svg',
                ),
                label: AppLocalizations.of(context)!.map,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _selectedIndex == 2
                      ? 'assets/icon_profile_on.svg'
                      : 'assets/icon_profile_off.svg',
                ),
                label: AppLocalizations.of(context)!.mypage,
              ),
            ],
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
                    child: ReservationBottomBar(host: selectedHost!),
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
