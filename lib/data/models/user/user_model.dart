/// User Model
/// Represents user data from the API
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? token;
  final String? avatar;
  final int? age;
  final List<String>? focusAreas;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? hasCompletedAssessment;
  final String? currentSubscriptionType;
  final DateTime? assessmentCompletedAt;
  final DateTime? lastLogin;
  final bool? coachingOfferEligible;
  final DateTime? coachingOfferTriggeredAt;
  final int? completedGoalsCount;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    this.avatar,
    this.age,
    this.focusAreas,
    this.createdAt,
    this.updatedAt,
    this.hasCompletedAssessment,
    this.currentSubscriptionType,
    this.assessmentCompletedAt,
    this.lastLogin,
    this.coachingOfferEligible,
    this.coachingOfferTriggeredAt,
    this.completedGoalsCount,
  });

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      token: json['token'] as String?,
      avatar: json['avatar'] as String?,
      age: json['age'] as int?,
      focusAreas: json['focusAreas'] != null
          ? (json['focusAreas'] as List<dynamic>)
              .map((e) => e.toString())
              .toList()
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      hasCompletedAssessment: json['hasCompletedAssessment'] as bool? ?? false,
      currentSubscriptionType: json['currentSubscriptionType'] as String?,
      assessmentCompletedAt: json['assessmentCompletedAt'] != null
          ? DateTime.tryParse(json['assessmentCompletedAt'].toString())
          : null,
      lastLogin: json['lastLogin'] != null
          ? DateTime.tryParse(json['lastLogin'].toString())
          : null,
      coachingOfferEligible: json['coachingOfferEligible'] as bool? ?? false,
      coachingOfferTriggeredAt: json['coachingOfferTriggeredAt'] != null
          ? DateTime.tryParse(json['coachingOfferTriggeredAt'].toString())
          : null,
      completedGoalsCount: json['completedGoalsCount'] as int? ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'avatar': avatar,
      'age': age,
      'focusAreas': focusAreas,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'hasCompletedAssessment': hasCompletedAssessment,
      'currentSubscriptionType': currentSubscriptionType,
      'assessmentCompletedAt': assessmentCompletedAt?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'coachingOfferEligible': coachingOfferEligible,
      'coachingOfferTriggeredAt': coachingOfferTriggeredAt?.toIso8601String(),
      'completedGoalsCount': completedGoalsCount,
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
    String? avatar,
    int? age,
    List<String>? focusAreas,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? hasCompletedAssessment,
    String? currentSubscriptionType,
    DateTime? assessmentCompletedAt,
    DateTime? lastLogin,
    bool? coachingOfferEligible,
    DateTime? coachingOfferTriggeredAt,
    int? completedGoalsCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      avatar: avatar ?? this.avatar,
      age: age ?? this.age,
      focusAreas: focusAreas ?? this.focusAreas,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hasCompletedAssessment: hasCompletedAssessment ?? this.hasCompletedAssessment,
      currentSubscriptionType: currentSubscriptionType ?? this.currentSubscriptionType,
      assessmentCompletedAt: assessmentCompletedAt ?? this.assessmentCompletedAt,
      lastLogin: lastLogin ?? this.lastLogin,
      coachingOfferEligible: coachingOfferEligible ?? this.coachingOfferEligible,
      coachingOfferTriggeredAt: coachingOfferTriggeredAt ?? this.coachingOfferTriggeredAt,
      completedGoalsCount: completedGoalsCount ?? this.completedGoalsCount,
    );
  }
}

