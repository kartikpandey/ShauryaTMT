import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../models/order_model.dart';
import '../../utils/formatters.dart';

class OrderSummaryCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;

  const OrderSummaryCard({super.key, required this.order, this.onTap});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return AppColors.successGreen;
      default:
        return AppColors.textHint;
    }
  }

  Color _getPaymentStatusColor(String status) {
    switch (status) {
      case 'paid':
        return AppColors.successGreen;
      case 'partial':
        return Colors.orange;
      case 'unpaid':
        return AppColors.warningRed;
      default:
        return AppColors.textHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.dealerName,
                          style: AppTextStyles.titleMedium(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppFormatters.formatOrderId(order.id),
                          style: AppTextStyles.labelSmall(
                            context,
                          ).copyWith(color: AppColors.textHint),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      order.status.capitalize,
                      style: AppTextStyles.labelSmall(context).copyWith(
                        color: _getStatusColor(order.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Divider
              Divider(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                height: 1,
              ),
              const SizedBox(height: 12),

              // Details Grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      context,
                      'Total Amount',
                      AppFormatters.formatCurrency(order.totalAmount),
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      context,
                      'Units',
                      '${order.totalUnits} tonnes',
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      context,
                      'Payment',
                      order.paymentStatus.capitalize,
                      isPayment: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Products Preview
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? AppColors.darkBackground
                          : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Products', style: AppTextStyles.labelMedium(context)),
                    const SizedBox(height: 8),
                    ...order.products.take(2).map((product) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${product.size} ${product.grade}',
                                style: AppTextStyles.labelSmall(context),
                              ),
                            ),
                            Text(
                              '${product.quantity.toStringAsFixed(1)} ${product.unit}',
                              style: AppTextStyles.labelSmall(
                                context,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      );
                    }),
                    if (order.products.length > 2)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '+${order.products.length - 2} more',
                          style: AppTextStyles.labelSmall(
                            context,
                          ).copyWith(color: AppColors.primaryOrange),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String value, {
    bool isPayment = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall(
            context,
          ).copyWith(color: AppColors.textHint),
        ),
        const SizedBox(height: 4),
        isPayment
            ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getPaymentStatusColor(
                  value.toLowerCase(),
                ).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value,
                style: AppTextStyles.labelSmall(context).copyWith(
                  color: _getPaymentStatusColor(value.toLowerCase()),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
            : Text(
              value,
              style: AppTextStyles.titleSmall(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
      ],
    );
  }
}

extension on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
