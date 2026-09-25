import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _selectedOrderId;

  // Getters
  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  OrderModel? get selectedOrder =>
      _selectedOrderId != null
          ? _orders.firstWhere(
            (o) => o.id == _selectedOrderId,
            orElse: () => _orders.first,
          )
          : null;

  OrderProvider() {
    _initializeMockData();
  }

  // Initialize mock data
  void _initializeMockData() {
    _orders = [
      OrderModel(
        orderId: 'ORD-001',
        dealerId: '1',
        dealerName: 'Jain Mining Co.',
        dealerEmail: 'contact@jainmining.com',
        products: [
          ProductModel(
            name: 'ShauryaTMT 6mm',
            size: '6mm',
            grade: 'Grade A',
            quantity: 50,
            unitPrice: 500,
            totalPrice: 25000,
            unit: 'tonnes',
          ),
          ProductModel(
            name: 'ShauryaTMT 10mm',
            size: '10mm',
            grade: 'Grade B',
            quantity: 30,
            unitPrice: 450,
            totalPrice: 13500,
            unit: 'tonnes',
          ),
        ],
        totalAmount: 38500,
        totalUnits: 80,
        status: 'confirmed',
        paymentStatus: 'paid',
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
        expectedDeliveryDate: DateTime.now().add(const Duration(days: 5)),
      ),
      OrderModel(
        orderId: 'ORD-002',
        dealerId: '2',
        dealerName: 'Sudama Traders',
        dealerEmail: 'info@sudama.com',
        products: [
          ProductModel(
            name: 'ShauryaTMT 8mm',
            size: '8mm',
            grade: 'Grade A',
            quantity: 75,
            unitPrice: 480,
            totalPrice: 36000,
            unit: 'tonnes',
          ),
        ],
        totalAmount: 36000,
        totalUnits: 75,
        status: 'shipped',
        paymentStatus: 'paid',
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        expectedDeliveryDate: DateTime.now().add(const Duration(days: 2)),
        trackingNumber: 'TRACK-12345',
      ),
      OrderModel(
        orderId: 'ORD-003',
        dealerId: '3',
        dealerName: 'Maruthi Hardware',
        dealerEmail: 'orders@maruthi.com',
        products: [
          ProductModel(
            name: 'ShauryaTMT 12mm',
            size: '12mm',
            grade: 'Grade A',
            quantity: 100,
            unitPrice: 520,
            totalPrice: 52000,
            unit: 'tonnes',
          ),
          ProductModel(
            name: 'ShauryaTMT 16mm',
            size: '16mm',
            grade: 'Grade B',
            quantity: 60,
            unitPrice: 500,
            totalPrice: 30000,
            unit: 'tonnes',
          ),
        ],
        totalAmount: 82000,
        totalUnits: 160,
        status: 'pending',
        paymentStatus: 'partial',
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        expectedDeliveryDate: DateTime.now().add(const Duration(days: 7)),
      ),
    ];
  }

  // Fetch orders
  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get order by ID
  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Get orders by dealer
  List<OrderModel> getOrdersByDealer(String dealerId) {
    return _orders.where((o) => o.dealerId == dealerId).toList();
  }

  // Get orders by status
  List<OrderModel> getOrdersByStatus(String status) {
    return _orders.where((o) => o.status == status).toList();
  }

  // Select order
  void selectOrder(String orderId) {
    _selectedOrderId = orderId;
    notifyListeners();
  }

  // Create new order
  Future<bool> createOrder(OrderModel order) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _orders.add(order);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(status: newStatus);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Get total orders count
  int get totalOrdersCount => _orders.length;

  // Get pending orders count
  int get pendingOrdersCount =>
      _orders.where((o) => o.status == 'pending').length;

  // Get total order value
  double get totalOrderValue =>
      _orders.fold(0, (sum, order) => sum + order.totalAmount);
}
