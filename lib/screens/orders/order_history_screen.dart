import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../providers/order_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/dashboard/order_summary_card.dart';
import '../../utils/formatters.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String _selectedFilter = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<OrderProvider>().fetchOrders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Order History', showBackButton: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search orders, dealers...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon:
                      _searchController.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                          : null,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('all', 'All Orders'),
                    const SizedBox(width: 8),
                    _buildFilterChip('pending', 'Pending'),
                    const SizedBox(width: 8),
                    _buildFilterChip('confirmed', 'Confirmed'),
                    const SizedBox(width: 8),
                    _buildFilterChip('shipped', 'Shipped'),
                    const SizedBox(width: 8),
                    _buildFilterChip('delivered', 'Delivered'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Orders List
              Consumer<OrderProvider>(
                builder: (context, orderProvider, _) {
                  List orders = orderProvider.orders;

                  if (_selectedFilter != 'all') {
                    orders = orderProvider.getOrdersByStatus(_selectedFilter);
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: OrderSummaryCard(
                          order: orders[index],
                          onTap: () {
                            orderProvider.selectOrder(orders[index].id);
                            _showOrderDetailBottomSheet(context, orders[index]);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFilter == value,
      onSelected: (_) {
        setState(() => _selectedFilter = value);
      },
      backgroundColor: AppColors.primaryLight,
      selectedColor: AppColors.primaryOrange.withOpacity(0.2),
      labelStyle: TextStyle(
        color:
            _selectedFilter == value
                ? AppColors.primaryOrange
                : AppColors.textHint,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color:
              _selectedFilter == value
                  ? AppColors.primaryOrange
                  : AppColors.borderLight,
        ),
      ),
    );
  }

  void _showOrderDetailBottomSheet(BuildContext context, dynamic order) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Details',
                  style: AppTextStyles.headlineSmall(context),
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Order ID',
                  AppFormatters.formatOrderId(order.id),
                ),
                _buildDetailRow('Dealer', order.dealerName),
                _buildDetailRow('Status', order.status.toUpperCase()),
                _buildDetailRow(
                  'Total',
                  AppFormatters.formatCurrency(order.totalAmount),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium(context)),
          Text(value, style: AppTextStyles.titleMedium(context)),
        ],
      ),
    );
  }
}
