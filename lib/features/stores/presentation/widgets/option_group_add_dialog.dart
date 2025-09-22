import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';

class OptionGroupAddDialog extends StatefulWidget {
  final Function(String name, String description, int maxSelection) onAdd;
  
  const OptionGroupAddDialog({super.key, required this.onAdd});

  @override
  State<OptionGroupAddDialog> createState() => _OptionGroupAddDialogState();
}

class _OptionGroupAddDialogState extends State<OptionGroupAddDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _maxSelection = 1;

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
            MdiIcons.formatListBulleted,
            color: AppColors.primary,
            size: AppSizes.iconMd,
          ),
          SizedBox(width: AppSizes.sm),
          Text(
            '옵션 그룹 추가',
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
                '옵션 그룹 설명',
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
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _maxSelection.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: '$_maxSelection개',
                      onChanged: (value) {
                        setState(() {
                          _maxSelection = value.round();
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 80.w,
                    padding: EdgeInsets.all(AppSizes.sm),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      '$_maxSelection개',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: AppSizes.sm),
              Text(
                '고객이 이 옵션 그룹에서 최대 몇 개까지 선택할 수 있는지 설정하세요.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: AppSizes.md,
            ),
          ),
          child: Text(
            '취소',
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
        SizedBox(width: AppSizes.sm),
        ElevatedButton.icon(
          onPressed: _addOptionGroup,
          icon: Icon(MdiIcons.plus, size: AppSizes.iconSm),
          label: Text(
            '추가',
            style: TextStyle(fontSize: 18.sp),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: AppSizes.md,
            ),
          ),
        ),
      ],
    );
  }

  void _addOptionGroup() {
    if (_formKey.currentState!.validate()) {
      widget.onAdd(
        _nameController.text.trim(),
        _descriptionController.text.trim(),
        _maxSelection,
      );
      Navigator.of(context).pop();
    }
  }
}

