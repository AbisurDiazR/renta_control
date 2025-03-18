import 'package:equatable/equatable.dart';

class UserModel extends Equatable{
  final String id;
  final String email;
  final String? name;
  final String? profileImageUrl;

  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.profileImageUrl
  });

  // Método para crear una instancia de UserModel a partir de un mapa (por ejemplo, de un JSON)
  factory UserModel.fromMap(Map<String, dynamic> map){
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['map'] as String?,
      profileImageUrl: map['profileImageUrl'] as String?,
    );
  }

  // Método para convertir una instancia de UserModel a un mapa (por ejemplo, para convertir a JSON)
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl
    };
  }

  @override
  List<Object?> get props => [id, email, name, profileImageUrl];
}