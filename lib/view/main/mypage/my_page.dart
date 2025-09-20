import 'package:flutter/material.dart';
import 'package:lugeasy/core/extensions/context_extension.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(context.l10n.mypage));
  }
}
