import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';

class OptionItemAddDialog extends StatefulWidget {
  final String groupName;
  final Function(String name, int price) onAdd;
  
  const OptionItemAddDialog({
    super.key, 
    required this.groupName,
    required this.onAdd,
  });

  @override
  State<OptionItemAddDialog> createState() => _OptionItemAddDialogState();
}

class _OptionItemAddDialogState extends State<OptionItemAddDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            MdiIcons.plus,
            color: AppColors.secondary,
            size: AppSizes.iconMd,
          ),
          SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '옵션 아이템 추가',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                Text(
                  '${widget.groupName} 그룹에 추가',
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
      content: SizedBox(
        width: 450.w,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 옵션 아이템명
              Text(
                '옵션 아이템명 *',
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
                  hintText: '옵션 아이템명을 입력해주세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '옵션 아이템명을 입력해주세요';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: AppSizes.md),
              
              // 추가 가격
              Text(
                '추가 가격 *',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '추가 가격을 입력해주세요 (0원 가능)',
                  suffixText: '원',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '추가 가격을 입력해주세요';
                  }
                  final price = int.tryParse(value.trim());
                  if (price == null || price < 0) {
                    return '0원 이상의 올바른 가격을 입력해주세요';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: AppSizes.sm),
              Container(
                padding: EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.informationOutline,
                      color: AppColors.info,
                      size: AppSizes.iconSm,
                    ),
                    SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Text(
                        '추가 가격은 기본 메뉴 가격에 더해지는 금액입니다.\n무료 옵션인 경우 0원으로 입력하세요.',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
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
          onPressed: _addOptionItem,
          icon: Icon(MdiIcons.plus, size: AppSizes.iconSm),
          label: Text(
            '추가',
            style: TextStyle(fontSize: 18.sp),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
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

  void _addOptionItem() {
    if (_formKey.currentState!.validate()) {
      final price = int.parse(_priceController.text.trim());
      widget.onAdd(
        _nameController.text.trim(),
        price,
      );
      Navigator.of(context).pop();
    }
  }
}
