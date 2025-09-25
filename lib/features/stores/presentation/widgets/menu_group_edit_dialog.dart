import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';

class MenuGroupEditDialog extends StatefulWidget {
  final String initialName;
  final String initialDescription;
  final Function(String name, String description) onEdit;
  
  const MenuGroupEditDialog({
    super.key,
    required this.initialName,
    required this.initialDescription,
    required this.onEdit,
  });

  @override
  State<MenuGroupEditDialog> createState() => _MenuGroupEditDialogState();
}

class _MenuGroupEditDialogState extends State<MenuGroupEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _descriptionController.text = widget.initialDescription;
  }

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
          MdiIcons.pencil,
          size: AppSizes.iconMd,
          color: AppColors.primary,
        ),
        SizedBox(width: AppSizes.sm),
        Text(
          '메뉴 그룹 수정',
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
                maxLength: 200,
                decoration: InputDecoration(
                  hintText: '메뉴 그룹에 대한 설명을 입력해주세요 (최대 200자)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 60.h),
                    child: Icon(MdiIcons.textBox, color: AppColors.primary),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.length > 200) {
                    return '설명은 200자 이내로 입력해주세요';
                  }
                  return null;
                },
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
          onPressed: _editGroup,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: AppSizes.sm,
            ),
          ),
          child: Text('수정'),
        ),
      ],
    );
  }

  void _editGroup() {
    if (_formKey.currentState!.validate()) {
      widget.onEdit(
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
