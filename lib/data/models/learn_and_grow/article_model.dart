/// Article Model
/// Represents an article from the API
class ArticleModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final String thumbnailUrl;
  final int readTimeMinutes;
  final bool isActive;
  final int sortOrder;
  final String? createdByAdmin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.thumbnailUrl,
    required this.readTimeMinutes,
    required this.isActive,
    required this.sortOrder,
    this.createdByAdmin,
    this.createdAt,
    this.updatedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      category: json['category'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      readTimeMinutes: (json['readTimeMinutes'] as num?)?.toInt() ?? 0,
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
      'content': content,
      'category': category,
      'thumbnailUrl': thumbnailUrl,
      'readTimeMinutes': readTimeMinutes,
      'isActive': isActive,
      'sortOrder': sortOrder,
      'createdByAdmin': createdByAdmin,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

