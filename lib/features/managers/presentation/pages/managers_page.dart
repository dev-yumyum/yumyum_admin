import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/crm_layout.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/admin_model.dart';

class ManagersPage extends StatefulWidget {
  const ManagersPage({super.key});

  @override
  State<ManagersPage> createState() => _ManagersPageState();
}

class _ManagersPageState extends State<ManagersPage> {
  List<AdminModel> _admins = [];
  AdminModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadAdmins();
  }

  void _loadCurrentUser() {
    _currentUser = AdminModel(
      id: 'current_user',
      adminId: 'admin001',
      name: '김관리자',
      email: 'admin@yumyum.com',
      phone: '010-1234-5678',
      department: '운영팀',
      position: '팀장',
      role: 'SUPER_ADMIN',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      status: 'ACTIVE',
    );
  }

  void _loadAdmins() {
    setState(() {
      _admins = [
        AdminModel(
          id: '1',
          adminId: 'admin002',
          name: '이영수',
          email: 'youngsoo.lee@yumyum.com',
          phone: '010-2345-6789',
          department: '개발팀',
          position: '시니어 개발자',
          role: 'ADMIN',
          createdAt: DateTime.now().subtract(const Duration(days: 200)),
          status: 'ACTIVE',
        ),
        AdminModel(
          id: '2',
          adminId: 'manager001',
          name: '박민정',
          email: 'minjung.park@yumyum.com',
          phone: '010-3456-7890',
          department: 'CS팀',
          position: '매니저',
          role: 'MANAGER',
          createdAt: DateTime.now().subtract(const Duration(days: 150)),
          status: 'ACTIVE',
        ),
        AdminModel(
          id: '3',
          adminId: 'staff001',
          name: '최지혜',
          email: 'jihye.choi@yumyum.com',
          phone: '010-4567-8901',
          department: '마케팅팀',
          position: '주임',
          role: 'STAFF',
          createdAt: DateTime.now().subtract(const Duration(days: 90)),
          status: 'ACTIVE',
        ),
        AdminModel(
          id: '4',
          adminId: 'admin003',
          name: '정현우',
          email: 'hyunwoo.jung@yumyum.com',
          phone: '010-5678-9012',
          department: '운영팀',
          position: '대리',
          role: 'ADMIN',
          createdAt: DateTime.now().subtract(const Duration(days: 300)),
          status: 'INACTIVE',
        ),
        AdminModel(
          id: '5',
          adminId: 'manager002',
          name: '송미영',
          email: 'miyoung.song@yumyum.com',
          phone: '010-6789-0123',
          department: 'CS팀',
          position: '팀장',
          role: 'MANAGER',
          createdAt: DateTime.now().subtract(const Duration(days: 180)),
          status: 'ACTIVE',
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.manager,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSizes.lg),
            _buildCurrentUserProfile(),
            SizedBox(height: AppSizes.lg),
            Expanded(child: _buildAdminTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '관리자 관리',
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _showAdminDialog(),
          icon: Icon(MdiIcons.accountPlus),
          label: Text('관리자 추가'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentUserProfile() {
    if (_currentUser == null) return const SizedBox.shrink();

    return Card(
      color: AppColors.primary.withOpacity(0.05),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(MdiIcons.accountCircle, size: 32.r, color: AppColors.primary),
                SizedBox(width: AppSizes.sm),
                Text(
                  '현재 로그인한 계정',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(child: _buildInfoCard('이름', _currentUser!.name)),
                SizedBox(width: AppSizes.md),
                Expanded(child: _buildInfoCard('부서', _currentUser!.department)),
                SizedBox(width: AppSizes.md),
                Expanded(child: _buildInfoCard('직책', _currentUser!.position)),
                SizedBox(width: AppSizes.md),
                Expanded(child: _buildInfoCard('권한', _currentUser!.displayRole)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSizes.xs),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.md),
          child: Text(
            '구성원 목록 (${_admins.length}명)',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.sm),
            itemCount: _admins.length,
            itemBuilder: (context, index) {
              return _buildAdminCard(_admins[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdminCard(AdminModel admin) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.md),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('${RouteNames.managerDetail}?id=${admin.id}'),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        MdiIcons.account,
                        size: 22.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                admin.name,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(width: AppSizes.sm),
                              _buildRoleChip(admin.role),
                              SizedBox(width: AppSizes.xs),
                              _buildStatusChip(admin.status),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            admin.adminId,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _showAdminDialog(admin: admin),
                          icon: Icon(MdiIcons.pencil, size: 20.sp),
                          color: AppColors.textSecondary,
                        ),
                        IconButton(
                          onPressed: () => _deleteAdmin(admin),
                          icon: Icon(MdiIcons.delete, size: 20.sp),
                          color: AppColors.error,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.md),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoRow(
                            MdiIcons.domain,
                            '부서',
                            admin.department,
                          ),
                        ),
                        SizedBox(width: AppSizes.lg),
                        Expanded(
                          child: _buildInfoRow(
                            MdiIcons.badgeAccount,
                            '직책',
                            admin.position,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.sm),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoRow(
                            MdiIcons.email,
                            '이메일',
                            admin.email,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppColors.textSecondary,
        ),
        SizedBox(width: AppSizes.xs),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleChip(String role) {
    Color chipColor;
    String displayText;
    
    switch (role) {
      case 'SUPER_ADMIN':
        chipColor = AppColors.error;
        displayText = '최고관리자';
        break;
      case 'ADMIN':
        chipColor = AppColors.primary;
        displayText = '관리자';
        break;
      case 'MANAGER':
        chipColor = AppColors.info;
        displayText = '매니저';
        break;
      case 'STAFF':
        chipColor = AppColors.warning;
        displayText = '직원';
        break;
      default:
        chipColor = AppColors.inactive;
        displayText = role;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String displayText;
    
    switch (status) {
      case 'ACTIVE':
        chipColor = AppColors.success;
        displayText = '활성';
        break;
      case 'INACTIVE':
        chipColor = AppColors.warning;
        displayText = '비활성';
        break;
      case 'SUSPENDED':
        chipColor = AppColors.error;
        displayText = '정지';
        break;
      default:
        chipColor = AppColors.inactive;
        displayText = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }

  void _showAdminDialog({AdminModel? admin}) {
    final isEdit = admin != null;
    final nameController = TextEditingController(text: admin?.name ?? '');
    final adminIdController = TextEditingController(text: admin?.adminId ?? '');
    final emailController = TextEditingController(text: admin?.email ?? '');
    final phoneController = TextEditingController(text: admin?.phone ?? '');
    final departmentController = TextEditingController(text: admin?.department ?? '');
    final positionController = TextEditingController(text: admin?.position ?? '');
    
    String selectedRole = admin?.role ?? 'STAFF';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 500.w,
          padding: EdgeInsets.all(AppSizes.lg),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEdit ? '관리자 수정' : '관리자 추가',
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: AppSizes.md),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: '이름',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: AppSizes.sm),
                TextFormField(
                  controller: adminIdController,
                  decoration: InputDecoration(
                    labelText: '관리자 ID',
                    border: OutlineInputBorder(),
                  ),
                  enabled: !isEdit,
                ),
                SizedBox(height: AppSizes.sm),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: '이메일',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: AppSizes.sm),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: '연락처',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: AppSizes.sm),
                TextFormField(
                  controller: departmentController,
                  decoration: InputDecoration(
                    labelText: '부서',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: AppSizes.sm),
                TextFormField(
                  controller: positionController,
                  decoration: InputDecoration(
                    labelText: '직책',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: AppSizes.sm),
                StatefulBuilder(
                  builder: (context, setDialogState) {
                    return DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: InputDecoration(
                        labelText: '권한',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'SUPER_ADMIN', child: Text('최고관리자')),
                        DropdownMenuItem(value: 'ADMIN', child: Text('관리자')),
                        DropdownMenuItem(value: 'MANAGER', child: Text('매니저')),
                        DropdownMenuItem(value: 'STAFF', child: Text('직원')),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedRole = value!;
                        });
                      },
                    );
                  },
                ),
                SizedBox(height: AppSizes.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('취소'),
                    ),
                    SizedBox(width: AppSizes.sm),
                    ElevatedButton(
                      onPressed: () {
                        final newAdmin = AdminModel(
                          id: admin?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                          adminId: adminIdController.text,
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          department: departmentController.text,
                          position: positionController.text,
                          role: selectedRole,
                          createdAt: admin?.createdAt ?? DateTime.now(),
                          status: 'ACTIVE',
                        );

                        if (isEdit) {
                          _updateAdmin(newAdmin);
                        } else {
                          _addAdmin(newAdmin);
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(isEdit ? '수정' : '추가'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addAdmin(AdminModel admin) {
    setState(() {
      _admins.add(admin);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${admin.name} 관리자가 추가되었습니다.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _updateAdmin(AdminModel admin) {
    setState(() {
      final index = _admins.indexWhere((a) => a.id == admin.id);
      if (index != -1) {
        _admins[index] = admin;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${admin.name} 관리자 정보가 수정되었습니다.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _deleteAdmin(AdminModel admin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('관리자 삭제'),
        content: Text('${admin.name}(${admin.adminId}) 관리자를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _admins.removeWhere((a) => a.id == admin.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${admin.name} 관리자가 삭제되었습니다.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('삭제', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
