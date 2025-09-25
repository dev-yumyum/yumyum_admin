import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../data/models/business_model.dart';

class BusinessRegisterPage extends StatefulWidget {
  const BusinessRegisterPage({super.key});

  @override
  State<BusinessRegisterPage> createState() => _BusinessRegisterPageState();
}

class _BusinessRegisterPageState extends State<BusinessRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Form controllers
  final _businessNameController = TextEditingController();
  final _businessNumberController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _ownerEmailController = TextEditingController();
  final _businessLocationController = TextEditingController();
  final _businessLocationDetailController = TextEditingController();
  final _businessCategoryController = TextEditingController();
  final _businessItemController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountHolderController = TextEditingController();

  String _selectedBusinessType = 'CORPORATION';
  String _selectedBankName = '국민은행';
  
  // 사업자등록증 이미지 파일 상태
  File? _businessLicenseImage;
  String? _businessLicenseImageName;
  
  // 통장 이미지 파일 상태
  File? _bankBookImage;
  String? _bankBookImageName;

  // 국내 은행 목록
  final List<String> _bankList = [
    '국민은행', '신한은행', '우리은행', '하나은행', 'KB국민은행',
    'NH농협은행', '기업은행', '시티은행', 'SC제일은행', '대구은행',
    '부산은행', '광주은행', '제주은행', '전북은행', '경남은행',
    '수협은행', '신협', '새마을금고', '우체국', '산업은행',
    '카카오뱅크', '토스뱅크', 'K뱅크', '케이뱅크', '뱅크샐러드',
  ];

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessNumberController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _ownerEmailController.dispose();
    _businessLocationController.dispose();
    _businessLocationDetailController.dispose();
    _businessCategoryController.dispose();
    _businessItemController.dispose();
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.business,
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
          onPressed: () => context.go(RouteNames.business),
          icon: Icon(MdiIcons.arrowLeft, size: AppSizes.iconMd),
        ),
        SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '사업자 등록',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
              Text(
                '새로운 사업자 정보를 등록합니다.',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _submitForm,
          icon: _isLoading
              ? SizedBox(
                  width: AppSizes.iconSm,
                  height: AppSizes.iconSm,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(MdiIcons.contentSave, size: AppSizes.iconSm),
          label: Text(_isLoading ? '저장 중...' : '저장'),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildBasicInfoCard(),
          SizedBox(height: AppSizes.lg),
          _buildBusinessInfoCard(),
          SizedBox(height: AppSizes.lg),
          _buildContactInfoCard(),
          SizedBox(height: AppSizes.lg),
          _buildAccountInfoCard(),
        ],
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '기본 정보',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.md),
            TextFormField(
              controller: _businessNameController,
              decoration: const InputDecoration(
                labelText: '사업자명 *',
                hintText: '예: ㈜맛있는집',
              ),
              validator: RequiredValidator(errorText: '사업자명을 입력해주세요.'),
            ),
            SizedBox(height: AppSizes.md),
            TextFormField(
              controller: _businessNumberController,
              decoration: const InputDecoration(
                labelText: '사업자등록번호 *',
                hintText: '예: 123-45-67890',
              ),
              validator: MultiValidator([
                RequiredValidator(errorText: '사업자등록번호를 입력해주세요.'),
                PatternValidator(
                  r'^\d{3}-\d{2}-\d{5}$',
                  errorText: '올바른 사업자등록번호 형식을 입력해주세요. (예: 123-45-67890)',
                ),
              ]),
            ),
            SizedBox(height: AppSizes.md),
            DropdownButtonFormField<String>(
              value: _selectedBusinessType,
              decoration: const InputDecoration(
                labelText: '사업자 유형 *',
              ),
              items: const [
                DropdownMenuItem(value: 'CORPORATION', child: Text('법인')),
                DropdownMenuItem(value: 'INDIVIDUAL', child: Text('개인')),
                DropdownMenuItem(value: 'OTHER', child: Text('기타')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedBusinessType = value!;
                });
              },
            ),
            SizedBox(height: AppSizes.md),
            TextFormField(
              controller: _ownerNameController,
              decoration: const InputDecoration(
                labelText: '대표자명 *',
                hintText: '예: 김맛있',
              ),
              validator: RequiredValidator(errorText: '대표자명을 입력해주세요.'),
            ),
            SizedBox(height: AppSizes.lg),
            _buildBusinessLicenseImageSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessInfoCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '사업 정보',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.md),
            TextFormField(
              controller: _businessLocationController,
              decoration: const InputDecoration(
                labelText: '사업장 소재지 *',
                hintText: '예: 서울특별시 강남구 역삼동 123-45',
              ),
              validator: RequiredValidator(errorText: '사업장 소재지를 입력해주세요.'),
            ),
            SizedBox(height: AppSizes.md),
            TextFormField(
              controller: _businessLocationDetailController,
              decoration: const InputDecoration(
                labelText: '상세주소',
                hintText: '예: ○○빌딩 3층',
              ),
            ),
            SizedBox(height: AppSizes.md),
            TextFormField(
              controller: _businessCategoryController,
              decoration: const InputDecoration(
                labelText: '업종 *',
                hintText: '예: 음식점업',
              ),
              validator: RequiredValidator(errorText: '업종을 입력해주세요.'),
            ),
            SizedBox(height: AppSizes.md),
            TextFormField(
              controller: _businessItemController,
              decoration: const InputDecoration(
                labelText: '종목 *',
                hintText: '예: 한식음식점업',
              ),
              validator: RequiredValidator(errorText: '종목을 입력해주세요.'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '연락처 정보',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.md),
            TextFormField(
              controller: _ownerPhoneController,
              decoration: const InputDecoration(
                labelText: '전화번호 *',
                hintText: '예: 010-1234-5678',
              ),
              validator: MultiValidator([
                RequiredValidator(errorText: '전화번호를 입력해주세요.'),
                PatternValidator(
                  r'^010-\d{4}-\d{4}$',
                  errorText: '올바른 전화번호 형식을 입력해주세요. (예: 010-1234-5678)',
                ),
              ]),
            ),
            SizedBox(height: AppSizes.md),
            TextFormField(
              controller: _ownerEmailController,
              decoration: const InputDecoration(
                labelText: '이메일 *',
                hintText: '예: kim@delicious.com',
              ),
              validator: MultiValidator([
                RequiredValidator(errorText: '이메일을 입력해주세요.'),
                EmailValidator(errorText: '올바른 이메일 형식을 입력해주세요.'),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfoCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '정산 계좌',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.md),
            DropdownButtonFormField<String>(
              value: _selectedBankName,
              decoration: const InputDecoration(
                labelText: '은행명 *',
                hintText: '은행을 선택해주세요',
              ),
              items: _bankList.map((String bank) {
                return DropdownMenuItem<String>(
                  value: bank,
                  child: Text(bank),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBankName = newValue!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '은행을 선택해주세요.';
                }
                return null;
              },
            ),
            SizedBox(height: AppSizes.md),
            TextFormField(
              controller: _accountNumberController,
              decoration: const InputDecoration(
                labelText: '계좌번호 *',
                hintText: '예: 12345678901234',
              ),
              validator: RequiredValidator(errorText: '계좌번호를 입력해주세요.'),
            ),
            SizedBox(height: AppSizes.md),
            TextFormField(
              controller: _accountHolderController,
              decoration: const InputDecoration(
                labelText: '예금주 *',
                hintText: '예: 주식회사맛있는집',
              ),
              validator: RequiredValidator(errorText: '예금주를 입력해주세요.'),
            ),
            SizedBox(height: AppSizes.lg),
            _buildBankBookImageSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessLicenseImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              MdiIcons.fileDocument,
              size: AppSizes.iconSm,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: AppSizes.xs),
            Text(
              '사업자등록증',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(width: AppSizes.xs),
            Text(
              '(선택사항)',
              style: TextStyle(
                fontSize: 20.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.sm),
        Text(
          '사업자등록증 이미지를 첨부해주세요. (JPG, PNG, GIF 파일만 가능)',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppSizes.md),
        if (_businessLicenseImage == null) ...[
          OutlinedButton.icon(
            onPressed: _pickBusinessLicenseImage,
            icon: Icon(MdiIcons.upload, size: AppSizes.iconSm),
            label: const Text('이미지 선택'),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 48.h),
            ),
          ),
        ] else ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.success.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.success.withOpacity(0.05),
            ),
            child: Row(
              children: [
                Icon(
                  MdiIcons.checkCircle,
                  color: AppColors.success,
                  size: AppSizes.iconSm,
                ),
                SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '파일이 선택되었습니다',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.success,
                        ),
                      ),
                      SizedBox(height: AppSizes.xs),
                      Text(
                        _businessLicenseImageName ?? '이미지 파일',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _removeBusinessLicenseImage,
                  icon: Icon(
                    MdiIcons.close,
                    color: AppColors.error,
                    size: AppSizes.iconSm,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickBusinessLicenseImage,
                  icon: Icon(MdiIcons.refresh, size: AppSizes.iconSm),
                  label: const Text('다시 선택'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildBankBookImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              MdiIcons.image,
              size: AppSizes.iconSm,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: AppSizes.xs),
            Text(
              '통장 이미지',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(width: AppSizes.xs),
            Text(
              '(선택사항)',
              style: TextStyle(
                fontSize: 20.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.sm),
        Text(
          '통장 사본 이미지를 첨부해주세요. (JPG, PNG, GIF 파일만 가능)',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppSizes.md),
        if (_bankBookImage == null) ...[
          OutlinedButton.icon(
            onPressed: _pickBankBookImage,
            icon: Icon(MdiIcons.upload, size: AppSizes.iconSm),
            label: const Text('이미지 선택'),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 48.h),
            ),
          ),
        ] else ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.success.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.success.withOpacity(0.05),
            ),
            child: Row(
              children: [
                Icon(
                  MdiIcons.checkCircle,
                  color: AppColors.success,
                  size: AppSizes.iconSm,
                ),
                SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '파일이 선택되었습니다',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.success,
                        ),
                      ),
                      SizedBox(height: AppSizes.xs),
                      Text(
                        _bankBookImageName ?? '이미지 파일',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _removeBankBookImage,
                  icon: Icon(
                    MdiIcons.close,
                    color: AppColors.error,
                    size: AppSizes.iconSm,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickBankBookImage,
                  icon: Icon(MdiIcons.refresh, size: AppSizes.iconSm),
                  label: const Text('다시 선택'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // 사업자등록증 이미지 파일 선택
  Future<void> _pickBusinessLicenseImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        
        setState(() {
          _businessLicenseImage = file;
          _businessLicenseImageName = result.files.first.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이미지 선택 실패: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // 선택된 사업자등록증 이미지 제거
  void _removeBusinessLicenseImage() {
    setState(() {
      _businessLicenseImage = null;
      _businessLicenseImageName = null;
    });
  }

  // 통장 이미지 파일 선택
  Future<void> _pickBankBookImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        
        setState(() {
          _bankBookImage = file;
          _bankBookImageName = result.files.first.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이미지 선택 실패: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // 선택된 통장 이미지 제거
  void _removeBankBookImage() {
    setState(() {
      _bankBookImage = null;
      _bankBookImageName = null;
    });
  }

  // 폼 제출
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: 실제 API 호출로 사업자 데이터 저장
      final businessData = BusinessModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        businessName: _businessNameController.text,
        businessNumber: _businessNumberController.text,
        businessType: _selectedBusinessType,
        ownerName: _ownerNameController.text,
        businessLocation: _businessLocationController.text,
        businessLocationDetail: _businessLocationDetailController.text.isEmpty
            ? null
            : _businessLocationDetailController.text,
        businessAddress: _businessLocationController.text,
        businessAddressDetail: _businessLocationDetailController.text.isEmpty
            ? null
            : _businessLocationDetailController.text,
        businessCategory: _businessCategoryController.text,
        businessItem: _businessItemController.text,
        ownerPhone: _ownerPhoneController.text,
        ownerEmail: _ownerEmailController.text,
        registrationDate: DateTime.now().toString().split(' ')[0],
        status: 'PENDING',
        businessLicenseFileName: _businessLicenseImageName,
        bankName: _selectedBankName,
        accountNumber: _accountNumberController.text,
        accountHolder: _accountHolderController.text,
        accountVerified: false,
        bankBookFileName: _bankBookImageName,
      );

      // 이미지 파일들 처리
      if (_businessLicenseImage != null) {
        print('사업자등록증 이미지 파일: ${_businessLicenseImage!.path}');
        print('파일명: $_businessLicenseImageName');
      }

      if (_bankBookImage != null) {
        print('통장 이미지 파일: ${_bankBookImage!.path}');
        print('파일명: $_bankBookImageName');
      }

      print('등록할 사업자 데이터: ${businessData.toJson()}');

      // 임시 지연 (실제 API 호출 시뮬레이션)
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '사업자 등록이 완료되었습니다. ${_businessLicenseImage != null ? '사업자등록증 ' : ''}${_bankBookImage != null ? '통장 이미지 ' : ''}첨부됨',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        context.go(RouteNames.business);
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
}
