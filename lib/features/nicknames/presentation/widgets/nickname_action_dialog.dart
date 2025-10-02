import 'package:flutter/material.dart';

class NicknameActionDialog extends StatefulWidget {
  final String title;
  final String nickname;
  final String userId;
  final String currentStatus;
  final bool isBanAction;
  final Function(String nickname, String status, String reason) onSave;

  const NicknameActionDialog({
    super.key,
    required this.title,
    required this.nickname,
    required this.userId,
    required this.currentStatus,
    this.isBanAction = false,
    required this.onSave,
  });

  @override
  State<NicknameActionDialog> createState() => _NicknameActionDialogState();
}

class _NicknameActionDialogState extends State<NicknameActionDialog> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  String _selectedStatus = 'active';

  @override
  void initState() {
    super.initState();
    _nicknameController.text = widget.nickname;
    _selectedStatus = widget.currentStatus;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 정보
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '사용자 ID: ${widget.userId}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '현재 닉네임: ${widget.nickname}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 닉네임 입력
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: '새 닉네임',
                hintText: '변경할 닉네임을 입력하세요',
                border: OutlineInputBorder(),
              ),
              enabled: !widget.isBanAction,
            ),
            
            const SizedBox(height: 16),
            
            // 상태 선택
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: '상태',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'active',
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
                      const Text('활성'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'inactive',
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
                      const Text('비활성'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'banned',
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
                      const Text('차단'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // 사유 입력
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: widget.isBanAction ? '차단 사유' : '변경 사유',
                hintText: widget.isBanAction 
                    ? '차단 사유를 입력하세요' 
                    : '변경 사유를 입력하세요',
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
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
            backgroundColor: widget.isBanAction ? Colors.red : Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: Text(widget.isBanAction ? '차단' : '저장'),
        ),
      ],
    );
  }

  void _onSave() {
    if (_nicknameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임을 입력해주세요.')),
      );
      return;
    }

    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사유를 입력해주세요.')),
      );
      return;
    }

    widget.onSave(
      _nicknameController.text.trim(),
      _selectedStatus,
      _reasonController.text.trim(),
    );
  }
}
