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
    );
  }
}

