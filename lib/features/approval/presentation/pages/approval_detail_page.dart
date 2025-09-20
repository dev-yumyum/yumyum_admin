import 'package:flutter/material.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../../../core/constants/app_constants.dart';

class ApprovalDetailPage extends StatelessWidget {
  final String? approvalId;
  final String? approvalType;
  
  const ApprovalDetailPage({super.key, this.approvalId, this.approvalType});

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.approval,
      child: Center(
        child: Text('승인 상세 페이지 - ID: $approvalId, Type: $approvalType'),
      ),
    );
  }
}
