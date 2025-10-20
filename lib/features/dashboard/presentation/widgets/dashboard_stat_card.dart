import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';

class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool isPositive;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.trend,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSizes.xs),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 34.sp,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    SizedBox(height: AppSizes.xs),
                    Row(
                      children: [
                        if (subtitle.isNotEmpty)
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        if (trend != null) ...[
                          SizedBox(width: 8.w),
                          Icon(
                            isPositive ? MdiIcons.trendingUp : MdiIcons.trendingDown,
                            size: 18.sp,
                            color: isPositive ? AppColors.success : AppColors.error,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            trend!,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: isPositive ? AppColors.success : AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                Icon(
                  icon,
                  size: AppSizes.iconLg,
                  color: color.withOpacity(0.7),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
