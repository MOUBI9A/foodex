import 'package:equatable/equatable.dart';

enum UserRole { customer, chef, driver, admin }

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? profileImage;
  final UserRole role;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isEmailVerified;
  final bool isPhoneVerified;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.profileImage,
    required this.role,
    required this.createdAt,
    this.updatedAt,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? profileImage,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    bool? isPhoneVerified,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phone,
        profileImage,
        role,
        createdAt,
        updatedAt,
        isEmailVerified,
        isPhoneVerified,
      ];
}
