import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../core/constants/app_constants.dart';

class SearchableDropdown extends StatefulWidget {
  final String labelText;
  final String? value;
  final List<DropdownItem> items;
  final ValueChanged<String?> onChanged;
  final String? hintText;
  final double? width;

  const SearchableDropdown({
    super.key,
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.value,
    this.hintText,
    this.width,
  });

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  List<DropdownItem> _filteredItems = [];
  String? _selectedValue;
  String _displayText = '';

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _selectedValue = widget.value;
    _updateDisplayText();
    
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _updateDisplayText() {
    if (_selectedValue != null) {
      final selectedItem = widget.items.firstWhere(
        (item) => item.value == _selectedValue,
        orElse: () => DropdownItem(value: '', label: ''),
      );
      _displayText = selectedItem.label;
      _searchController.text = _displayText;
    }
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) => item.label.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
    _updateOverlay();
  }

  void _showOverlay() {
    _hideOverlay();
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: widget.width ?? 200.w,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, 60.h),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 300.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                border: Border.all(color: AppColors.border),
                color: Colors.white,
              ),
              child: _filteredItems.isEmpty
                  ? Container(
                      padding: EdgeInsets.all(AppSizes.md),
                      child: Text(
                        '검색 결과가 없습니다',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return InkWell(
                          onTap: () => _selectItem(item),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.md,
                              vertical: AppSizes.sm,
                            ),
                            decoration: BoxDecoration(
                              color: item.value == _selectedValue
                                  ? AppColors.primary.withOpacity(0.1)
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.label,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: item.value == _selectedValue
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                      fontWeight: item.value == _selectedValue
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (item.value == _selectedValue)
                                  Icon(
                                    MdiIcons.check,
                                    size: AppSizes.iconSm,
                                    color: AppColors.primary,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectItem(DropdownItem item) {
    setState(() {
      _selectedValue = item.value;
      _displayText = item.label;
      _searchController.text = _displayText;
    });
    
    _hideOverlay();
    _focusNode.unfocus();
    widget.onChanged(item.value);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: widget.width ?? 200.w,
        child: TextFormField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText ?? '검색 또는 선택하세요',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _selectedValue = null;
                        _displayText = '';
                        _filteredItems = widget.items;
                      });
                      widget.onChanged(null);
                    },
                    icon: Icon(
                      MdiIcons.close,
                      size: AppSizes.iconSm,
                      color: AppColors.textSecondary,
                    ),
                  ),
                Icon(
                  MdiIcons.chevronDown,
                  size: AppSizes.iconSm,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: AppSizes.xs),
              ],
            ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
          ),
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textPrimary,
          ),
          onChanged: _filterItems,
          onTap: () {
            if (!_focusNode.hasFocus) {
              _focusNode.requestFocus();
            }
          },
        ),
      ),
    );
  }
}

class DropdownItem {
  final String value;
  final String label;
  final dynamic data; // 추가 데이터를 위한 필드

  DropdownItem({
    required this.value,
    required this.label,
    this.data,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DropdownItem && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
