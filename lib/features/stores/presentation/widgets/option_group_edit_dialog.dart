import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';

class OptionGroupEditDialog extends StatefulWidget {
  final String initialName;
  final String initialDescription;
  final int initialMaxSelection;
  final Function(String name, String description, int maxSelection) onEdit;
  
  const OptionGroupEditDialog({
    super.key,
    required this.initialName,
    required this.initialDescription,
    required this.initialMaxSelection,
    required this.onEdit,
  });

  @override
  State<OptionGroupEditDialog> createState() => _OptionGroupEditDialogState();
}

class _OptionGroupEditDialogState extends State<OptionGroupEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late int _maxSelection;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _descriptionController.text = widget.initialDescription;
    _maxSelection = widget.initialMaxSelection;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            MdiIcons.pencil,
            color: AppColors.primary,
            size: AppSizes.iconMd,
          ),
          SizedBox(width: AppSizes.sm),
          Text(
            '옵션 그룹 수정',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 500.w,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 옵션 그룹명
              Text(
                '옵션 그룹명 *',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: '옵션 그룹명을 입력해주세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '옵션 그룹명을 입력해주세요';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: AppSizes.md),
              
              // 옵션 그룹 설명
              Text(
                '설명',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '옵션 그룹에 대한 설명을 입력해주세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  ),
                ),
              ),
              
              SizedBox(height: AppSizes.md),
              
              // 최대 선택 개수
              Text(
                '최대 선택 개수 *',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
              DropdownButtonFormField<int>(
                value: _maxSelection,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  ),
                ),
                items: List.generate(10, (index) => index + 1).map((number) {
                  return DropdownMenuItem<int>(
                    value: number,
                    child: Text('$number개'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _maxSelection = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return '최대 선택 개수를 선택해주세요';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('취소'),
        ),
        ElevatedButton(
          onPressed: _editGroup,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
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
        _maxSelection,
      );
      Navigator.of(context).pop();
    }
  }
}
