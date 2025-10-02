import 'package:flutter/material.dart';

class BannedWordDialog extends StatefulWidget {
  final String title;
  final String? initialWord;
  final String? initialType;
  final String? initialSeverity;
  final String? initialDescription;
  final Function(String word, String type, String severity, String description) onSave;

  const BannedWordDialog({
    super.key,
    required this.title,
    this.initialWord,
    this.initialType,
    this.initialSeverity,
    this.initialDescription,
    required this.onSave,
  });

  @override
  State<BannedWordDialog> createState() => _BannedWordDialogState();
}

class _BannedWordDialogState extends State<BannedWordDialog> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedType = 'text';
  String _selectedSeverity = 'medium';

  @override
  void initState() {
    super.initState();
    _wordController.text = widget.initialWord ?? '';
    _descriptionController.text = widget.initialDescription ?? '';
    _selectedType = widget.initialType ?? 'text';
    _selectedSeverity = widget.initialSeverity ?? 'medium';
  }

  @override
  void dispose() {
    _wordController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 금칙어 입력
            TextField(
              controller: _wordController,
              decoration: const InputDecoration(
                labelText: '금칙어',
                hintText: '금칙어를 입력하세요 (정규식 사용 가능)',
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 타입 선택
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: '타입',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'text',
                  child: Text('텍스트'),
                ),
                DropdownMenuItem(
                  value: 'regex',
                  child: Text('정규식'),
                ),
                DropdownMenuItem(
                  value: 'special_char',
                  child: Text('특수문자'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // 심각도 선택
            DropdownButtonFormField<String>(
              value: _selectedSeverity,
              decoration: const InputDecoration(
                labelText: '심각도',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'low',
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('낮음'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'medium',
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('보통'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'high',
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('높음'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'critical',
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.purple,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('치명'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSeverity = value!;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // 설명 입력
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '설명',
                hintText: '금칙어에 대한 설명을 입력하세요',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            
            const SizedBox(height: 16),
            
            // 도움말
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue[600], size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '도움말',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• 텍스트: 정확한 단어나 문장 매칭\n'
                    '• 정규식: 패턴 매칭 (예: .*@.*)\n'
                    '• 특수문자: 특수 기호나 문자 조합',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('저장'),
        ),
      ],
    );
  }

  void _onSave() {
    if (_wordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('금칙어를 입력해주세요.')),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('설명을 입력해주세요.')),
      );
      return;
    }

    widget.onSave(
      _wordController.text.trim(),
      _selectedType,
      _selectedSeverity,
      _descriptionController.text.trim(),
    );
  }
}
