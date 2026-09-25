import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/dashboard/product_card.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  late ScrollController _scrollController;
  bool _showFilterBar = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 50) {
      if (_showFilterBar) {
        setState(() => _showFilterBar = false);
      }
    } else {
      if (!_showFilterBar) {
        setState(() => _showFilterBar = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Products'),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          return Column(
            children: [
              // Filter Bar
              if (_showFilterBar) _buildFilterBar(context, productProvider),

              // Products Grid
              Expanded(
                child:
                    productProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : productProvider.products.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No products found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                        : GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: productProvider.products.length,
                          itemBuilder: (context, index) {
                            final product = productProvider.products[index];
                            return ProductCard(
                              product: product,
                              onAddToCart: () {
                                _showAddToCartDialog(
                                  context,
                                  product,
                                  productProvider,
                                );
                              },
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterBar(
    BuildContext context,
    ProductProvider productProvider,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: AppTextStyles.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  'Grade',
                  productProvider.getAvailableGrades(),
                  productProvider.selectedGrade,
                  (selected) {
                    productProvider.filterProducts(
                      grade: selected,
                      size: productProvider.selectedSize,
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Size',
                  productProvider.getAvailableSizes(),
                  productProvider.selectedSize,
                  (selected) {
                    productProvider.filterProducts(
                      grade: productProvider.selectedGrade,
                      size: selected,
                    );
                  },
                ),
                const SizedBox(width: 8),
                if (productProvider.selectedGrade != 'All' ||
                    productProvider.selectedSize != 'All')
                  TextButton.icon(
                    icon: const Icon(Icons.clear, size: 18),
                    label: const Text('Clear'),
                    onPressed: () => productProvider.resetFilters(),
                  ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              'Showing ${productProvider.products.length} products',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    List<String> options,
    String selected,
    Function(String) onSelected,
  ) {
    return Wrap(
      spacing: 4,
      children:
          options
              .map(
                (option) => FilterChip(
                  label: Text(option),
                  selected: selected == option,
                  onSelected: (isSelected) {
                    if (isSelected) {
                      onSelected(option);
                    }
                  },
                  backgroundColor: AppColors.primaryLight,
                  selectedColor: AppColors.primaryOrange.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color:
                        selected == option
                            ? AppColors.primaryOrange
                            : AppColors.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color:
                          selected == option
                              ? AppColors.primaryOrange
                              : AppColors.borderLight,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  void _showAddToCartDialog(
    BuildContext context,
    ProductModel product,
    ProductProvider productProvider,
  ) {
    int quantity = 1;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(product.name),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grade: ${product.grade}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Available: ${product.quantity} ${product.unit}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Price per unit: ₹${product.unitPrice}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Quantity:'),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed:
                            quantity > 1
                                ? () {
                                  setState(() => quantity--);
                                }
                                : null,
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() => quantity++);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:'),
                        Text(
                          '₹${(product.unitPrice * quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    productProvider.addProductToCart(
                      product,
                      quantity.toDouble(),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${product.name} (qty: $quantity) added to cart',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Add to Cart'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
