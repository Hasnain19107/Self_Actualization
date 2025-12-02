/// Achievement Model
/// Represents achievement data from the API
class AchievementModel {
  final int totalPoints;
  final CurrentBadge currentBadge;
  final BadgeProgress badgeProgress;
  final int focusStreak;
  final ActivityCounts activityCounts;
  final List<UnlockedAchievement> unlockedAchievements;

  AchievementModel({
    required this.totalPoints,
    required this.currentBadge,
    required this.badgeProgress,
    required this.focusStreak,
    required this.activityCounts,
    required this.unlockedAchievements,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      currentBadge: CurrentBadge.fromJson(
        json['currentBadge'] as Map<String, dynamic>? ?? {},
      ),
      badgeProgress: BadgeProgress.fromJson(
        json['badgeProgress'] as Map<String, dynamic>? ?? {},
      ),
      focusStreak: (json['focusStreak'] as num?)?.toInt() ?? 0,
      activityCounts: ActivityCounts.fromJson(
        json['activityCounts'] as Map<String, dynamic>? ?? {},
      ),
      unlockedAchievements: (json['unlockedAchievements'] as List<dynamic>?)
              ?.map((item) => UnlockedAchievement.fromJson(
                    item as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPoints': totalPoints,
      'currentBadge': currentBadge.toJson(),
      'badgeProgress': badgeProgress.toJson(),
      'focusStreak': focusStreak,
      'activityCounts': activityCounts.toJson(),
      'unlockedAchievements':
          unlockedAchievements.map((item) => item.toJson()).toList(),
    };
  }
}

class CurrentBadge {
  final int level;
  final String name;

  CurrentBadge({
    required this.level,
    required this.name,
  });

  factory CurrentBadge.fromJson(Map<String, dynamic> json) {
    return CurrentBadge(
      level: (json['level'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'name': name,
    };
  }
}

class BadgeProgress {
  final int currentPoints;
  final int nextBadgeLevel;
  final String nextBadgeName;
  final int pointsRequired;
  final int pointsToNext;
  final int progressPercentage;

  BadgeProgress({
    required this.currentPoints,
    required this.nextBadgeLevel,
    required this.nextBadgeName,
    required this.pointsRequired,
    required this.pointsToNext,
    required this.progressPercentage,
  });

  factory BadgeProgress.fromJson(Map<String, dynamic> json) {
    return BadgeProgress(
      currentPoints: (json['currentPoints'] as num?)?.toInt() ?? 0,
      nextBadgeLevel: (json['nextBadgeLevel'] as num?)?.toInt() ?? 0,
      nextBadgeName: json['nextBadgeName'] as String? ?? '',
      pointsRequired: (json['pointsRequired'] as num?)?.toInt() ?? 0,
      pointsToNext: (json['pointsToNext'] as num?)?.toInt() ?? 0,
      progressPercentage: (json['progressPercentage'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPoints': currentPoints,
      'nextBadgeLevel': nextBadgeLevel,
      'nextBadgeName': nextBadgeName,
      'pointsRequired': pointsRequired,
      'pointsToNext': pointsToNext,
      'progressPercentage': progressPercentage,
    };
  }
}

class ActivityCounts {
  final int assessmentsCompleted;
  final int goalsCompleted;
  final int reflectionsCreated;
  final int daysActive;

  ActivityCounts({
    required this.assessmentsCompleted,
    required this.goalsCompleted,
    required this.reflectionsCreated,
    required this.daysActive,
  });

  factory ActivityCounts.fromJson(Map<String, dynamic> json) {
    return ActivityCounts(
      assessmentsCompleted:
          (json['assessmentsCompleted'] as num?)?.toInt() ?? 0,
      goalsCompleted: (json['goalsCompleted'] as num?)?.toInt() ?? 0,
      reflectionsCreated: (json['reflectionsCreated'] as num?)?.toInt() ?? 0,
      daysActive: (json['daysActive'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assessmentsCompleted': assessmentsCompleted,
      'goalsCompleted': goalsCompleted,
      'reflectionsCreated': reflectionsCreated,
      'daysActive': daysActive,
    };
  }
}

class UnlockedAchievement {
  final String id;
  final String name;
  final String description;
  final String? iconUrl;
  final DateTime? unlockedAt;

  UnlockedAchievement({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    this.unlockedAt,
  });

  factory UnlockedAchievement.fromJson(Map<String, dynamic> json) {
    return UnlockedAchievement(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconUrl: json['iconUrl'] as String?,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.tryParse(json['unlockedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }
}

