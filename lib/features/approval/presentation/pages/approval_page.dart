import 'package:flutter/material.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../../../core/constants/app_constants.dart';

class ApprovalPage extends StatelessWidget {
  const ApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.approval,
      child: const Center(
        child: Text('승인 관리 페이지'),
      ),
    );
  }
}
