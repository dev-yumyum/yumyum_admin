import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';

class MenuGroupAddDialog extends StatefulWidget {
  final Function(String name, String description) onAdd;
  
  const MenuGroupAddDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<MenuGroupAddDialog> createState() => _MenuGroupAddDialogState();
}

class _MenuGroupAddDialogState extends State<MenuGroupAddDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: Container(
        width: 500.w,
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSizes.lg),
            _buildForm(),
            SizedBox(height: AppSizes.lg),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          MdiIcons.foodForkDrink,
          size: AppSizes.iconMd,
          color: AppColors.primary,
        ),
        SizedBox(width: AppSizes.sm),
        Text(
          '메뉴 그룹 추가',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 메뉴 그룹명
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '메뉴 그룹명 *',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: '메뉴 그룹명을 입력해주세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  ),
                  prefixIcon: Icon(MdiIcons.folder, color: AppColors.primary),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '메뉴 그룹명을 입력해주세요';
                  }
                  if (value.length > 20) {
                    return '메뉴 그룹명은 20자 이내로 입력해주세요';
                  }
                  return null;
                },
              ),
            ],
          ),
          
          SizedBox(height: AppSizes.md),
          
          // 메뉴 그룹 설명
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '메뉴 그룹 설명',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                maxLength: 100,
                decoration: InputDecoration(
                  hintText: '메뉴 그룹에 대한 설명을 입력해주세요 (최대 100자)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 60.h),
                    child: Icon(MdiIcons.textBoxOutline, color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: AppSizes.sm,
            ),
          ),
          child: Text('취소'),
        ),
        SizedBox(width: AppSizes.sm),
        ElevatedButton(
          onPressed: _addGroup,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: AppSizes.sm,
            ),
          ),
          child: Text('추가'),
        ),
      ],
    );
  }

  void _addGroup() {
    if (_formKey.currentState!.validate()) {
      widget.onAdd(
        _nameController.text.trim(),
        _descriptionController.text.trim(),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
