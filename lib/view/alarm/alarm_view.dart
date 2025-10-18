import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lugeasy/core/constants.dart';
import 'package:lugeasy/widgets/button.dart';

class AlarmView extends ConsumerStatefulWidget {
  const AlarmView({super.key});

  @override
  ConsumerState<AlarmView> createState() => _AlarmViewState();
}

class _AlarmViewState extends ConsumerState<AlarmView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Button(
                        onTap: () {},
                        child: Image.asset("assets/icon_back.png",
                            width: Constants.iconSize,
                            height: Constants.iconSize,
                            fit: BoxFit.fill)),
                    Text("Notification"),
                    SizedBox(width: 24.w)
                  ],
                ),
                SizedBox(
                  height: 44.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Today"),
                    Button(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                              color: Color(0xFFF3F1F1),
                              borderRadius: BorderRadius.circular(100.r)),
                          child: Text("Delete all"),
                        ),
                        onTap: () {})
                  ],
                )
              ],
            )));
  }
}
