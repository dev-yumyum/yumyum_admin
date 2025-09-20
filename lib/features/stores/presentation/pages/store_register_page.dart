import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../data/models/store_model.dart';

class StoreRegisterPage extends StatefulWidget {
  const StoreRegisterPage({super.key});

  @override
  State<StoreRegisterPage> createState() => _StoreRegisterPageState();
}

class _StoreRegisterPageState extends State<StoreRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Form controllers
  final _storeNameController = TextEditingController();
  final _storeAddressController = TextEditingController();
  final _storeAddressDetailController = TextEditingController();
  final _storePhoneController = TextEditingController();
  final _storeDescriptionController = TextEditingController();

  String? _selectedBusinessId;

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeAddressController.dispose();
    _storeAddressDetailController.dispose();
    _storePhoneController.dispose();
    _storeDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.store,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSizes.lg),
            _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.go(RouteNames.store),
          icon: Icon(MdiIcons.arrowLeft, size: AppSizes.iconMd),
        ),
        SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '매장 등록',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
              Text(
                '새로운 매장을 등록하여 운영을 시작하세요.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '기본 정보',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.lg),
              DropdownButtonFormField<String>(
                value: _selectedBusinessId,
                decoration: InputDecoration(
                  labelText: '사업자 선택 *',
                  hintText: '매장을 등록할 사업자를 선택하세요',
                  prefixIcon: Icon(MdiIcons.domain),
                ),
                items: _getSampleBusinesses().map((business) => 
                  DropdownMenuItem(
                    value: business['id'],
                    child: Text(business['name']!),
                  ),
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBusinessId = value;
                  });
                },
                validator: RequiredValidator(errorText: '사업자를 선택하세요'),
              ),
              SizedBox(height: AppSizes.md),
              TextFormField(
                controller: _storeNameController,
                decoration: InputDecoration(
                  labelText: '매장명 *',
                  hintText: '매장 이름을 입력하세요',
                  prefixIcon: Icon(MdiIcons.storefront),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: '매장명을 입력하세요'),
                  MinLengthValidator(2, errorText: '매장명은 2자 이상이어야 합니다'),
                ]),
              ),
              SizedBox(height: AppSizes.md),
              TextFormField(
                controller: _storeAddressController,
                decoration: InputDecoration(
                  labelText: '매장 주소 *',
                  hintText: '매장 주소를 입력하세요',
                  prefixIcon: Icon(MdiIcons.mapMarker),
                ),
                validator: RequiredValidator(errorText: '매장 주소를 입력하세요'),
              ),
              SizedBox(height: AppSizes.md),
              TextFormField(
                controller: _storeAddressDetailController,
                decoration: InputDecoration(
                  labelText: '상세주소',
                  hintText: '상세주소를 입력하세요 (선택사항)',
                  prefixIcon: Icon(MdiIcons.mapMarkerOutline),
                ),
              ),
              SizedBox(height: AppSizes.md),
              TextFormField(
                controller: _storePhoneController,
                decoration: InputDecoration(
                  labelText: '매장 전화번호',
                  hintText: '매장 전화번호를 입력하세요',
                  prefixIcon: Icon(MdiIcons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: AppSizes.md),
              TextFormField(
                controller: _storeDescriptionController,
                decoration: InputDecoration(
                  labelText: '매장 설명',
                  hintText: '매장을 소개하는 문구를 입력하세요',
                  prefixIcon: Icon(MdiIcons.textBox),
                ),
                maxLines: 3,
              ),
              SizedBox(height: AppSizes.xl),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('매장 등록'),
                    ),
                  ),
                  SizedBox(width: AppSizes.md),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => context.go(RouteNames.store),
                      child: const Text('취소'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: 실제 API 호출로 매장 데이터 저장
      final storeData = StoreModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        businessId: _selectedBusinessId!,
        storeName: _storeNameController.text,
        storeAddress: _storeAddressController.text,
        storeAddressDetail: _storeAddressDetailController.text.isEmpty
            ? null
            : _storeAddressDetailController.text,
        storePhone: _storePhoneController.text.isEmpty
            ? null
            : _storePhoneController.text,
        storeDescription: _storeDescriptionController.text.isEmpty
            ? null
            : _storeDescriptionController.text,
        registrationDate: DateTime.now().toString().split(' ')[0],
        status: 'PENDING',
        isDeliveryAvailable: true,
        isPickupAvailable: true,
      );

      print('등록할 매장 데이터: ${storeData.toJson()}');

      // 임시 지연 (실제 API 호출 시뮬레이션)
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('매장 등록이 완료되었습니다.'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go(RouteNames.store);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('등록 실패: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, String>> _getSampleBusinesses() {
    return [
      {'id': '1', 'name': '㈜맛있는집'},
      {'id': '2', 'name': '치킨왕 프랜차이즈'},
      {'id': '3', 'name': '피자마을'},
    ];
  }
}
