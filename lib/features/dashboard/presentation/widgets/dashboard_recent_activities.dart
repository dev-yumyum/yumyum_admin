import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';

class DashboardRecentActivities extends StatelessWidget {
  const DashboardRecentActivities({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = _getSampleActivities();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '최근 활동',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: 전체 활동 보기
                  },
                  child: Text(
                    '전체 보기',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => SizedBox(height: AppSizes.sm),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _buildActivityItem(activity);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(_ActivityItem activity) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: activity.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          child: Icon(
            activity.icon,
            size: AppSizes.iconMd,
            color: activity.color,
          ),
        ),
        SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
              Text(
                activity.description,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          activity.time,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  List<_ActivityItem> _getSampleActivities() {
    return [
      _ActivityItem(
        icon: MdiIcons.domain,
        title: '새 사업자 등록',
        description: '㈜맛있는집이 신규 등록되었습니다.',
        time: '2분 전',
        color: AppColors.primary,
      ),
      _ActivityItem(
        icon: MdiIcons.checkCircle,
        title: '사업자 승인 완료',
        description: '치킨왕 프랜차이즈 승인이 완료되었습니다.',
        time: '15분 전',
        color: AppColors.success,
      ),
      _ActivityItem(
        icon: MdiIcons.storefront,
        title: '새 매장 등록',
        description: '피자마을 신촌점이 등록되었습니다.',
        time: '1시간 전',
        color: AppColors.info,
      ),
      _ActivityItem(
        icon: MdiIcons.clockAlert,
        title: '승인 대기',
        description: '버거킹 강남점 승인 검토가 필요합니다.',
        time: '2시간 전',
        color: AppColors.warning,
      ),
      _ActivityItem(
        icon: MdiIcons.accountPlus,
        title: '신규 회원 가입',
        description: '15명의 새로운 회원이 가입했습니다.',
        time: '3시간 전',
        color: AppColors.secondary,
      ),
    ];
  }
}

class _ActivityItem {
  final IconData icon;
  final String title;
  final String description;
  final String time;
  final Color color;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    required this.color,
  });
}
