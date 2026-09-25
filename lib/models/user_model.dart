import 'package:uuid/uuid.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String userType; // 'distributor' or 'dealer'
  final String? companyName;
  final String? profileImageUrl;
  final String? location;
  final DateTime createdAt;
  final bool isVerified;
  final bool isBiometricEnabled;

  UserModel({
    String? id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.userType,
    this.companyName,
    this.profileImageUrl,
    this.location,
    DateTime? createdAt,
    this.isVerified = false,
    this.isBiometricEnabled = false,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phoneNumber': phoneNumber,
    'userType': userType,
    'companyName': companyName,
    'profileImageUrl': profileImageUrl,
    'location': location,
    'createdAt': createdAt.toIso8601String(),
    'isVerified': isVerified,
    'isBiometricEnabled': isBiometricEnabled,
  };

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String?,
    name: json['name'] as String,
    email: json['email'] as String,
    phoneNumber: json['phoneNumber'] as String,
    userType: json['userType'] as String,
    companyName: json['companyName'] as String?,
    profileImageUrl: json['profileImageUrl'] as String?,
    location: json['location'] as String?,
    createdAt:
        json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
    isVerified: json['isVerified'] as bool? ?? false,
    isBiometricEnabled: json['isBiometricEnabled'] as bool? ?? false,
  );

  // Copy with
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? userType,
    String? companyName,
    String? profileImageUrl,
    String? location,
    DateTime? createdAt,
    bool? isVerified,
    bool? isBiometricEnabled,
  }) => UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    userType: userType ?? this.userType,
    companyName: companyName ?? this.companyName,
    profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    location: location ?? this.location,
    createdAt: createdAt ?? this.createdAt,
    isVerified: isVerified ?? this.isVerified,
    isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
  );
}
