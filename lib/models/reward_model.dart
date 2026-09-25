import 'package:uuid/uuid.dart';

class RewardModel {
  final String id;
  final String title;
  final String description;
  final int pointsRequired;
  final String category; // 'redeem', 'earn'
  final DateTime date;
  final int pointsValue;
  final String? rewardImageUrl;
  final bool isRedeemed;

  RewardModel({
    String? id,
    required this.title,
    required this.description,
    required this.pointsRequired,
    required this.category,
    DateTime? date,
    required this.pointsValue,
    this.rewardImageUrl,
    this.isRedeemed = false,
  }) : id = id ?? const Uuid().v4(),
       date = date ?? DateTime.now();

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'pointsRequired': pointsRequired,
    'category': category,
    'date': date.toIso8601String(),
    'pointsValue': pointsValue,
    'rewardImageUrl': rewardImageUrl,
    'isRedeemed': isRedeemed,
  };

  // Create from JSON
  factory RewardModel.fromJson(Map<String, dynamic> json) => RewardModel(
    id: json['id'] as String?,
    title: json['title'] as String,
    description: json['description'] as String,
    pointsRequired: json['pointsRequired'] as int,
    category: json['category'] as String,
    date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
    pointsValue: json['pointsValue'] as int,
    rewardImageUrl: json['rewardImageUrl'] as String?,
    isRedeemed: json['isRedeemed'] as bool? ?? false,
  );

  // Copy with
  RewardModel copyWith({
    String? id,
    String? title,
    String? description,
    int? pointsRequired,
    String? category,
    DateTime? date,
    int? pointsValue,
    String? rewardImageUrl,
    bool? isRedeemed,
  }) => RewardModel(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    pointsRequired: pointsRequired ?? this.pointsRequired,
    category: category ?? this.category,
    date: date ?? this.date,
    pointsValue: pointsValue ?? this.pointsValue,
    rewardImageUrl: rewardImageUrl ?? this.rewardImageUrl,
    isRedeemed: isRedeemed ?? this.isRedeemed,
  );
}

class RewardBalanceModel {
  final int totalCoins;
  final int availableCoins;
  final int redeemedCoins;
  final DateTime lastUpdated;

  RewardBalanceModel({
    required this.totalCoins,
    required this.availableCoins,
    required this.redeemedCoins,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    'totalCoins': totalCoins,
    'availableCoins': availableCoins,
    'redeemedCoins': redeemedCoins,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  // Create from JSON
  factory RewardBalanceModel.fromJson(Map<String, dynamic> json) =>
      RewardBalanceModel(
        totalCoins: json['totalCoins'] as int,
        availableCoins: json['availableCoins'] as int,
        redeemedCoins: json['redeemedCoins'] as int,
        lastUpdated:
            json['lastUpdated'] != null
                ? DateTime.parse(json['lastUpdated'] as String)
                : null,
      );
}

// Step for reward progression
class RewardStepModel {
  final int stepNumber;
  final String title;
  final String description;
  final bool isCompleted;
  final String iconName; // Icon identifier for the step

  RewardStepModel({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.iconName,
  });
}
