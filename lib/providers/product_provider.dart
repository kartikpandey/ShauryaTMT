import 'package:flutter/material.dart';
import 'dart:math';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  String _selectedGrade = 'All';
  String _selectedSize = 'All';
  final Random _random = Random();

  // Getters
  List<ProductModel> get products =>
      _filteredProducts.isEmpty ? _products : _filteredProducts;
  bool get isLoading => _isLoading;
  String get selectedGrade => _selectedGrade;
  String get selectedSize => _selectedSize;

  ProductProvider() {
    _initializeMockData();
  }

  // Initialize mock data with random products
  void _initializeMockData() {
    _isLoading = true;
    notifyListeners();

    const names = [
      'ShauryaTMT',
      'PremiumSteel',
      'StandardBar',
      'IronRod',
      'ConstructionBar',
    ];
    const sizes = ['6mm', '8mm', '10mm', '12mm', '16mm', '20mm'];
    const grades = ['Grade A', 'Grade B'];
    const units = ['tonnes', 'kg', 'units'];

    _products = List.generate(15, (index) {
      final name = names[_random.nextInt(names.length)];
      final size = sizes[_random.nextInt(sizes.length)];
      final grade = grades[_random.nextInt(grades.length)];
      final unit = units[_random.nextInt(units.length)];
      final quantity = 10.0 + _random.nextDouble() * 490;
      final unitPrice = 50.0 + _random.nextDouble() * 150;
      final totalPrice = quantity * unitPrice;

      return ProductModel(
        name: '$name $size',
        size: size,
        grade: grade,
        quantity: double.parse(quantity.toStringAsFixed(2)),
        unitPrice: double.parse(unitPrice.toStringAsFixed(2)),
        totalPrice: double.parse(totalPrice.toStringAsFixed(2)),
        unit: unit,
        addedDate: DateTime.now().subtract(Duration(days: _random.nextInt(30))),
      );
    });

    _filteredProducts = List.from(_products);
    _isLoading = false;
    notifyListeners();
  }

  // Filter products by grade and size
  void filterProducts({required String grade, required String size}) {
    _selectedGrade = grade;
    _selectedSize = size;

    _filteredProducts =
        _products.where((product) {
          final gradeMatch = grade == 'All' || product.grade == grade;
          final sizeMatch = size == 'All' || product.size == size;
          return gradeMatch && sizeMatch;
        }).toList();

    notifyListeners();
  }

  // Reset filters
  void resetFilters() {
    _selectedGrade = 'All';
    _selectedSize = 'All';
    _filteredProducts = List.from(_products);
    notifyListeners();
  }

  // Get available sizes
  List<String> getAvailableSizes() {
    return [
      'All',
      ...{..._products.map((p) => p.size)},
    ].cast<String>();
  }

  // Get available grades
  List<String> getAvailableGrades() {
    return [
      'All',
      ...{..._products.map((p) => p.grade)},
    ].cast<String>();
  }

  // Add product to cart/order (placeholder for future cart functionality)
  void addProductToCart(ProductModel product, double quantity) {
    // This can be connected to a cart provider later
    debugPrint('Added ${product.name} (qty: $quantity) to cart');
    notifyListeners();
  }
}
