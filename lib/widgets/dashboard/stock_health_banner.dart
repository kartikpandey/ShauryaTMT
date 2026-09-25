import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

class StockHealthBanner extends StatelessWidget {
  final String stockHealth;
  final int openOrders;

  const StockHealthBanner({
    super.key,
    required this.stockHealth,
    this.openOrders = 0,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _accentFor(stockHealth);
    final label = _labelFor(stockHealth);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_iconFor(stockHealth), color: accent, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stock Health',
                  style: AppTextStyles.labelSmall(
                    context,
                  ).copyWith(color: AppColors.textHint),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: AppTextStyles.titleMedium(
                    context,
                  ).copyWith(color: accent),
                ),
              ],
            ),
          ),
          if (openOrders > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$openOrders open',
                style: AppTextStyles.labelSmall(
                  context,
                ).copyWith(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  // Map the API stock_health string to an accent colour
  Color _accentFor(String health) {
    switch (health.toLowerCase()) {
      case 'healthy':
      case 'good':
        return AppColors.successGreen;
      case 'low':
      case 'warning':
        return AppColors.gradeBColor;
      case 'critical':
      case 'out_of_stock':
        return AppColors.warningRed;
      default:
        return AppColors.textHint;
    }
  }

  IconData _iconFor(String health) {
    switch (health.toLowerCase()) {
      case 'healthy':
      case 'good':
        return Icons.check_circle_outline;
      case 'low':
      case 'warning':
        return Icons.error_outline;
      case 'critical':
      case 'out_of_stock':
        return Icons.warning_amber_rounded;
      default:
        return Icons.help_outline;
    }
  }

  String _labelFor(String health) {
    switch (health.toLowerCase()) {
      case 'healthy':
      case 'good':
        return 'Healthy';
      case 'low':
      case 'warning':
        return 'Running Low';
      case 'critical':
      case 'out_of_stock':
        return 'Critical';
      default:
        return 'Unknown';
    }
  }
}
