import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../models/dashboard_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/dashboard/dealer_card.dart';
import '../../widgets/dashboard/greeting_card.dart';
import '../../widgets/dashboard/kpi_card.dart';
import '../../widgets/dashboard/order_summary_card.dart';
import '../../widgets/dashboard/stock_health_banner.dart';
import 'product_listing_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDashboard());
    context.read<OrderProvider>().fetchOrders();
  }

  // Load dashboard data using the token captured at login
  Future<void> _loadDashboard({bool force = false}) async {
    final token = context.read<AuthProvider>().authToken;
    await context.read<DashboardProvider>().fetchDashboard(
      token: token,
      force: force,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _loadDashboard(force: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting Card
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      final user = authProvider.currentUser;
                      if (user == null) return const SizedBox.shrink();
                      return GreetingCard(user: user, isOnline: true);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Dashboard Summary
                  _buildDashboardSection(context),
                  const SizedBox(height: 24),

                  // Quick Actions
                  _buildQuickActions(context),
                  const SizedBox(height: 24),

                  // Dealers
                  _buildDealersSection(context),
                  const SizedBox(height: 24),

                  // Recent Orders Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Orders',
                        style: AppTextStyles.headlineSmall(context),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'View All',
                          style: AppTextStyles.labelMedium(
                            context,
                          ).copyWith(color: AppColors.primaryOrange),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Orders List
                  Consumer<OrderProvider>(
                    builder: (context, orderProvider, _) {
                      if (orderProvider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (orderProvider.orders.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      final recentOrders = orderProvider.orders.take(3).toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recentOrders.length,
                        itemBuilder: (context, index) {
                          final order = recentOrders[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: OrderSummaryCard(
                              order: order,
                              onTap: () {
                                orderProvider.selectOrder(order.id);
                                // Navigate to order details
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProductListingScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Dashboard summary: loading, error, or live data
  Widget _buildDashboardSection(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, _) {
        final summary = dashboardProvider.summary;

        if (summary == null) {
          if (dashboardProvider.isLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return _buildErrorCard(context, dashboardProvider.errorMessage);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stock Health Banner
            StockHealthBanner(
              stockHealth: summary.stockHealth,
              openOrders: summary.openOrders,
            ),
            const SizedBox(height: 16),

            // KPI Grid
            _buildKPISummary(context, summary),
          ],
        );
      },
    );
  }

  // KPI grid built from the API summary block
  Widget _buildKPISummary(BuildContext context, DashboardSummary summary) {
    final total = summary.totalOrders;

    // Share of the pipeline, used for the progress bars
    double share(int value) => total == 0 ? 0 : value / total;

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        KPICard(
          title: 'Open Orders',
          value: '${summary.openOrders}',
          subtitle: 'Awaiting approval',
          icon: Icons.shopping_bag_outlined,
          accentColor: AppColors.primaryOrange,
          progress: share(summary.openOrders),
        ),
        KPICard(
          title: 'Approved',
          value: '${summary.approvedOrders}',
          subtitle: 'Confirmed by dealer',
          icon: Icons.verified_outlined,
          accentColor: AppColors.successGreen,
          progress: share(summary.approvedOrders),
        ),
        KPICard(
          title: 'Pending Dispatch',
          value: '${summary.pendingDispatch}',
          subtitle: 'Ready to ship',
          icon: Icons.local_shipping_outlined,
          accentColor: AppColors.accentBlue,
          progress: share(summary.pendingDispatch),
        ),
        KPICard(
          title: 'Returns',
          value: '${summary.returns}',
          subtitle: 'Flagged for pickup',
          icon: Icons.assignment_return_outlined,
          accentColor: summary.returns > 0
              ? AppColors.warningRed
              : AppColors.textHint,
          progress: share(summary.returns),
        ),
      ],
    );
  }

  // Dealers list from the API
  Widget _buildDealersSection(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, _) {
        final dealers = dashboardProvider.dealers;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dealers',
                  style: AppTextStyles.headlineSmall(context),
                ),
                Text(
                  '${dealers.length}',
                  style: AppTextStyles.labelMedium(
                    context,
                  ).copyWith(color: AppColors.textHint),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (dealers.isEmpty)
              _buildEmptyDealers(context)
            else
              ...dealers.map(
                (dealer) => DealerCard(
                  dealer: dealer,
                  onTap: () {
                    // Navigate to dealer details
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyDealers(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Icon(Icons.people_outline, size: 32, color: AppColors.textHint),
          const SizedBox(height: 8),
          Text(
            'No dealers yet',
            style: AppTextStyles.titleSmall(context),
          ),
          const SizedBox(height: 4),
          Text(
            'Dealers will appear here once they are onboarded.',
            style: AppTextStyles.labelSmall(
              context,
            ).copyWith(color: AppColors.textHint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Error state with retry
  Widget _buildErrorCard(BuildContext context, String? message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warningRed.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Icon(Icons.cloud_off, size: 28, color: AppColors.warningRed),
          const SizedBox(height: 8),
          Text(
            message ?? 'Unable to load dashboard.',
            style: AppTextStyles.bodySmall(
              context,
            ).copyWith(color: AppColors.textDark),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _loadDashboard(force: true),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
          context,
          Icons.add_circle_outline,
          'New Order',
          AppColors.primaryOrange,
        ),
        _buildActionButton(
          context,
          Icons.assignment_outlined,
          'View Reports',
          Colors.blue,
        ),
        _buildActionButton(
          context,
          Icons.local_shipping_outlined,
          'Track Shipment',
          Colors.purple,
        ),
        _buildActionButton(
          context,
          Icons.settings_outlined,
          'Settings',
          Colors.grey,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Center(child: Icon(icon, color: color, size: 28)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.labelSmall(context),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
