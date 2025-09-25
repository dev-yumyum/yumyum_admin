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
import '../../data/models/business_change_history_model.dart';
import '../../../stores/data/models/store_model.dart';

class BusinessDetailPage extends StatefulWidget {
  final String? businessId;

  const BusinessDetailPage({super.key, this.businessId});

  @override
  State<BusinessDetailPage> createState() => _BusinessDetailPageState();
}

class _BusinessDetailPageState extends State<BusinessDetailPage> {
  BusinessModel? _business;
  bool _isLoading = true;
  bool _isEditing = false;
  
  // 매장 연결 관련
  List<StoreModel> _connectedStores = [];
  List<StoreModel> _availableStores = [];
  List<BusinessChangeHistoryModel> _changeHistories = [];
  bool _isStoresLoading = false;
  
  // Form key
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _businessNameController = TextEditingController();
  final _businessNumberController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _businessLocationController = TextEditingController();
  final _businessLocationDetailController = TextEditingController();
  final _businessCategoryController = TextEditingController();
  final _businessItemController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _ownerEmailController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountHolderController = TextEditingController();
  final _loginIdController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Dropdown selections
  String _selectedBusinessType = 'CORPORATION';
  String _selectedBankName = '국민은행';
  
  // File attachments
  File? _businessLicenseImage;
  String? _businessLicenseImageName;
  File? _bankBookImage;
  String? _bankBookImageName;
  
  // Existing file URLs
  String? _existingBusinessLicenseUrl;
  String? _existingBankBookUrl;
  
  // Bank list
  final List<String> _bankList = [
    '국민은행', '신한은행', '우리은행', '하나은행', 'KB국민은행',
    'NH농협은행', '기업은행', '시티은행', 'SC제일은행', '대구은행',
    '부산은행', '광주은행', '제주은행', '전북은행', '경남은행',
    '수협은행', '신협', '새마을금고', '우체국', '산업은행',
  ];

  @override
  void initState() {
    super.initState();
    _loadBusinessData();
    _loadConnectedStores();
    _loadChangeHistories();
  }
  
  @override
  void dispose() {
    _businessNameController.dispose();
    _businessNumberController.dispose();
    _ownerNameController.dispose();
    _businessLocationController.dispose();
    _businessLocationDetailController.dispose();
    _businessCategoryController.dispose();
    _businessItemController.dispose();
    _ownerPhoneController.dispose();
    _ownerEmailController.dispose();
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    _loginIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadBusinessData() async {
    // TODO: 실제 API 호출로 데이터 가져오기
    // 현재는 샘플 데이터 사용
    await Future.delayed(const Duration(seconds: 1));
    
    final sampleBusinesses = _getSampleBusinesses();
    final business = sampleBusinesses.firstWhere(
      (b) => b.id == widget.businessId,
      orElse: () => sampleBusinesses.first,
    );

    if (mounted) {
      setState(() {
        _business = business;
        _isLoading = false;
      });
      _populateFormFields();
    }
  }
  
  void _populateFormFields() {
    if (_business == null) return;
    
    _businessNameController.text = _business!.businessName;
    _businessNumberController.text = _business!.businessNumber;
    _ownerNameController.text = _business!.ownerName;
    _businessLocationController.text = _business!.businessLocation ?? '';
    _businessLocationDetailController.text = _business!.businessLocationDetail ?? '';
    _businessCategoryController.text = _business!.businessCategory ?? '';
    _businessItemController.text = _business!.businessItem ?? '';
    _ownerPhoneController.text = _business!.ownerPhone ?? '';
    _ownerEmailController.text = _business!.ownerEmail ?? '';
    _accountNumberController.text = _business!.accountNumber ?? '';
    _accountHolderController.text = _business!.accountHolder ?? '';
    _loginIdController.text = _business!.loginId ?? '';
    _passwordController.text = _business!.password ?? '';
    
    _selectedBusinessType = _business!.businessType;
    _selectedBankName = _business!.bankName ?? '국민은행';
    
    _existingBusinessLicenseUrl = _business!.businessLicenseFileName;
    _existingBankBookUrl = _business!.bankBookFileName;
  }
  
  void _enterEditMode() {
    setState(() {
      _isEditing = true;
    });
  }
  
  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _businessLicenseImage = null;
      _businessLicenseImageName = null;
      _bankBookImage = null;
      _bankBookImageName = null;
    });
    _populateFormFields(); // Reset form fields
  }
  
  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // TODO: 실제 API 호출로 데이터 저장
      // 현재는 시뮬레이션만
      
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('사업자 정보가 성공적으로 수정되었습니다.'),
            backgroundColor: AppColors.success,
          ),
        );
        
        setState(() {
          _isEditing = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장 실패: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  // File picker methods
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

  void _removeBusinessLicenseImage() {
    setState(() {
      _businessLicenseImage = null;
      _businessLicenseImageName = null;
    });
  }

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

  void _removeBankBookImage() {
    setState(() {
      _bankBookImage = null;
      _bankBookImageName = null;
    });
  }
  
  void _resetPassword() {
    setState(() {
      _passwordController.text = 'yumyum10';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('비밀번호가 초기화되었습니다.'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: RouteNames.business,
      child: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    SizedBox(height: AppSizes.lg),
                    _buildContent(),
                    if (_isEditing) ...[
                      SizedBox(height: AppSizes.lg),
                      _buildActionButtons(),
                    ],
                  ],
                ),
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
                '사업자 상세정보',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.xs),
              Text(
                '${_business?.businessName ?? '사업자'} 정보',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _buildStatusChip(),
        SizedBox(width: AppSizes.md),
        ElevatedButton.icon(
          onPressed: _isEditing ? null : _enterEditMode,
          icon: Icon(MdiIcons.pencil, size: AppSizes.iconSm),
          label: const Text('수정'),
        ),
      ],
    );
  }

  Widget _buildStatusChip() {
    if (_business == null) return const SizedBox.shrink();
    
    Color chipColor;
    String statusText;
    
    switch (_business!.status) {
      case 'APPROVED':
        chipColor = AppColors.approved;
        statusText = '승인완료';
        break;
      case 'PENDING':
        chipColor = AppColors.pending;
        statusText = '승인대기';
        break;
      case 'REJECTED':
        chipColor = AppColors.rejected;
        statusText = '승인거부';
        break;
      default:
        chipColor = AppColors.inactive;
        statusText = '알 수 없음';
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_business == null) return const SizedBox.shrink();

    return Column(
      children: [
        _buildBasicInfoCard(),
        SizedBox(height: AppSizes.lg),
        _buildBusinessInfoCard(),
        SizedBox(height: AppSizes.lg),
        _buildContactInfoCard(),
        SizedBox(height: AppSizes.lg),
        _buildAccountInfoCard(),
        SizedBox(height: AppSizes.lg),
        _buildConnectedStoresCard(),
        SizedBox(height: AppSizes.lg),
        _buildChangeHistoryCard(),
      ],
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  MdiIcons.domain,
                  size: AppSizes.iconMd,
                  color: AppColors.primary,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  '기본 정보',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.lg),
            _buildEditableField(
              '사업자명',
              _businessNameController,
              isRequired: true,
              validator: RequiredValidator(errorText: '사업자명을 입력하세요'),
            ),
            _buildEditableField(
              '사업자등록번호',
              _businessNumberController,
              isRequired: true,
              validator: RequiredValidator(errorText: '사업자등록번호를 입력하세요'),
            ),
            _buildDropdownField(
              '사업자 유형',
              _getBusinessTypeDisplayName(_selectedBusinessType),
              ['법인', '일반'],
              (value) {
                setState(() {
                  _selectedBusinessType = value == '법인' ? 'CORPORATION' : 'INDIVIDUAL';
                });
              },
              isRequired: true,
            ),
            _buildEditableField(
              '대표자명',
              _ownerNameController,
              isRequired: true,
              validator: RequiredValidator(errorText: '대표자명을 입력하세요'),
            ),
            if (!_isEditing)
              _buildInfoRow('등록일', _business!.registrationDate),
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
            Row(
              children: [
                Icon(
                  MdiIcons.domain,
                  size: AppSizes.iconMd,
                  color: AppColors.secondary,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  '사업 정보',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.lg),
            _buildEditableField(
              '사업장 소재지',
              _businessLocationController,
              isRequired: true,
              validator: RequiredValidator(errorText: '사업장 소재지를 입력하세요'),
            ),
            _buildEditableField(
              '상세주소',
              _businessLocationDetailController,
            ),
            _buildEditableField(
              '업종',
              _businessCategoryController,
              isRequired: true,
              validator: RequiredValidator(errorText: '업종을 입력하세요'),
            ),
            _buildEditableField(
              '종목',
              _businessItemController,
              isRequired: true,
              validator: RequiredValidator(errorText: '종목을 입력하세요'),
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
            Row(
              children: [
                Icon(
                  MdiIcons.phone,
                  size: AppSizes.iconMd,
                  color: AppColors.info,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  '연락처 정보',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.lg),
            _buildEditableField(
              '전화번호',
              _ownerPhoneController,
              isRequired: true,
              validator: RequiredValidator(errorText: '전화번호를 입력하세요'),
              keyboardType: TextInputType.phone,
            ),
            _buildEditableField(
              '이메일',
              _ownerEmailController,
              isRequired: true,
              validator: MultiValidator([
                RequiredValidator(errorText: '이메일을 입력하세요'),
                EmailValidator(errorText: '올바른 이메일 형식이 아닙니다'),
              ]),
              keyboardType: TextInputType.emailAddress,
            ),
            _buildEditableField(
              '아이디',
              _loginIdController,
              isRequired: true,
              validator: RequiredValidator(errorText: '아이디를 입력하세요'),
            ),
            _buildPasswordField(),
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
            Row(
              children: [
                Icon(
                  MdiIcons.bank,
                  size: AppSizes.iconMd,
                  color: AppColors.warning,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  '정산 계좌',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (_business!.accountVerified == true)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          MdiIcons.checkCircle,
                          size: AppSizes.iconXs,
                          color: AppColors.success,
                        ),
                        SizedBox(width: AppSizes.xs),
                        Text(
                          '확인완료',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          MdiIcons.clockAlert,
                          size: AppSizes.iconXs,
                          color: AppColors.warning,
                        ),
                        SizedBox(width: AppSizes.xs),
                        Text(
                          '확인대기',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: AppSizes.lg),
            _buildDropdownField(
              '은행명',
              _selectedBankName,
              _bankList,
              (value) {
                setState(() {
                  _selectedBankName = value!;
                });
              },
              isRequired: true,
            ),
            _buildEditableField(
              '계좌번호',
              _accountNumberController,
              isRequired: true,
              validator: RequiredValidator(errorText: '계좌번호를 입력하세요'),
              keyboardType: TextInputType.number,
            ),
            _buildEditableField(
              '예금주',
              _accountHolderController,
              isRequired: true,
              validator: RequiredValidator(errorText: '예금주를 입력하세요'),
            ),
            _buildBankBookImageSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: _saveChanges,
          icon: Icon(MdiIcons.check, size: AppSizes.iconSm),
          label: const Text('저장'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
            minimumSize: Size(120.w, 48.h),
          ),
        ),
        SizedBox(width: AppSizes.md),
        OutlinedButton.icon(
          onPressed: _cancelEditing,
          icon: Icon(MdiIcons.close, size: AppSizes.iconSm),
          label: const Text('취소'),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(120.w, 48.h),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: AppSizes.md),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEditableField(String label, TextEditingController controller, {
    bool isRequired = false,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.error,
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSizes.xs),
          TextFormField(
            controller: controller,
            enabled: _isEditing,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: _isEditing ? '$label을(를) 입력하세요' : null,
              filled: true,
              fillColor: _isEditing ? null : AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                borderSide: BorderSide(color: AppColors.border),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: _isEditing ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDropdownField(String label, String value, List<String> items, 
      ValueChanged<String?> onChanged, {bool isRequired = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.error,
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSizes.xs),
          if (_isEditing)
            DropdownButtonFormField<String>(
              value: value,
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            )
          else
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.md + 4.h,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                color: AppColors.background,
              ),
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFileRow(String label, String fileName) {
    return Container(
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            MdiIcons.fileImage,
            size: AppSizes.iconSm,
            color: AppColors.primary,
          ),
          SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                Text(
                  fileName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: 파일 다운로드 기능
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('파일 다운로드 기능 구현 예정'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
            icon: Icon(
              MdiIcons.download,
              size: AppSizes.iconSm,
              color: AppColors.primary,
            ),
            tooltip: '다운로드',
          ),
        ],
      ),
    );
  }
  
  Widget _buildBusinessLicenseImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '사업자등록증',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              ' (선택사항)',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.xs),
        if (_isEditing) ...[
          Text(
            '사업자등록증 이미지를 첨부해주세요. (JPG, PNG, GIF 파일만 가능)',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.md),
          if (_businessLicenseImage == null && _existingBusinessLicenseUrl == null) ...[
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
                          _businessLicenseImage != null ? '새 파일 선택됨' : '기존 파일',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.success,
                          ),
                        ),
                        SizedBox(height: AppSizes.xs),
                        Text(
                          _businessLicenseImageName ?? _existingBusinessLicenseUrl ?? '이미지 파일',
                          style: TextStyle(
                            fontSize: 12.sp,
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
        ] else if (_existingBusinessLicenseUrl != null) ...[
          _buildFileRow('사업자등록증', _existingBusinessLicenseUrl!),
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
            Text(
              '통장 사본',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              ' (선택사항)',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.xs),
        if (_isEditing) ...[
          Text(
            '통장 사본 이미지를 첨부해주세요. (JPG, PNG, GIF 파일만 가능)',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.md),
          if (_bankBookImage == null && _existingBankBookUrl == null) ...[
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
                          _bankBookImage != null ? '새 파일 선택됨' : '기존 파일',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.success,
                          ),
                        ),
                        SizedBox(height: AppSizes.xs),
                        Text(
                          _bankBookImageName ?? _existingBankBookUrl ?? '이미지 파일',
                          style: TextStyle(
                            fontSize: 12.sp,
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
        ] else if (_existingBankBookUrl != null) ...[
          _buildFileRow('통장 사본', _existingBankBookUrl!),
        ],
      ],
    );
  }
  
  Widget _buildPasswordField() {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '비밀번호',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                ' *',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.xs),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _passwordController,
                  enabled: _isEditing,
                  obscureText: !_isEditing,
                  validator: RequiredValidator(errorText: '비밀번호를 입력하세요'),
                  decoration: InputDecoration(
                    hintText: _isEditing ? '비밀번호를 입력하세요' : null,
                    filled: true,
                    fillColor: _isEditing ? null : AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _isEditing ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
              ),
              if (_isEditing) ...[
                SizedBox(width: AppSizes.sm),
                OutlinedButton.icon(
                  onPressed: _resetPassword,
                  icon: Icon(MdiIcons.refresh, size: AppSizes.iconSm),
                  label: const Text('초기화'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(80.w, 36.h),
                    side: BorderSide(color: AppColors.warning),
                    foregroundColor: AppColors.warning,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _getBusinessTypeDisplayName(String type) {
    switch (type) {
      case 'CORPORATION':
        return '법인';
      case 'INDIVIDUAL':
        return '개인';
      case 'OTHER':
        return '기타';
      default:
        return type;
    }
  }

  List<BusinessModel> _getSampleBusinesses() {
    return [
      BusinessModel(
        id: '1',
        businessName: '㈜맛있는집',
        businessNumber: '123-45-67890',
        businessType: 'CORPORATION',
        ownerName: '김맛있',
        businessLocation: '서울특별시 강남구 역삼동 123-45',
        businessLocationDetail: '○○빌딩 3층',
        businessAddress: '서울특별시 강남구 역삼동 123-45',
        businessAddressDetail: '○○빌딩 3층',
        businessCategory: '음식점업',
        businessItem: '한식음식점업',
        ownerPhone: '010-1234-5678',
        ownerEmail: 'kim@delicious.com',
        registrationDate: '2024-08-15',
        status: 'APPROVED',
        businessLicenseFileName: '맛있는집_사업자등록증.jpg',
        bankName: '국민은행',
        accountNumber: '12345678901234',
        accountHolder: '주식회사맛있는집',
        accountVerified: true,
        loginId: 'delicious001',
        password: 'yumyum10',
        connectedStoreIds: ['1', '2'],
      ),
      BusinessModel(
        id: '2',
        businessName: '치킨왕 프랜차이즈',
        businessNumber: '234-56-78901',
        businessType: 'CORPORATION',
        ownerName: '박치킨',
        businessLocation: '서울특별시 홍대구 홍익동 456-78',
        businessLocationDetail: '△△타워 2층',
        businessAddress: '서울특별시 홍대구 홍익동 456-78',
        businessAddressDetail: '△△타워 2층',
        businessCategory: '음식점업',
        businessItem: '치킨전문점',
        ownerPhone: '010-2345-6789',
        ownerEmail: 'park@chicken.com',
        registrationDate: '2024-08-20',
        status: 'PENDING',
        businessLicenseFileName: '치킨왕_사업자등록증.png',
        bankName: '신한은행',
        accountNumber: '98765432109876',
        accountHolder: '박치킨',
        accountVerified: false,
        loginId: 'chicken002',
        password: 'chicken123',
        connectedStoreIds: ['3'],
      ),
      BusinessModel(
        id: '3',
        businessName: '피자마을',
        businessNumber: '345-67-89012',
        businessType: 'INDIVIDUAL',
        ownerName: '이피자',
        businessLocation: '서울특별시 신촌구 신촌동 789-12',
        businessLocationDetail: '□□플라자 1층',
        businessAddress: '서울특별시 신촌구 신촌동 789-12',
        businessAddressDetail: '□□플라자 1층',
        businessCategory: '음식점업',
        businessItem: '피자전문점',
        ownerPhone: '010-3456-7890',
        ownerEmail: 'lee@pizza.com',
        registrationDate: '2024-09-01',
        status: 'APPROVED',
        bankName: '우리은행',
        accountNumber: '11111222223333',
        accountHolder: '이피자',
        accountVerified: false,
        loginId: 'pizza003',
        password: 'pizza456',
        connectedStoreIds: ['4'],
      ),
    ];
  }

  Future<void> _loadConnectedStores() async {
    setState(() {
      _isStoresLoading = true;
    });

    try {
      // TODO: 실제 API 호출로 연결된 매장 및 전체 매장 목록 가져오기
      await Future.delayed(const Duration(milliseconds: 500));
      
      final allStores = _getSampleStores();
      final connectedStoreIds = _business?.connectedStoreIds ?? [];
      
      if (mounted) {
        setState(() {
          _connectedStores = allStores.where((store) => 
              connectedStoreIds.contains(store.id)).toList();
          _availableStores = allStores.where((store) => 
              !connectedStoreIds.contains(store.id)).toList();
          _isStoresLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isStoresLoading = false;
        });
      }
    }
  }

  Future<void> _loadChangeHistories() async {
    try {
      // TODO: 실제 API 호출로 변경이력 가져오기
      await Future.delayed(const Duration(milliseconds: 300));
      
      final histories = _getSampleChangeHistories();
      
      if (mounted) {
        setState(() {
          _changeHistories = histories;
        });
      }
    } catch (e) {
      // 에러 처리
    }
  }

  Future<void> _connectStore(StoreModel store) async {
    setState(() {
      _isStoresLoading = true;
    });

    try {
      // TODO: 실제 API 호출로 매장 연결
      await Future.delayed(const Duration(seconds: 1));
      
      final updatedConnectedStores = List<StoreModel>.from(_connectedStores)..add(store);
      final updatedAvailableStores = _availableStores.where((s) => s.id != store.id).toList();
      
      // 변경이력 추가
      final history = BusinessChangeHistoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        businessId: _business!.id,
        changeType: BusinessChangeHistoryModel.typeStoreConnect,
        changeField: BusinessChangeHistoryModel.fieldConnectedStores,
        asIsValue: _connectedStores.map((s) => s.storeName).join(', '),
        toBeValue: updatedConnectedStores.map((s) => s.storeName).join(', '),
        changedBy: '관리자',
        changeDate: DateTime.now(),
        description: '${store.storeName} 매장 연결',
      );
      
      if (mounted) {
        setState(() {
          _connectedStores = updatedConnectedStores;
          _availableStores = updatedAvailableStores;
          _changeHistories.insert(0, history);
          _isStoresLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${store.storeName} 매장이 연결되었습니다.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isStoresLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('매장 연결 실패: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _disconnectStore(StoreModel store) async {
    setState(() {
      _isStoresLoading = true;
    });

    try {
      // TODO: 실제 API 호출로 매장 연결 해제
      await Future.delayed(const Duration(seconds: 1));
      
      final updatedConnectedStores = _connectedStores.where((s) => s.id != store.id).toList();
      final updatedAvailableStores = List<StoreModel>.from(_availableStores)..add(store);
      
      // 변경이력 추가
      final history = BusinessChangeHistoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        businessId: _business!.id,
        changeType: BusinessChangeHistoryModel.typeStoreDisconnect,
        changeField: BusinessChangeHistoryModel.fieldConnectedStores,
        asIsValue: _connectedStores.map((s) => s.storeName).join(', '),
        toBeValue: updatedConnectedStores.map((s) => s.storeName).join(', '),
        changedBy: '관리자',
        changeDate: DateTime.now(),
        description: '${store.storeName} 매장 연결 해제',
      );
      
      if (mounted) {
        setState(() {
          _connectedStores = updatedConnectedStores;
          _availableStores = updatedAvailableStores;
          _changeHistories.insert(0, history);
          _isStoresLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${store.storeName} 매장 연결이 해제되었습니다.'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isStoresLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('매장 연결 해제 실패: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showStoreSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => _StoreSearchDialog(
        availableStores: _availableStores,
        onStoreSelected: _connectStore,
      ),
    );
  }

  List<StoreModel> _getSampleStores() {
    return [
      StoreModel(
        id: '1',
        businessId: '1',
        storeName: '맛있는집 강남점',
        storeAddress: '서울특별시 강남구 역삼동 123-45',
        storeAddressDetail: '○○빌딩 1층',
        storePhone: '02-1234-5678',
        storeDescription: '정통 한식 전문점',
        registrationDate: '2024-08-15',
        status: 'ACTIVE',
        operatingHours: '11:00-22:00',
        deliveryRadius: '3',
        isDeliveryAvailable: true,
        isPickupAvailable: true,
        minimumOrderAmount: '15000',
        deliveryFee: '3000',
        businessName: '㈜맛있는집',
        menuCount: 25,
        lastOrderDate: '2024-09-18',
      ),
      StoreModel(
        id: '2',
        businessId: '1',
        storeName: '맛있는집 홍대점',
        storeAddress: '서울특별시 마포구 홍익동 456-78',
        storeAddressDetail: '△△빌딩 지하1층',
        storePhone: '02-2345-6789',
        storeDescription: '젊은 감각의 한식당',
        registrationDate: '2024-08-20',
        status: 'ACTIVE',
        operatingHours: '11:00-23:00',
        deliveryRadius: '2.5',
        isDeliveryAvailable: true,
        isPickupAvailable: true,
        minimumOrderAmount: '12000',
        deliveryFee: '2500',
        businessName: '㈜맛있는집',
        menuCount: 30,
        lastOrderDate: '2024-09-19',
      ),
      StoreModel(
        id: '3',
        businessId: '2',
        storeName: '치킨왕 신촌점',
        storeAddress: '서울특별시 서대문구 신촌동 789-12',
        storeAddressDetail: '□□플라자 2층',
        storePhone: '02-3456-7890',
        storeDescription: '바삭한 프리미엄 치킨',
        registrationDate: '2024-09-01',
        status: 'ACTIVE',
        operatingHours: '16:00-02:00',
        deliveryRadius: '5',
        isDeliveryAvailable: true,
        isPickupAvailable: true,
        minimumOrderAmount: '18000',
        deliveryFee: '3500',
        businessName: '치킨왕 프랜차이즈',
        menuCount: 15,
        lastOrderDate: '2024-09-19',
      ),
      StoreModel(
        id: '4',
        businessId: '3',
        storeName: '피자마을 본점',
        storeAddress: '서울특별시 신촌구 신촌동 321-54',
        storeAddressDetail: '◇◇타워 1층',
        storePhone: '02-4567-8901',
        storeDescription: '수제 도우 피자 전문',
        registrationDate: '2024-09-05',
        status: 'ACTIVE',
        operatingHours: '11:00-23:00',
        deliveryRadius: '4',
        isDeliveryAvailable: true,
        isPickupAvailable: true,
        minimumOrderAmount: '20000',
        deliveryFee: '4000',
        businessName: '피자마을',
        menuCount: 20,
        lastOrderDate: '2024-09-17',
      ),
    ];
  }

  List<BusinessChangeHistoryModel> _getSampleChangeHistories() {
    return [
      BusinessChangeHistoryModel(
        id: '1',
        businessId: '1',
        changeType: BusinessChangeHistoryModel.typeStoreConnect,
        changeField: BusinessChangeHistoryModel.fieldConnectedStores,
        asIsValue: '맛있는집 강남점',
        toBeValue: '맛있는집 강남점, 맛있는집 홍대점',
        changedBy: '관리자',
        changeDate: DateTime.now().subtract(const Duration(days: 2)),
        description: '맛있는집 홍대점 매장 연결',
      ),
      BusinessChangeHistoryModel(
        id: '2',
        businessId: '1',
        changeType: BusinessChangeHistoryModel.typeContactInfo,
        changeField: BusinessChangeHistoryModel.fieldOwnerPhone,
        asIsValue: '010-1234-5677',
        toBeValue: '010-1234-5678',
        changedBy: '관리자',
        changeDate: DateTime.now().subtract(const Duration(days: 5)),
        description: '대표자 연락처 수정',
      ),
      BusinessChangeHistoryModel(
        id: '3',
        businessId: '1',
        changeType: BusinessChangeHistoryModel.typeBusinessInfo,
        changeField: BusinessChangeHistoryModel.fieldBusinessName,
        asIsValue: '맛있는집',
        toBeValue: '㈜맛있는집',
        changedBy: '관리자',
        changeDate: DateTime.now().subtract(const Duration(days: 10)),
        description: '사업자명 변경 (법인 전환)',
      ),
    ];
  }

  Widget _buildConnectedStoresCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  MdiIcons.store,
                  size: AppSizes.iconMd,
                  color: AppColors.success,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  '연결된 매장',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _isStoresLoading ? null : _showStoreSearchDialog,
                  icon: Icon(MdiIcons.plus, size: AppSizes.iconSm),
                  label: const Text('매장 연결'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.lg),
            if (_isStoresLoading)
              const Center(child: CircularProgressIndicator())
            else if (_connectedStores.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Icon(
                      MdiIcons.storeOff,
                      size: AppSizes.iconLg,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: AppSizes.sm),
                    Text(
                      '연결된 매장이 없습니다',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: _connectedStores.map((store) => _buildStoreItem(store)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreItem(StoreModel store) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.sm),
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            MdiIcons.store,
            size: AppSizes.iconMd,
            color: AppColors.success,
          ),
          SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.storeName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.xs),
                Text(
                  store.storeAddress,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (store.storePhone != null) ...[
                  SizedBox(height: AppSizes.xs),
                  Row(
                    children: [
                      Icon(
                        MdiIcons.phone,
                        size: AppSizes.iconXs,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: AppSizes.xs),
                      Text(
                        store.storePhone!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'disconnect') {
                _showDisconnectConfirmDialog(store);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'disconnect',
                child: Row(
                  children: [
                    Icon(MdiIcons.linkOff, size: AppSizes.iconSm, color: AppColors.error),
                    SizedBox(width: AppSizes.sm),
                    const Text('연결 해제'),
                  ],
                ),
              ),
            ],
            child: Icon(
              MdiIcons.dotsVertical,
              size: AppSizes.iconSm,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeHistoryCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  MdiIcons.history,
                  size: AppSizes.iconMd,
                  color: AppColors.info,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  '변경이력',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.lg),
            if (_changeHistories.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Icon(
                      MdiIcons.history,
                      size: AppSizes.iconLg,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: AppSizes.sm),
                    Text(
                      '변경이력이 없습니다',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                height: 400.h,
                child: ListView.builder(
                  itemCount: _changeHistories.length,
                  itemBuilder: (context, index) => _buildChangeHistoryItem(_changeHistories[index]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeHistoryItem(BusinessChangeHistoryModel history) {
    Color typeColor;
    switch (history.changeType) {
      case BusinessChangeHistoryModel.typeStoreConnect:
        typeColor = AppColors.success;
        break;
      case BusinessChangeHistoryModel.typeStoreDisconnect:
        typeColor = AppColors.warning;
        break;
      default:
        typeColor = AppColors.info;
    }

    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.sm),
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                ),
                child: Text(
                  history.displayChangeType,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: typeColor,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${history.changeDate.year}-${history.changeDate.month.toString().padLeft(2, '0')}-${history.changeDate.day.toString().padLeft(2, '0')} ${history.changeDate.hour.toString().padLeft(2, '0')}:${history.changeDate.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.sm),
          Text(
            history.displayFieldName,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.xs),
          if (history.asIsValue != null || history.toBeValue != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (history.asIsValue != null) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AS-IS',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                        SizedBox(height: AppSizes.xs),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(AppSizes.sm),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(color: AppColors.error.withOpacity(0.2)),
                          ),
                          child: Text(
                            history.asIsValue!,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSizes.sm),
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Icon(
                      MdiIcons.arrowRight,
                      size: AppSizes.iconSm,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: AppSizes.sm),
                ],
                if (history.toBeValue != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TO-BE',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                        SizedBox(height: AppSizes.xs),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(AppSizes.sm),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(color: AppColors.success.withOpacity(0.2)),
                          ),
                          child: Text(
                            history.toBeValue!,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
          if (history.description != null) ...[
            SizedBox(height: AppSizes.sm),
            Text(
              history.description!,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          SizedBox(height: AppSizes.xs),
          Row(
            children: [
              Icon(
                MdiIcons.account,
                size: AppSizes.iconXs,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: AppSizes.xs),
              Text(
                '변경자: ${history.changedBy}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDisconnectConfirmDialog(StoreModel store) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('매장 연결 해제'),
        content: Text('${store.storeName} 매장과의 연결을 해제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _disconnectStore(store);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('해제'),
          ),
        ],
      ),
    );
  }
}

class _StoreSearchDialog extends StatefulWidget {
  final List<StoreModel> availableStores;
  final Function(StoreModel) onStoreSelected;

  const _StoreSearchDialog({
    required this.availableStores,
    required this.onStoreSelected,
  });

  @override
  State<_StoreSearchDialog> createState() => _StoreSearchDialogState();
}

class _StoreSearchDialogState extends State<_StoreSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<StoreModel> _filteredStores = [];

  @override
  void initState() {
    super.initState();
    _filteredStores = widget.availableStores;
    _searchController.addListener(_filterStores);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterStores() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStores = widget.availableStores.where((store) {
        return store.storeName.toLowerCase().contains(query) ||
               store.storeAddress.toLowerCase().contains(query) ||
               (store.storeDescription?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600.w,
        height: 700.h,
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  MdiIcons.storeSearch,
                  size: AppSizes.iconMd,
                  color: AppColors.primary,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  '매장 검색 및 연결',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(MdiIcons.close, size: AppSizes.iconMd),
                ),
              ],
            ),
            SizedBox(height: AppSizes.lg),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '매장명, 주소로 검색하세요',
                prefixIcon: Icon(MdiIcons.magnify),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                ),
              ),
            ),
            SizedBox(height: AppSizes.lg),
            Text(
              '연결 가능한 매장 (${_filteredStores.length}개)',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.md),
            Expanded(
              child: _filteredStores.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.storeOff,
                            size: AppSizes.iconXl,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: AppSizes.md),
                          Text(
                            _searchController.text.isEmpty
                                ? '연결 가능한 매장이 없습니다'
                                : '검색 결과가 없습니다',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredStores.length,
                      itemBuilder: (context, index) {
                        final store = _filteredStores[index];
                        return _buildStoreSearchItem(store);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreSearchItem(StoreModel store) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(
            MdiIcons.store,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          store.storeName,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              store.storeAddress,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
            if (store.storeDescription != null) ...[
              SizedBox(height: AppSizes.xs),
              Text(
                store.storeDescription!,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            SizedBox(height: AppSizes.xs),
            Row(
              children: [
                if (store.isDeliveryAvailable)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.xs,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '포장',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (store.isPickupAvailable) ...[
                  if (store.isDeliveryAvailable) SizedBox(width: AppSizes.xs),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.xs,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '포장',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppColors.info,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (store.menuCount != null)
                  Text(
                    '메뉴 ${store.menuCount}개',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onStoreSelected(store);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
            minimumSize: Size(60.w, 32.h),
          ),
          child: const Text('연결'),
        ),
        contentPadding: EdgeInsets.all(AppSizes.md),
      ),
    );
  }
}
