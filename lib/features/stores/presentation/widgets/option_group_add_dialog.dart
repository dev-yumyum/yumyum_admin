import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';

class OptionGroupAddDialog extends StatefulWidget {
  final Function(String name, String description, bool isRequired, int minSelection, int maxSelection) onAdd;
  
  const OptionGroupAddDialog({super.key, required this.onAdd});

  @override
  State<OptionGroupAddDialog> createState() => _OptionGroupAddDialogState();
}

class _OptionGroupAddDialogState extends State<OptionGroupAddDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // 옵션 타입 (필수/선택)
  bool _isRequired = true; // true: 필수옵션, false: 선택옵션
  
  // 선택 개수 설정
  int _minSelection = 1;
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
              
              // 옵션 타입 선택 (필수/선택)
              Text(
                '옵션 타입 *',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.sm),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text(
                        '필수 옵션',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      value: true,
                      groupValue: _isRequired,
                      onChanged: (bool? value) {
                        setState(() {
                          _isRequired = value!;
                          // 필수옵션으로 변경 시 최소값을 1로 설정
                          if (_isRequired && _minSelection < 1) {
                            _minSelection = 1;
                          }
                        });
                      },
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text(
                        '선택 옵션',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      value: false,
                      groupValue: _isRequired,
                      onChanged: (bool? value) {
                        setState(() {
                          _isRequired = value!;
                          // 선택옵션으로 변경 시 최소값을 0으로 설정
                          if (!_isRequired) {
                            _minSelection = 0;
                          }
                        });
                      },
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: AppSizes.md),
              
              // 선택 개수 설정
              Text(
                '선택 개수 설정 *',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.sm),
              
              if (_isRequired) ...[
                // 필수 옵션일 때 - 최소/최대 선택 개수
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '최소 선택',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: AppSizes.xs),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownButton<int>(
                              value: _minSelection,
                              isExpanded: true,
                              underline: Container(),
                              items: List.generate(15, (index) => index + 1).map((count) {
                                return DropdownMenuItem(
                                  value: count,
                                  child: Text('${count}개', style: TextStyle(fontSize: 16.sp)),
                                );
                              }).toList(),
                              onChanged: (int? value) {
                                if (value != null) {
                                  setState(() {
                                    _minSelection = value;
                                    // 최소값이 최대값보다 큰 경우 최대값을 조정
                                    if (_minSelection > _maxSelection) {
                                      _maxSelection = _minSelection;
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '최대 선택',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: AppSizes.xs),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownButton<int>(
                              value: _maxSelection,
                              isExpanded: true,
                              underline: Container(),
                              items: List.generate(15, (index) => index + 1).map((count) {
                                return DropdownMenuItem(
                                  value: count,
                                  child: Text('${count}개', style: TextStyle(fontSize: 16.sp)),
                                );
                              }).toList(),
                              onChanged: (int? value) {
                                if (value != null) {
                                  setState(() {
                                    _maxSelection = value;
                                    // 최대값이 최소값보다 작은 경우 최소값을 조정
                                    if (_maxSelection < _minSelection) {
                                      _minSelection = _maxSelection;
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.sm),
                Text(
                  '고객이 이 옵션 그룹에서 최소 ${_minSelection}개부터 최대 ${_maxSelection}개까지 선택해야 합니다.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textTertiary,
                  ),
                ),
              ] else ...[
                // 선택 옵션일 때 - 최대 선택 개수만
                Row(
                  children: [
                    Text(
                      '최대 선택:',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: AppSizes.md),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButton<int>(
                        value: _maxSelection,
                        underline: Container(),
                        items: List.generate(15, (index) => index + 1).map((count) {
                          return DropdownMenuItem(
                            value: count,
                            child: Text('${count}개', style: TextStyle(fontSize: 16.sp)),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          if (value != null) {
                            setState(() {
                              _maxSelection = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.sm),
                Text(
                  '고객이 이 옵션 그룹에서 최대 ${_maxSelection}개까지 선택할 수 있습니다. (선택하지 않을 수도 있음)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
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
        _isRequired,
        _minSelection,
        _maxSelection,
      );
      Navigator.of(context).pop();
    }
  }
}

