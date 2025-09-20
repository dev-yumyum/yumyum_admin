import 'package:flutter/material.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../../../core/constants/app_constants.dart';

class StoreMenuPage extends StatelessWidget {
  final String storeId;
  final bool isRegisterMode;
  
  const StoreMenuPage({super.key, required this.storeId, this.isRegisterMode = false});

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.store,
      child: Center(
        child: Text('매장 메뉴 페이지 - Store ID: $storeId, Register Mode: $isRegisterMode'),
      ),
    );
  }
}
