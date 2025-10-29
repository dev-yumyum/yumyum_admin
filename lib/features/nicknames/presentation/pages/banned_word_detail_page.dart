import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/crm_layout.dart';
import '../widgets/banned_word_severity_chip.dart';

class BannedWordDetailPage extends ConsumerStatefulWidget {
  final String? wordId;

  const BannedWordDetailPage({
    super.key,
    this.wordId,
  });

  @override
  ConsumerState<BannedWordDetailPage> createState() => _BannedWordDetailPageState();
}

class _BannedWordDetailPageState extends ConsumerState<BannedWordDetailPage> {
  bool _isEditing = false;
  
  // 폼 컨트롤러
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedType = 'text';
  String _selectedSeverity = 'medium';
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _loadBannedWordDetail();
  }

  @override
  void dispose() {
    _wordController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadBannedWordDetail() {
    // TODO: API 호출로 금칙어 상세 정보 로드
    // 임시 데이터
    _wordController.text = '욕설단어';
    _descriptionController.text = '사용자 신고가 많은 욕설 단어입니다.';
    _selectedType = 'text';
    _selectedSeverity = 'high';
    _isActive = true;
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    // TODO: API 호출로 금칙어 정보 업데이트
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('금칙어 정보가 수정되었습니다.')),
    );
    setState(() {
      _isEditing = false;
    });
  }

  void _deleteBannedWord() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('금칙어 삭제'),
        content: const Text('이 금칙어를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              // TODO: API 호출로 금칙어 삭제
              Navigator.of(context).pop();
              context.go('/banned-words');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('금칙어가 삭제되었습니다.')),
              );
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: '/banned-words',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          _buildHeader(),
          const SizedBox(height: 24),
          
          // 메인 컨텐츠
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 기본 정보
                  _buildBasicInfoSection(),
                  const SizedBox(height: 24),
                  
                  // 적발 내역
                  _buildDetectionHistorySection(),
                  const SizedBox(height: 24),
                  
                  // 수정 이력
                  _buildModificationHistorySection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 뒤로가기 버튼
          IconButton(
            onPressed: () => context.go('/banned-words'),
            icon: const Icon(Icons.arrow_back),
            tooltip: '목록으로',
          ),
          SizedBox(width: 12.w),
          
          // 제목
          Text(
            '금칙어 상세',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          
          // 활성/비활성 상태
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: _isActive 
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isActive ? Icons.check_circle : Icons.cancel,
                  color: _isActive ? Colors.green : Colors.grey,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  _isActive ? '활성' : '비활성',
                  style: TextStyle(
                    color: _isActive ? Colors.green : Colors.grey,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          
          // 수정/저장 버튼
          if (!_isEditing)
            ElevatedButton.icon(
              onPressed: _toggleEditMode,
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('수정'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              ),
            )
          else
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save, size: 18),
                  label: const Text('저장'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  ),
                ),
                SizedBox(width: 8.w),
                OutlinedButton.icon(
                  onPressed: _toggleEditMode,
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('취소'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  ),
                ),
              ],
            ),
          SizedBox(width: 8.w),
          
          // 삭제 버튼
          IconButton(
            onPressed: _deleteBannedWord,
            icon: const Icon(Icons.delete),
            color: Colors.red,
            tooltip: '삭제',
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '기본 정보',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),
          
          // 금칙어
          _buildInfoRow(
            '금칙어',
            _isEditing
                ? TextField(
                    controller: _wordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    ),
                  )
                : Text(
                    _wordController.text,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
          ),
          
          SizedBox(height: 16.h),
          
          // 타입
          _buildInfoRow(
            '타입',
            _isEditing
                ? DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'text', child: Text('텍스트')),
                      DropdownMenuItem(value: 'regex', child: Text('정규식')),
                      DropdownMenuItem(value: 'special_char', child: Text('특수문자')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedType = value);
                      }
                    },
                  )
                : _buildTypeChip(_selectedType),
          ),
          
          SizedBox(height: 16.h),
          
          // 심각도
          _buildInfoRow(
            '심각도',
            _isEditing
                ? DropdownButtonFormField<String>(
                    value: _selectedSeverity,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'low', child: Text('낮음')),
                      DropdownMenuItem(value: 'medium', child: Text('보통')),
                      DropdownMenuItem(value: 'high', child: Text('높음')),
                      DropdownMenuItem(value: 'critical', child: Text('치명')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedSeverity = value);
                      }
                    },
                  )
                : BannedWordSeverityChip(severity: _selectedSeverity),
          ),
          
          SizedBox(height: 16.h),
          
          // 설명
          _buildInfoRow(
            '설명',
            _isEditing
                ? TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      contentPadding: EdgeInsets.all(12.w),
                    ),
                  )
                : Text(
                    _descriptionController.text,
                    style: TextStyle(fontSize: 13.sp),
                  ),
          ),
          
          SizedBox(height: 16.h),
          
          // 상태
          _buildInfoRow(
            '상태',
            _isEditing
                ? SwitchListTile(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() => _isActive = value);
                    },
                    title: Text(_isActive ? '활성' : '비활성'),
                    contentPadding: EdgeInsets.zero,
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: _isActive
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      _isActive ? '활성' : '비활성',
                      style: TextStyle(
                        color: _isActive ? Colors.green : Colors.grey,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
          
          SizedBox(height: 16.h),
          
          // 등록일
          _buildInfoRow(
            '등록일',
            Text(
              '2024-01-15 14:30:25',
              style: TextStyle(fontSize: 13.sp),
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // 최종 수정일
          _buildInfoRow(
            '최종 수정일',
            Text(
              '2024-01-20 09:15:40',
              style: TextStyle(fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionHistorySection() {
    // TODO: 실제 데이터로 교체
    final mockHistory = [
      {
        'user': '사용자123',
        'content': '이 금칙어가 포함된 메시지입니다.',
        'location': '리뷰',
        'action': '자동 차단',
        'timestamp': '2024-01-20 15:30',
      },
      {
        'user': '사용자456',
        'content': '또 다른 금칙어 사용 사례',
        'location': '닉네임',
        'action': '경고',
        'timestamp': '2024-01-19 11:20',
      },
      {
        'user': '사용자789',
        'content': '세 번째 적발 사례',
        'location': '매장명',
        'action': '자동 차단',
        'timestamp': '2024-01-18 09:45',
      },
    ];

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '최근 적발 내역',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '최근 10건',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          
          ...mockHistory.map((item) => _buildHistoryItem(item)),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  item['location']!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: item['action'] == '자동 차단'
                      ? Colors.red.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  item['action']!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: item['action'] == '자동 차단' ? Colors.red : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                item['timestamp']!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.person, size: 16.sp, color: Colors.grey[600]),
              SizedBox(width: 4.w),
              Text(
                item['user']!,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            item['content']!,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModificationHistorySection() {
    // TODO: 실제 데이터로 교체
    final mockModHistory = [
      {
        'admin': '관리자1',
        'action': '심각도 변경',
        'detail': '보통 → 높음',
        'timestamp': '2024-01-20 09:15',
      },
      {
        'admin': '관리자2',
        'action': '설명 수정',
        'detail': '설명 내용이 업데이트되었습니다.',
        'timestamp': '2024-01-18 14:30',
      },
      {
        'admin': '관리자1',
        'action': '금칙어 생성',
        'detail': '최초 등록',
        'timestamp': '2024-01-15 14:30',
      },
    ];

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '수정 이력',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),
          
          ...mockModHistory.map((item) => _buildModificationItem(item)),
        ],
      ),
    );
  }

  Widget _buildModificationItem(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120.w,
            child: Text(
              item['timestamp']!,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item['admin']!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          item['action']!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    item['detail']!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, Widget value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        value,
      ],
    );
  }

  Widget _buildTypeChip(String type) {
    final typeInfo = {
      'text': {'label': '텍스트', 'color': Colors.blue},
      'regex': {'label': '정규식', 'color': Colors.orange},
      'special_char': {'label': '특수문자', 'color': Colors.purple},
    };

    final info = typeInfo[type]!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: (info['color']! as Color).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        info['label']! as String,
        style: TextStyle(
          color: info['color']! as Color,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

