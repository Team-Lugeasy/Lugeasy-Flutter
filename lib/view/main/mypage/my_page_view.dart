import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lugeasy/core/constants.dart';

class MyPageView extends ConsumerStatefulWidget {
  const MyPageView({super.key});

  @override
  ConsumerState<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends ConsumerState<MyPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: 92.h,
              left: Constants.horizontalPadding,
              right: Constants.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // 프로필 섹션
              _buildProfileSection(),

              SizedBox(height: 30),

              // Register as Host 버튼
              _buildRegisterHostButton(),

              SizedBox(height: 30),

              // Account 섹션
              _buildAccountSection(),

              SizedBox(height: 30),

              // Customer support 섹션
              _buildCustomerSupportSection(),

              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        // 프로필 이미지
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            size: 30,
            color: Colors.grey[600],
          ),
        ),

        SizedBox(width: 16),

        // 프로필 정보
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '000',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  // Profile Settings 페이지로 이동
                },
                child: Row(
                  children: [
                    Text(
                      'Profile Settings',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterHostButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () {
          // Register as Host 기능 구현
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Register as Host',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          _buildMenuItem('Profile Settings', () {}),
          _buildDivider(),
          _buildMenuItem('Matching history', () {}),
          _buildDivider(),
          _buildMenuItem('Notice history', () {}),
          _buildDivider(),
          _buildMenuItem('Payments', () {}),
        ],
      ),
    );
  }

  Widget _buildCustomerSupportSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Customer support',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          _buildMenuItem('Service information', () {}, showIcon: false),
          _buildDivider(),
          _buildMenuItem('Leave feedback', () {}),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, VoidCallback onTap,
      {bool showIcon = true}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ),
            if (showIcon)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 20,
      endIndent: 20,
    );
  }
}
