class CustomerCouponModel {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final List<CouponModel> coupons;

  CustomerCouponModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.coupons,
  });

  factory CustomerCouponModel.fromJson(Map<String, dynamic> json) {
    return CustomerCouponModel(
      id: json['id'] ?? '',
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      customerEmail: json['customerEmail'] ?? '',
      coupons: (json['coupons'] as List<dynamic>?)
          ?.map((e) => CouponModel.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'coupons': coupons.map((e) => e.toJson()).toList(),
    };
  }

  bool get hasCoupons => coupons.isNotEmpty;
}

class CouponModel {
  final String id;
  final String name;
  final int discountAmount;
  final String issueDate;
  final String? useDate;
  final bool isUsed;
  final CouponType type;

  CouponModel({
    required this.id,
    required this.name,
    required this.discountAmount,
    required this.issueDate,
    this.useDate,
    required this.isUsed,
    required this.type,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      discountAmount: json['discountAmount'] ?? 0,
      issueDate: json['issueDate'] ?? '',
      useDate: json['useDate'],
      isUsed: json['isUsed'] ?? false,
      type: CouponType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => CouponType.welcome,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'discountAmount': discountAmount,
      'issueDate': issueDate,
      'useDate': useDate,
      'isUsed': isUsed,
      'type': type.name,
    };
  }

  String get discountAmountText => '${discountAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원';
}

enum CouponType {
  welcome('웰컴쿠폰'),
  referral('친구초대쿠폰');

  const CouponType(this.displayName);
  final String displayName;
}
