enum UserRole {
  admin,
  manager,
  employee,
  customer,
  user,
}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.dateJoined,
    this.createdAt,
    this.phoneNumber,
    this.password,
    this.photoUrl,
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;
  final DateTime? dateJoined;
  final DateTime? createdAt;
  final String? phoneNumber;
  final String? password;
  final String? photoUrl;
}