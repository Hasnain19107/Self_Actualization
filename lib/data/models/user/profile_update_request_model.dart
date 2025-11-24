/// Profile Update Request Model
/// Payload sent when updating the user's profile information.
class ProfileUpdateRequestModel {
  final String name;
  final int age;
  final List<String> focusAreas;
  final String avatar;

  ProfileUpdateRequestModel({
    required this.name,
    required this.age,
    required this.focusAreas,
    required this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'focusAreas': focusAreas,
      'avatar': avatar,
    };
  }
}

