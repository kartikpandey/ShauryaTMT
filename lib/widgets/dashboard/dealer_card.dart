import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

/// Renders a dealer object without assuming a fixed schema. Known keys are used
/// for the title/subtitle when present, and every remaining scalar field is
/// surfaced as a stat chip, so new API fields show up without code changes.
class DealerCard extends StatelessWidget {
  final Map<String, dynamic> dealer;
  final VoidCallback? onTap;

  const DealerCard({super.key, required this.dealer, this.onTap});

  // Keys consumed by the title/subtitle, excluded from the stat chips
  static const _nameKeys = [
    'name',
    'dealer_name',
    'dealerName',
    'company_name',
    'companyName',
    'firm_name',
    'title',
  ];
  static const _subtitleKeys = [
    'location',
    'city',
    'address',
    'area',
    'email',
    'phone',
    'mobile',
    'gstin',
    'gst_number',
    'status',
  ];
  static const _idKeys = ['id', 'dealer_id', 'dealerId', 'uuid'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = _first(_nameKeys) ?? _firstString() ?? 'Dealer';
    final subtitle = _first(_subtitleKeys);
    final stats = _stats();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _initials(title),
                      style: AppTextStyles.labelLarge(context).copyWith(
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title + subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.titleSmall(context).copyWith(
                            color: isDark
                                ? AppColors.textLight
                                : AppColors.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle ?? 'No additional details',
                          style: AppTextStyles.labelSmall(
                            context,
                          ).copyWith(color: AppColors.textHint),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Remaining fields as stat chips
              if (stats.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: stats.map((s) => _StatChip(label: s.$1, value: s.$2)).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ---- Helpers ----

  // First non-empty string value for any of the given keys
  String? _first(List<String> keys) {
    for (final key in keys) {
      final value = dealer[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }

  // Any string value, used as a title fallback for unknown schemas
  String? _firstString() {
    for (final entry in dealer.entries) {
      final value = entry.value;
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }

  // Every remaining scalar field, humanised for display
  List<(String, String)> _stats() {
    final stats = <(String, String)>[];

    for (final entry in dealer.entries) {
      final key = entry.key;
      if (_idKeys.contains(key)) continue;
      if (_nameKeys.contains(key) || _subtitleKeys.contains(key)) continue;

      final value = entry.value;
      if (value is num) {
        stats.add((_humanise(key), value.toString()));
      } else if (value is bool) {
        stats.add((_humanise(key), value ? 'Yes' : 'No'));
      }
    }

    return stats;
  }

  // 'open_orders' -> 'Open Orders', 'totalOrders' -> 'Total Orders'
  String _humanise(String key) {
    final words = key
        .replaceAll(RegExp(r'[_\-]+'), ' ')
        .replaceAll(RegExp(r'([a-z0-9])([A-Z])'), r'$1 $2')
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return key;
    return words
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTextStyles.numericSmall(context).copyWith(
              color: AppColors.primaryOrange,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall(
              context,
            ).copyWith(color: AppColors.textHint, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
