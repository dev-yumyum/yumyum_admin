import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:data_table_2/data_table_2.dart';

import '../../../../core/providers/api_providers.dart';
import '../../../../shared/widgets/crm_layout.dart';
import '../../../../core/models/pagination_model.dart';
import '../widgets/nickname_status_chip.dart';
import '../widgets/nickname_action_dialog.dart';

class NicknameManagementPage extends ConsumerStatefulWidget {
  const NicknameManagementPage({super.key});

  @override
  ConsumerState<NicknameManagementPage> createState() => _NicknameManagementPageState();
}

class _NicknameManagementPageState extends ConsumerState<NicknameManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'all';
  int _currentPage = 1;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadNicknames();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadNicknames() {
    // TODO: API 호출로 닉네임 목록 로드
  }

  void _onSearch() {
    setState(() {
      _currentPage = 1;
    });
    _loadNicknames();
  }

  void _onStatusFilterChanged(String status) {
    setState(() {
      _selectedStatus = status;
      _currentPage = 1;
    });
    _loadNicknames();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _loadNicknames();
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      currentRoute: '/nickname-management',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 필터 및 검색
          _buildFilterSection(),
          const SizedBox(height: 24),
          
          // 닉네임 목록 테이블
          Expanded(
            child: _buildNicknameTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 검색 입력
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '닉네임 또는 사용자 ID로 검색',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearch();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: (_) => _onSearch(),
                ),
              ),
              const SizedBox(width: 16),
              
              // 검색 버튼
              ElevatedButton.icon(
                onPressed: _onSearch,
                icon: const Icon(Icons.search),
                label: const Text('검색'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 상태 필터
          Row(
            children: [
              const Text(
                '상태 필터:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              _buildStatusFilter(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    final statusOptions = [
      {'value': 'all', 'label': '전체', 'color': Colors.grey},
      {'value': 'active', 'label': '활성', 'color': Colors.green},
      {'value': 'inactive', 'label': '비활성', 'color': Colors.orange},
      {'value': 'banned', 'label': '차단', 'color': Colors.red},
    ];

    return Row(
      children: statusOptions.map((option) {
        final isSelected = _selectedStatus == option['value'];
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(option['label']! as String),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                _onStatusFilterChanged(option['value']! as String);
              }
            },
            backgroundColor: Colors.grey[100],
            selectedColor: (option['color'] as Color).withOpacity(0.2),
            checkmarkColor: option['color'] as Color,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNicknameTable() {
    // TODO: 실제 데이터로 교체
    final mockData = [
      {
        'nickname': '맛있는치킨',
        'userId': 'user_001',
        'status': 'active',
        'createdAt': '2024-01-15',
      },
      {
        'nickname': '피자러버',
        'userId': 'user_002',
        'status': 'inactive',
        'createdAt': '2024-01-14',
      },
      {
        'nickname': '불량닉네임',
        'userId': 'user_003',
        'status': 'banned',
        'createdAt': '2024-01-13',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '닉네임 목록',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '총 ${mockData.length}개',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: mockData.length,
            itemBuilder: (context, index) {
              return _buildNicknameCard(mockData[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNicknameCard(Map<String, String> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showEditDialog(data),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 22,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                data['nickname']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              NicknameStatusChip(status: data['status']!),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data['userId']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _showEditDialog(data),
                          tooltip: '수정',
                          color: Colors.grey[700],
                        ),
                        IconButton(
                          icon: const Icon(Icons.block, size: 20),
                          onPressed: () => _showBanDialog(data),
                          tooltip: '차단',
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '생성일',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            data['createdAt']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(Map<String, String> data) {
    showDialog(
      context: context,
      builder: (context) => NicknameActionDialog(
        title: '닉네임 수정',
        nickname: data['nickname']!,
        userId: data['userId']!,
        currentStatus: data['status']!,
        onSave: (newNickname, newStatus, reason) {
          // TODO: API 호출로 닉네임 수정
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('닉네임이 수정되었습니다.')),
          );
        },
      ),
    );
  }

  void _showBanDialog(Map<String, String> data) {
    showDialog(
      context: context,
      builder: (context) => NicknameActionDialog(
        title: '닉네임 차단',
        nickname: data['nickname']!,
        userId: data['userId']!,
        currentStatus: data['status']!,
        isBanAction: true,
        onSave: (newNickname, newStatus, reason) {
          // TODO: API 호출로 닉네임 차단
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('닉네임이 차단되었습니다.')),
          );
        },
      ),
    );
  }
}
