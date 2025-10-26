class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
