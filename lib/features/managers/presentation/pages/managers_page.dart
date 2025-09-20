import 'package:flutter/material.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../../../core/constants/app_constants.dart';

class ManagersPage extends StatelessWidget {
  const ManagersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.manager,
      child: const Center(
        child: Text('관리자 관리 페이지'),
      ),
    );
  }
}
