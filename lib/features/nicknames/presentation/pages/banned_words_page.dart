import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:data_table_2/data_table_2.dart';

import '../../../core/providers/api_providers.dart';
import '../../../shared/widgets/crm_layout.dart';
import '../../../core/models/pagination_model.dart';
import '../widgets/banned_word_severity_chip.dart';
import '../widgets/banned_word_dialog.dart';

class BannedWordsPage extends ConsumerStatefulWidget {
  const BannedWordsPage({super.key});

  @override
  ConsumerState<BannedWordsPage> createState() => _BannedWordsPageState();
}

class _BannedWordsPageState extends ConsumerState<BannedWordsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'all';
  String _selectedSeverity = 'all';
  int _currentPage = 1;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadBannedWords();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadBannedWords() {
    // TODO: API 호출로 금칙어 목록 로드
  }

  void _onSearch() {
    setState(() {
      _currentPage = 1;
    });
    _loadBannedWords();
  }

  void _onFilterChanged() {
    setState(() {
      _currentPage = 1;
    });
    _loadBannedWords();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _loadBannedWords();
  }

  @override
  Widget build(BuildContext context) {
    return CrmLayout(
      title: '금칙어 관리',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 필터 및 검색
          _buildFilterSection(),
          const SizedBox(height: 24),
          
          // 금칙어 목록 테이블
          Expanded(
            child: _buildBannedWordsTable(),
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
                    hintText: '금칙어 또는 설명으로 검색',
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
          
          // 필터 옵션
          Row(
            children: [
              const Text(
                '타입:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              _buildTypeFilter(),
              const SizedBox(width: 24),
              const Text(
                '심각도:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              _buildSeverityFilter(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeFilter() {
    final typeOptions = [
      {'value': 'all', 'label': '전체'},
      {'value': 'text', 'label': '텍스트'},
      {'value': 'regex', 'label': '정규식'},
      {'value': 'special_char', 'label': '특수문자'},
    ];

    return Row(
      children: typeOptions.map((option) {
        final isSelected = _selectedType == option['value'];
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(option['label']!),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _selectedType = option['value']!;
                });
                _onFilterChanged();
              }
            },
            backgroundColor: Colors.grey[100],
            selectedColor: Colors.blue.withOpacity(0.2),
            checkmarkColor: Colors.blue,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeverityFilter() {
    final severityOptions = [
      {'value': 'all', 'label': '전체', 'color': Colors.grey},
      {'value': 'low', 'label': '낮음', 'color': Colors.green},
      {'value': 'medium', 'label': '보통', 'color': Colors.orange},
      {'value': 'high', 'label': '높음', 'color': Colors.red},
      {'value': 'critical', 'label': '치명', 'color': Colors.purple},
    ];

    return Row(
      children: severityOptions.map((option) {
        final isSelected = _selectedSeverity == option['value'];
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(option['label']!),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _selectedSeverity = option['value']!;
                });
                _onFilterChanged();
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

  Widget _buildBannedWordsTable() {
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
                  '금칙어 목록',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showAddDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('금칙어 추가'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                const SizedBox(width: 8),
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
              minWidth: 1000,
              columns: const [
                DataColumn2(
                  label: Text('금칙어'),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text('타입'),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text('심각도'),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text('사용횟수'),
                  size: ColumnSize.S,
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
        'word': '욕설단어',
        'type': 'text',
        'severity': 'high',
        'usageCount': 15,
        'isActive': true,
        'createdAt': '2024-01-15',
      },
      {
        'word': '.*@.*',
        'type': 'regex',
        'severity': 'medium',
        'usageCount': 3,
        'isActive': true,
        'createdAt': '2024-01-14',
      },
      {
        'word': '!@#\$%',
        'type': 'special_char',
        'severity': 'low',
        'usageCount': 0,
        'isActive': false,
        'createdAt': '2024-01-13',
      },
    ];

    return mockData.map((data) {
      return DataRow(
        cells: [
          DataCell(
            Text(
              data['word']!,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          DataCell(_buildTypeChip(data['type']!)),
          DataCell(
            BannedWordSeverityChip(severity: data['severity']!),
          ),
          DataCell(Text(data['usageCount'].toString())),
          DataCell(
            Chip(
              label: Text(
                data['isActive'] == true ? '활성' : '비활성',
                style: TextStyle(
                  color: data['isActive'] == true ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: data['isActive'] == true 
                  ? Colors.green.withOpacity(0.1) 
                  : Colors.grey.withOpacity(0.1),
            ),
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
                  icon: Icon(
                    data['isActive'] == true ? Icons.pause : Icons.play_arrow,
                    size: 18,
                  ),
                  onPressed: () => _toggleActive(data),
                  tooltip: data['isActive'] == true ? '비활성화' : '활성화',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  onPressed: () => _showDeleteDialog(data),
                  tooltip: '삭제',
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildTypeChip(String type) {
    final typeInfo = {
      'text': {'label': '텍스트', 'color': Colors.blue},
      'regex': {'label': '정규식', 'color': Colors.orange},
      'special_char': {'label': '특수문자', 'color': Colors.purple},
    };

    final info = typeInfo[type]!;
    return Chip(
      label: Text(
        info['label']!,
        style: TextStyle(
          color: info['color'] as Color,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: (info['color'] as Color).withOpacity(0.1),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => BannedWordDialog(
        title: '금칙어 추가',
        onSave: (word, type, severity, description) {
          // TODO: API 호출로 금칙어 추가
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('금칙어가 추가되었습니다.')),
          );
        },
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => BannedWordDialog(
        title: '금칙어 수정',
        initialWord: data['word']!,
        initialType: data['type']!,
        initialSeverity: data['severity']!,
        initialDescription: '설명',
        onSave: (word, type, severity, description) {
          // TODO: API 호출로 금칙어 수정
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('금칙어가 수정되었습니다.')),
          );
        },
      ),
    );
  }

  void _toggleActive(Map<String, dynamic> data) {
    // TODO: API 호출로 활성/비활성 토글
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          data['isActive'] == true 
              ? '금칙어가 비활성화되었습니다.' 
              : '금칙어가 활성화되었습니다.',
        ),
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('금칙어 삭제'),
        content: Text('"${data['word']}" 금칙어를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              // TODO: API 호출로 금칙어 삭제
              Navigator.of(context).pop();
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
}
