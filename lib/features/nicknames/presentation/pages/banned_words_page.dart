import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:html' as html;

import '../../../../shared/widgets/crm_layout.dart';

class BannedWordsPage extends ConsumerStatefulWidget {
  const BannedWordsPage({super.key});

  @override
  ConsumerState<BannedWordsPage> createState() => _BannedWordsPageState();
}

class _BannedWordsPageState extends ConsumerState<BannedWordsPage> with SingleTickerProviderStateMixin {
  final TextEditingController _singleWordController = TextEditingController();
  final TextEditingController _textEditorController = TextEditingController();
  late TabController _tabController;
  
  bool _autoSort = false;
  bool _allowComments = true;
  
  List<String> _bannedWords = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBannedWords();
    
    // 탭 변경 시 텍스트 에디터와 리스트 동기화
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        // 텍스트 편집 탭으로 전환 시 리스트를 텍스트로 변환
        _syncListToText();
      }
    });
  }

  @override
  void dispose() {
    _singleWordController.dispose();
    _textEditorController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _loadBannedWords() {
    // TODO: API 호출로 금칙어 목록 로드
    setState(() {
      _bannedWords = [
        '# 예시',
        '버슷어1',
        '버슷어2',
        '금칙어-패턴',
      ];
      _syncListToText();
    });
  }

  void _syncListToText() {
    _textEditorController.text = _bannedWords.join('\n');
  }

  void _syncTextToList() {
    final text = _textEditorController.text;
    final lines = text.split('\n');
    setState(() {
      _bannedWords = lines;
      if (_autoSort) {
        _sortWords();
      }
    });
  }

  void _sortWords() {
    final comments = <String>[];
    final words = <String>[];
    
    for (var word in _bannedWords) {
      if (word.trim().startsWith('#')) {
        comments.add(word);
      } else if (word.trim().isNotEmpty) {
        words.add(word);
      }
    }
    
    words.sort();
    
    setState(() {
      if (_allowComments) {
        _bannedWords = [...comments, ...words];
      } else {
        _bannedWords = words;
      }
      _syncListToText();
    });
  }

  void _addSingleWord() {
    final word = _singleWordController.text.trim();
    if (word.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('단어를 입력해주세요.')),
      );
      return;
    }

    setState(() {
      _bannedWords.add(word);
      _singleWordController.clear();
      _syncListToText();
      
      if (_autoSort) {
        _sortWords();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('\'$word\'이(가) 추가되었습니다.')),
    );
  }

  void _removeWord(int index) {
    final word = _bannedWords[index];
    setState(() {
      _bannedWords.removeAt(index);
      _syncListToText();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('\'$word\'이(가) 삭제되었습니다.')),
    );
  }

  void _loadFromFile() {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.txt';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final file = files[0];
      final reader = html.FileReader();

      reader.onLoadEnd.listen((e) {
        final text = reader.result as String;
        _textEditorController.text = text;
        _syncTextToList();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('파일을 불러왔습니다.')),
        );
      });

      reader.readAsText(file);
    });
  }

  void _downloadAsText() {
    final text = _textEditorController.text;
    final bytes = text.codeUnits;
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    // ignore: unused_local_variable
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'banned_words_${DateTime.now().millisecondsSinceEpoch}.txt')
      ..click();
    html.Url.revokeObjectUrl(url);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('다운로드가 시작되었습니다.')),
    );
  }

  void _loadFromServer() {
    // TODO: 서버에서 금칙어 목록 불러오기 API 호출
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('서버에서 불러오는 중...')),
    );
  }

  void _saveToServer() {
    // TODO: 서버에 금칙어 목록 저장 API 호출
    _syncTextToList(); // 텍스트 변경사항 반영
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('서버에 저장되었습니다.')),
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
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: _buildMainContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 현재 목록 제목
          const Text(
            '현재 목록',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // 단어 추가 섹션
          const Text(
            '단어 추가',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          
          // 단어 입력 필드
          TextField(
            controller: _singleWordController,
            decoration: InputDecoration(
              hintText: '단어를 입력 후 Enter',
              helperText: '검색어 관리 화면 (react)',
              helperStyle: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            onSubmitted: (_) => _addSingleWord(),
          ),
          const SizedBox(height: 16),
          
          // 파일 불러오기 버튼
          OutlinedButton.icon(
            onPressed: _loadFromFile,
            icon: const Icon(Icons.upload_file, size: 20),
            label: const Text('파일 불러오기'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          const SizedBox(height: 20),
          
          // 옵션 토글
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Switch(
                      value: _autoSort,
                      onChanged: (value) {
                        setState(() {
                          _autoSort = value;
                          if (_autoSort) {
                            _sortWords();
                          }
                        });
                      },
                      activeColor: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '자동 정렬',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Switch(
                      value: _allowComments,
                      onChanged: (value) {
                        setState(() {
                          _allowComments = value;
                        });
                      },
                      activeColor: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '# 주석 허용',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // 탭과 컨텐츠
          Expanded(
            child: Column(
              children: [
                // 탭 버튼
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildTabButton('목록 보기', 0),
                      const SizedBox(width: 8),
                      _buildTabButton('텍스트 편집', 1),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // 탭 컨텐츠
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildListViewTab(),
                      _buildTextEditTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _tabController.index == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _tabController.animateTo(index);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.black : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.black : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Text(
          '금칙어 관리',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: _loadFromServer,
          icon: const Icon(Icons.cloud_download, size: 18),
          label: const Text('서버에서 불러오기'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: _downloadAsText,
          icon: const Icon(Icons.download, size: 18),
          label: const Text('.txt로 다운로드'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: _saveToServer,
          icon: const Icon(Icons.save, size: 18),
          label: const Text('서버에 저장'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }


  Widget _buildListViewTab() {
    final displayWords = _bannedWords.where((word) {
      if (!_allowComments && word.trim().startsWith('#')) {
        return false;
      }
      return word.trim().isNotEmpty;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 카운트 표시
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            '총 ${displayWords.length}개의 항목',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        
        // 목록
        Expanded(
          child: displayWords.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.list_alt,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '등록된 금칙어가 없습니다.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: ListView.builder(
                    itemCount: displayWords.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final word = displayWords[index];
                      final isComment = word.trim().startsWith('#');
                      final originalIndex = _bannedWords.indexOf(word);
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: isComment ? Colors.grey[50] : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isComment ? Colors.grey[300]! : Colors.grey[200]!,
                          ),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isComment ? Colors.grey[200] : Colors.grey[100],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          title: Text(
                            word,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isComment ? FontWeight.normal : FontWeight.w500,
                              color: isComment ? Colors.grey[600] : Colors.black87,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            color: Colors.grey[600],
                            onPressed: () => _removeWord(originalIndex),
                            tooltip: '삭제',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildTextEditTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 안내 메시지
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '한 줄에 한 단어씩 작성하세요. 빈 줄 무시. #으로 시작하는 줄은 주석으로 처리됩니다.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // 텍스트 입력 영역
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
              color: Colors.grey[50],
            ),
            child: TextField(
              controller: _textEditorController,
              maxLines: null,
              expands: true,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'monospace',
                height: 1.6,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: '# 예시|n버|숙어1|n버|숙어2|n금칙어-패턴',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'monospace',
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              onChanged: (value) {
                // 텍스트 변경 시 자동 동기화는 하지 않음 (성능)
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // 버튼
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                _syncListToText();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('목록에서 텍스트를 다시 불러왔습니다.')),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                side: BorderSide(color: Colors.grey[400]!),
              ),
              child: const Text('초기화'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                _syncTextToList();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('텍스트가 목록에 반영되었습니다.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('적용'),
            ),
          ],
        ),
      ],
    );
  }
}
