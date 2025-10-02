import 'package:flutter/material.dart';

class BannedWordSeverityChip extends StatelessWidget {
  final String severity;

  const BannedWordSeverityChip({
    super.key,
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {
    final severityInfo = _getSeverityInfo(severity);
    
    return Chip(
      label: Text(
        severityInfo['label']!,
        style: TextStyle(
          color: severityInfo['color'] as Color,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
      backgroundColor: (severityInfo['color'] as Color).withOpacity(0.1),
      side: BorderSide(
        color: severityInfo['color'] as Color,
        width: 1,
      ),
    );
  }

  Map<String, dynamic> _getSeverityInfo(String severity) {
    switch (severity) {
      case 'low':
        return {
          'label': '낮음',
          'color': Colors.green,
        };
      case 'medium':
        return {
          'label': '보통',
          'color': Colors.orange,
        };
      case 'high':
        return {
          'label': '높음',
          'color': Colors.red,
        };
      case 'critical':
        return {
          'label': '치명',
          'color': Colors.purple,
        };
      default:
        return {
          'label': '알 수 없음',
          'color': Colors.grey,
        };
    }
  }
}
