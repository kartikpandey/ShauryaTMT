import 'package:uuid/uuid.dart';
import 'product_model.dart';

class OrderModel {
  final String id;
  final String orderId; // Display ID like ORD-12345
  final String dealerId;
  final String dealerName;
  final String dealerEmail;
  final List<ProductModel> products;
  final double totalAmount;
  final int totalUnits;
  final String status; // 'pending', 'confirmed', 'shipped', 'delivered'
  final String paymentStatus; // 'unpaid', 'partial', 'paid'
  final DateTime orderDate;
  final DateTime? expectedDeliveryDate;
  final DateTime? deliveredDate;
  final String? notes;
  final String? trackingNumber;

  OrderModel({
    String? id,
    required this.orderId,
    required this.dealerId,
    required this.dealerName,
    required this.dealerEmail,
    required this.products,
    required this.totalAmount,
    required this.totalUnits,
    this.status = 'pending',
    this.paymentStatus = 'unpaid',
    DateTime? orderDate,
    this.expectedDeliveryDate,
    this.deliveredDate,
    this.notes,
    this.trackingNumber,
  }) : id = id ?? const Uuid().v4(),
       orderDate = orderDate ?? DateTime.now();

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'orderId': orderId,
    'dealerId': dealerId,
    'dealerName': dealerName,
    'dealerEmail': dealerEmail,
    'products': products.map((p) => p.toJson()).toList(),
    'totalAmount': totalAmount,
    'totalUnits': totalUnits,
    'status': status,
    'paymentStatus': paymentStatus,
    'orderDate': orderDate.toIso8601String(),
    'expectedDeliveryDate': expectedDeliveryDate?.toIso8601String(),
    'deliveredDate': deliveredDate?.toIso8601String(),
    'notes': notes,
    'trackingNumber': trackingNumber,
  };

  // Create from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'] as String?,
    orderId: json['orderId'] as String,
    dealerId: json['dealerId'] as String,
    dealerName: json['dealerName'] as String,
    dealerEmail: json['dealerEmail'] as String,
    products:
        (json['products'] as List)
            .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
            .toList(),
    totalAmount: (json['totalAmount'] as num).toDouble(),
    totalUnits: json['totalUnits'] as int,
    status: json['status'] as String? ?? 'pending',
    paymentStatus: json['paymentStatus'] as String? ?? 'unpaid',
    orderDate: DateTime.parse(json['orderDate'] as String),
    expectedDeliveryDate:
        json['expectedDeliveryDate'] != null
            ? DateTime.parse(json['expectedDeliveryDate'] as String)
            : null,
    deliveredDate:
        json['deliveredDate'] != null
            ? DateTime.parse(json['deliveredDate'] as String)
            : null,
    notes: json['notes'] as String?,
    trackingNumber: json['trackingNumber'] as String?,
  );

  // Copy with
  OrderModel copyWith({
    String? id,
    String? orderId,
    String? dealerId,
    String? dealerName,
    String? dealerEmail,
    List<ProductModel>? products,
    double? totalAmount,
    int? totalUnits,
    String? status,
    String? paymentStatus,
    DateTime? orderDate,
    DateTime? expectedDeliveryDate,
    DateTime? deliveredDate,
    String? notes,
    String? trackingNumber,
  }) => OrderModel(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    dealerId: dealerId ?? this.dealerId,
    dealerName: dealerName ?? this.dealerName,
    dealerEmail: dealerEmail ?? this.dealerEmail,
    products: products ?? this.products,
    totalAmount: totalAmount ?? this.totalAmount,
    totalUnits: totalUnits ?? this.totalUnits,
    status: status ?? this.status,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    orderDate: orderDate ?? this.orderDate,
    expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
    deliveredDate: deliveredDate ?? this.deliveredDate,
    notes: notes ?? this.notes,
    trackingNumber: trackingNumber ?? this.trackingNumber,
  );
}
