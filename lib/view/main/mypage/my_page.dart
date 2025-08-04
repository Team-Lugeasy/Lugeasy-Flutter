import 'package:flutter/material.dart';
import 'package:lugeasy/common/extensions/context_extension.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(context.l10n.mypage));
  }
}
