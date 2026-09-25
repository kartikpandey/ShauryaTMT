import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../providers/reward_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../utils/formatters.dart';

class RewardsLoyaltyScreen extends StatefulWidget {
  const RewardsLoyaltyScreen({super.key});

  @override
  State<RewardsLoyaltyScreen> createState() => _RewardsLoyaltyScreenState();
}

class _RewardsLoyaltyScreenState extends State<RewardsLoyaltyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<RewardProvider>().fetchRewards();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Rewards & Loyalty',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Balance Card
            Consumer<RewardProvider>(
              builder: (context, rewardProvider, _) {
                return Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.premiumGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Super Coins Balance',
                          style: AppTextStyles.bodyLarge(
                            context,
                          ).copyWith(color: Colors.white.withOpacity(0.9)),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${rewardProvider.balance.availableCoins}',
                              style: AppTextStyles.displayLarge(
                                context,
                              ).copyWith(color: Colors.white),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Redeem Now',
                                style: AppTextStyles.labelMedium(
                                  context,
                                ).copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildBalanceInfo(
                              'Total Earned',
                              '${rewardProvider.balance.totalCoins}',
                            ),
                            _buildBalanceInfo(
                              'Redeemed',
                              '${rewardProvider.balance.redeemedCoins}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Earn Steps Guide
            _buildEarnStepsGuide(context),

            // Tabs
            Container(
              margin: const EdgeInsets.only(top: 24),
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primaryOrange,
                    unselectedLabelColor: AppColors.textHint,
                    indicatorColor: AppColors.primaryOrange,
                    tabs: const [
                      Tab(text: 'Earned'),
                      Tab(text: 'Redeem'),
                      Tab(text: 'Activity'),
                    ],
                  ),
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildEarnedTab(context),
                        _buildRedeemTab(context),
                        _buildActivityTab(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall(
            context,
          ).copyWith(color: Colors.white.withOpacity(0.7)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.titleMedium(
            context,
          ).copyWith(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildEarnStepsGuide(BuildContext context) {
    return Consumer<RewardProvider>(
      builder: (context, rewardProvider, _) {
        final steps = rewardProvider.getEarnSteps();
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How to Earn Super Coins',
                style: AppTextStyles.headlineSmall(context),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    final step = steps[index];
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color:
                                  step.isCompleted
                                      ? AppColors.successGreen
                                      : AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${step.stepNumber}',
                                style: AppTextStyles.titleMedium(
                                  context,
                                ).copyWith(
                                  color:
                                      step.isCompleted
                                          ? Colors.white
                                          : AppColors.textHint,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            step.title,
                            style: AppTextStyles.labelSmall(context),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEarnedTab(BuildContext context) {
    return Consumer<RewardProvider>(
      builder: (context, rewardProvider, _) {
        final earned = rewardProvider.earnedRewards;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: earned.length,
          itemBuilder: (context, index) {
            final reward = earned[index];
            return _buildRewardItem(context, reward);
          },
        );
      },
    );
  }

  Widget _buildRedeemTab(BuildContext context) {
    return Consumer<RewardProvider>(
      builder: (context, rewardProvider, _) {
        final redeemable = rewardProvider.getRedeemableRewards();
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: redeemable.length,
          itemBuilder: (context, index) {
            final reward = redeemable[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderLight),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reward.title,
                              style: AppTextStyles.titleMedium(context),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              reward.description,
                              style: AppTextStyles.bodySmall(
                                context,
                              ).copyWith(color: AppColors.textHint),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${reward.pointsRequired} coins',
                          style: AppTextStyles.labelMedium(context).copyWith(
                            color: AppColors.primaryOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        rewardProvider.redeemReward(reward.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${reward.title} redeemed!'),
                            backgroundColor: AppColors.successGreen,
                          ),
                        );
                      },
                      child: const Text('Redeem'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActivityTab(BuildContext context) {
    return Consumer<RewardProvider>(
      builder: (context, rewardProvider, _) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: rewardProvider.rewards.length,
          itemBuilder: (context, index) {
            final reward = rewardProvider.rewards[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reward.title,
                          style: AppTextStyles.titleMedium(context),
                        ),
                        Text(
                          AppFormatters.formatRelativeTime(reward.date),
                          style: AppTextStyles.labelSmall(
                            context,
                          ).copyWith(color: AppColors.textHint),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${reward.category == 'earn' ? '+' : '-'}${reward.pointsValue}',
                    style: AppTextStyles.titleMedium(context).copyWith(
                      color:
                          reward.category == 'earn'
                              ? AppColors.successGreen
                              : AppColors.warningRed,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRewardItem(BuildContext context, dynamic reward) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reward.title, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: 4),
                Text(
                  reward.description,
                  style: AppTextStyles.bodySmall(
                    context,
                  ).copyWith(color: AppColors.textHint),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.successGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+${reward.pointsValue}',
              style: AppTextStyles.labelMedium(context).copyWith(
                color: AppColors.successGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
