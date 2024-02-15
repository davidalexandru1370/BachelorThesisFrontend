import '../../enums/authentication_type.dart';
import '../../enums/role.dart';
import '../abstract/serializable_entity.dart';

class UserProfile extends SerializableEntity {
  final String email;
  final Role role;
  final AuthenticationType authenticationType;

  UserProfile(this.email, this.role, this.authenticationType);

  @override
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role.toString(),
      'authenticationType': authenticationType
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      map['email'],
      Role.values.firstWhere((e) => e.index == map['role']),
      AuthenticationType.values.firstWhere((e) => e.index == map['authenticationType']),
    );
  }
}
