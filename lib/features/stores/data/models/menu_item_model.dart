import 'package:json_annotation/json_annotation.dart';

part 'menu_item_model.g.dart';

@JsonSerializable()
class MenuItemModel {
  final String id;
  final String name;
  final String storeId;
  final String menuGroupId;
  final int price;
  final String? description;
  final String? imageUrl;
  final String status; // SELLING, SOLD_OUT, HIDDEN
  final int sortOrder;
  final String createdDate;
  final String? lastModifiedDate;
  final List<String> optionGroupIds; // 연결된 옵션 그룹 ID들

  static const String statusSelling = 'SELLING';
  static const String statusSoldOut = 'SOLD_OUT';
  static const String statusHidden = 'HIDDEN';

  MenuItemModel({
    required this.id,
    required this.name,
    required this.storeId,
    required this.menuGroupId,
    required this.price,
    this.description,
    this.imageUrl,
    this.status = statusSelling,
    required this.sortOrder,
    required this.createdDate,
    this.lastModifiedDate,
    this.optionGroupIds = const [],
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$MenuItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemModelToJson(this);

  MenuItemModel copyWith({
    String? id,
    String? name,
    String? storeId,
    String? menuGroupId,
    int? price,
    String? description,
    String? imageUrl,
    String? status,
    int? sortOrder,
    String? createdDate,
    String? lastModifiedDate,
    List<String>? optionGroupIds,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      storeId: storeId ?? this.storeId,
      menuGroupId: menuGroupId ?? this.menuGroupId,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      sortOrder: sortOrder ?? this.sortOrder,
      createdDate: createdDate ?? this.createdDate,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      optionGroupIds: optionGroupIds ?? this.optionGroupIds,
    );
  }

  String get displayStatus {
    switch (status) {
      case statusSelling:
        return '판매중';
      case statusSoldOut:
        return '오늘만 품절';
      case statusHidden:
        return '메뉴 숨김';
      default:
        return '판매중';
    }
  }

  String get formattedPrice {
    return '${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원';
  }
}
