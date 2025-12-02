/// Audio Model
/// Represents an audio file from the API
class AudioModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String audioUrl;
  final String thumbnailUrl;
  final int durationSeconds;
  final bool isActive;
  final int sortOrder;
  final String? createdByAdmin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AudioModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.audioUrl,
    required this.thumbnailUrl,
    required this.durationSeconds,
    required this.isActive,
    required this.sortOrder,
    this.createdByAdmin,
    this.createdAt,
    this.updatedAt,
  });

  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      audioUrl: json['audioUrl'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      createdByAdmin: json['createdByAdmin']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'category': category,
      'audioUrl': audioUrl,
      'thumbnailUrl': thumbnailUrl,
      'durationSeconds': durationSeconds,
      'isActive': isActive,
      'sortOrder': sortOrder,
      'createdByAdmin': createdByAdmin,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Format duration seconds to MM:SS format
  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

