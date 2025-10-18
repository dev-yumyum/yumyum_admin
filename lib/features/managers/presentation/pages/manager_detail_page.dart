import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../data/models/admin_model.dart';

class ManagerDetailPage extends StatefulWidget {
  final String? managerId;

  const ManagerDetailPage({super.key, this.managerId});

  @override
  State<ManagerDetailPage> createState() => _ManagerDetailPageState();
}

class _ManagerDetailPageState extends State<ManagerDetailPage> {
  AdminModel? _admin;

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  void _loadAdminData() {
    // TODO: 실제 API에서 데이터 로드
    setState(() {
      _admin = AdminModel(
        id: widget.managerId ?? '1',
        adminId: 'admin001',
        name: '김철수',
        email: 'admin@yumyum.com',
        phone: '010-1234-5678',
        role: 'MASTER',
        department: 'IT팀',
        position: '팀장',
        status: 'ACTIVE',
        createdAt: DateTime.parse('2024-01-15'),
      );
    });
  }

  void _showPasswordResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Row(
            children: [
              Icon(
                MdiIcons.lockReset,
                color: AppColors.warning,
                size: 28.sp,
              ),
              SizedBox(width: AppSizes.sm),
              Text(
                '비밀번호 초기화',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_admin?.name} 님의 비밀번호를 초기화하시겠습니까?',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.md),
              Container(
                padding: EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.warning.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          MdiIcons.informationOutline,
                          color: AppColors.warning,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '초기 비밀번호',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'yumyum11',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.sm),
              Text(
                '비밀번호는 위의 임시 비밀번호로 변경됩니다.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetPassword();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                foregroundColor: Colors.white,
              ),
              child: Text(
                '초기화',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ],
        );
      },
    );
  }

  void _resetPassword() {
    // TODO: 실제 API 호출
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_admin?.name} 님의 비밀번호가 "yumyum11"로 초기화되었습니다.',
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_admin == null) {
      return CrmLayout(
        currentRoute: RouteNames.manager,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return CrmLayout(
      currentRoute: RouteNames.manager,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                IconButton(
                  onPressed: () => context.go(RouteNames.manager),
                  icon: Icon(MdiIcons.arrowLeft),
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  '구성원 상세',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.lg),

            // 상세 정보
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(AppSizes.xl),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.15),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 기본 정보
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              MdiIcons.account,
                              size: 40.sp,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: AppSizes.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _admin!.name,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: AppSizes.xs),
                                Text(
                                  _admin!.adminId,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.xl),
                      Divider(),
                      SizedBox(height: AppSizes.xl),

                      // 상세 정보
                      _buildInfoSection('기본 정보', [
                        _buildInfoRow('이름', _admin!.name),
                        _buildInfoRow('아이디', _admin!.adminId),
                        _buildInfoRow('이메일', _admin!.email),
                        _buildInfoRow('연락처', _admin!.phone ?? '-'),
                      ]),
                      SizedBox(height: AppSizes.xl),

                      _buildInfoSection('소속 정보', [
                        _buildInfoRow('부서', _admin!.department ?? '-'),
                        _buildInfoRow('직책', _admin!.position ?? '-'),
                        _buildInfoRow('권한', _admin!.role),
                        _buildInfoRow('상태', _admin!.status),
                      ]),
                      SizedBox(height: AppSizes.xl),

                      _buildInfoSection('계정 정보', [
                        _buildInfoRow('가입일', _admin!.createdAt),
                      ]),
                      SizedBox(height: AppSizes.xl * 2),

                      // 비밀번호 초기화 버튼
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _showPasswordResetDialog,
                          icon: Icon(MdiIcons.lockReset, size: 20.sp),
                          label: Text(
                            '비밀번호 초기화',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.warning,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 40.w,
                              vertical: 16.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.lg),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    // DateTime이면 포맷팅, 아니면 String으로 변환
    final String displayValue = value is DateTime 
        ? '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}'
        : value.toString();
        
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.sm),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              border: Border.all(color: AppColors.border.withOpacity(0.3)),
            ),
            child: Text(
              displayValue,
              style: TextStyle(
                fontSize: 20.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

