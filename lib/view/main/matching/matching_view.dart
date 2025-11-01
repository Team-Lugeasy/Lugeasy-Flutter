import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lugeasy/core/util/color_style.dart';
import 'package:lugeasy/core/util/text_style.dart';
import 'package:lugeasy/view/main/matching/matching_view_model.dart';
import 'package:lugeasy/view/popup/custom_toast.dart';
import 'package:lugeasy/widgets/button.dart';

class MatchingView extends ConsumerStatefulWidget {
  const MatchingView({super.key});

  @override
  ConsumerState<MatchingView> createState() => _MatchingViewState();
}

class _MatchingViewState extends ConsumerState<MatchingView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(matchingViewModelProvider.notifier).getMatchList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(matchingViewModelProvider);
    final viewModel = ref.read(matchingViewModelProvider.notifier);

    ref.listen<MatchingViewState>(matchingViewModelProvider, (previous, next) {
      if (next is MatchingViewFailure) {
        CustomToast.showError(context, next.message.toString());
      }
    });

    return Scaffold(
      body: switch (state) {
        MatchingInitial() => Center(
            child: CircularProgressIndicator(),
          ),
        MatchingViewLoading() => Center(
            child: CircularProgressIndicator(),
          ),
        MatchingViewDataLoaded(:final data) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 105.h,
                ),
                _buildSection("예약 완료", data.requestedMatches),
                SizedBox(height: 30.h),
                _buildSection("예약 요청", data.acceptedMatches),
                SizedBox(height: 30.h),
                _buildSection("지난 예약", data.completeMatches),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        MatchingViewFailure() => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('데이터를 불러오지 못했습니다.'),
                SizedBox(height: 16.h),
                Button(
                  onTap: () => viewModel.getMatchList(),
                  child: Text('다시 시도'),
                ),
              ],
            ),
          ),
        _ => Center(child: Text('알 수 없는 상태')),
      },
    );
  }

  Widget _buildSection(String title, List<MatchItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: LugeasyTextStyles.title2
                .copyWith(color: LugeasyColorStyles.blue900)),
        SizedBox(height: 22.h),
        if (items.isEmpty)
          Text('매칭 내역이 없습니다.',
              style: LugeasyTextStyles.body3
                  .copyWith(color: LugeasyColorStyles.gray300))
        else
          ...items.map((item) => _buildMatchItem(item)),
      ],
    );
  }

  Widget _buildMatchItem(MatchItem item) {
    return Container(
        width: 372.w,
        height: 110.h,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.h)),
          color: LugeasyColorStyles.white,
        ),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35.w,
              backgroundImage: item.profileImg.isNotEmpty
                  ? NetworkImage(item.profileImg)
                  : null,
            ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              children: [
                Text("${item.name}님과",
                    style: LugeasyTextStyles.body2
                        .copyWith(color: LugeasyColorStyles.gray500)),
                SizedBox(height: 4.h),
                Text(item.state.toString(),
                    style: LugeasyTextStyles.body2
                        .copyWith(color: LugeasyColorStyles.gray500)),
              ],
            )
          ],
        ));
  }
}
