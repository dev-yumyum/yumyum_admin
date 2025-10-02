import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:data_table_2/data_table_2.dart';

import '../../../core/providers/api_providers.dart';
import '../../../shared/widgets/crm_layout.dart';
import '../../../core/models/pagination_model.dart';
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
      title: '닉네임 관리',
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
            label: Text(option['label']!),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                _onStatusFilterChanged(option['value']!);
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
    return Container(
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
          // 테이블 헤더
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
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
                  '총 0개',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // 데이터 테이블
          Expanded(
            child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 800,
              columns: const [
                DataColumn2(
                  label: Text('닉네임'),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text('사용자 ID'),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: Text('상태'),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text('생성일'),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: Text('관리'),
                  size: ColumnSize.S,
                ),
              ],
              rows: _buildTableRows(),
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> _buildTableRows() {
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

    return mockData.map((data) {
      return DataRow(
        cells: [
          DataCell(
            Text(
              data['nickname']!,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          DataCell(Text(data['userId']!)),
          DataCell(
            NicknameStatusChip(status: data['status']!),
          ),
          DataCell(Text(data['createdAt']!)),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () => _showEditDialog(data),
                  tooltip: '수정',
                ),
                IconButton(
                  icon: const Icon(Icons.block, size: 18),
                  onPressed: () => _showBanDialog(data),
                  tooltip: '차단',
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
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
