import 'package:flutter/material.dart';

class NicknameStatusChip extends StatelessWidget {
  final String status;

  const NicknameStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(status);
    
    return Chip(
      label: Text(
        statusInfo['label']!,
        style: TextStyle(
          color: statusInfo['color'] as Color,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
      backgroundColor: (statusInfo['color'] as Color).withOpacity(0.1),
      side: BorderSide(
        color: statusInfo['color'] as Color,
        width: 1,
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo(String status) {
    switch (status) {
      case 'active':
        return {
          'label': '활성',
          'color': Colors.green,
        };
      case 'inactive':
        return {
          'label': '비활성',
          'color': Colors.orange,
        };
      case 'banned':
        return {
          'label': '차단',
          'color': Colors.red,
        };
      default:
        return {
          'label': '알 수 없음',
          'color': Colors.grey,
        };
    }
  }
}
