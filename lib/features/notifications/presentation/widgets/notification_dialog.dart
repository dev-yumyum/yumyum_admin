import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../data/models/notification_model.dart';

class NotificationDialog extends StatefulWidget {
  final NotificationModel? notification;
  final Function(NotificationModel) onSave;

  const NotificationDialog({
    super.key,
    this.notification,
    required this.onSave,
  });

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _linkUrlController;
  
  late String _selectedType;
  late String _selectedDeliveryMethod;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.notification?.title ?? '');
    _contentController = TextEditingController(text: widget.notification?.content ?? '');
    _linkUrlController = TextEditingController(text: widget.notification?.linkUrl ?? '');
    
    _selectedType = widget.notification?.type ?? NotificationType.signup;
    _selectedDeliveryMethod = widget.notification?.deliveryMethod ?? DeliveryMethod.appPopup;
    _isActive = widget.notification?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _linkUrlController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final notification = NotificationModel(
        id: widget.notification?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        type: _selectedType,
        deliveryMethod: _selectedDeliveryMethod,
        isActive: _isActive,
        createdAt: widget.notification?.createdAt ?? DateTime.now(),
        updatedAt: widget.notification != null ? DateTime.now() : null,
        linkUrl: _linkUrlController.text.trim().isNotEmpty 
            ? _linkUrlController.text.trim() 
            : null,
      );
      
      widget.onSave(notification);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.notification == null ? '안내메시지 추가' : '안내메시지 수정',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 600.w,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: '제목',
                    hintText: '예: 회원가입 환영 메시지',
                    prefixIcon: Icon(MdiIcons.formatTitle),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '제목을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.md),
                
                // 내용
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: '내용',
                    hintText: '안내메시지 내용을 입력하세요',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(MdiIcons.textBox),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '내용을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.md),
                
                // 유형
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    labelText: '유형',
                    prefixIcon: Icon(MdiIcons.shape),
                  ),
                  items: NotificationType.all.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(NotificationType.getLabel(type)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '유형을 선택해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.md),
                
                // 발송 방법
                DropdownButtonFormField<String>(
                  value: _selectedDeliveryMethod,
                  decoration: InputDecoration(
                    labelText: '발송 방법',
                    prefixIcon: Icon(MdiIcons.send),
                    helperText: '앱 팝업, 카카오톡 알림, 또는 둘 다 선택',
                  ),
                  items: DeliveryMethod.all.map((method) {
                    return DropdownMenuItem(
                      value: method,
                      child: Text(DeliveryMethod.getLabel(method)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedDeliveryMethod = value;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '발송 방법을 선택해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.md),
                
                // 링크 URL (선택사항)
                TextFormField(
                  controller: _linkUrlController,
                  decoration: InputDecoration(
                    labelText: '링크 URL (선택사항)',
                    hintText: '예: https://example.com/promo',
                    prefixIcon: Icon(MdiIcons.link),
                    helperText: '메시지 클릭 시 이동할 URL',
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final urlPattern = RegExp(
                        r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
                      );
                      if (!urlPattern.hasMatch(value)) {
                        return '올바른 URL 형식이 아닙니다.';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.md),
                
                // 활성 상태
                SwitchListTile(
                  title: const Text('활성 상태'),
                  subtitle: Text(
                    _isActive ? '이 메시지가 자동으로 발송됩니다.' : '이 메시지는 발송되지 않습니다.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: _isActive ? AppColors.success : Colors.grey,
                    ),
                  ),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                  activeColor: AppColors.success,
                  contentPadding: EdgeInsets.zero,
                ),
                
                SizedBox(height: AppSizes.sm),
                
                // 안내 메시지
                Container(
                  padding: EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.informationOutline,
                        size: 20.sp,
                        color: Colors.blue[700],
                      ),
                      SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Text(
                          '유형에 맞는 이벤트 발생 시 자동으로 메시지가 발송됩니다.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.blue[900],
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
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('저장'),
        ),
      ],
    );
  }
}

