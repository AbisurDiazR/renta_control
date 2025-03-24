import 'package:renta_control/domain/models/user_model.dart';

class Property {
  final String? id;
  final String name;
  final String address;
  final UserModel owner;

  Property({ this.id, required this.name, required this.address, required this.owner });

  Property copyWith({
    String? id,
    String? name,
    String? address,
    UserModel? owner
  }){
    return Property(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      owner: owner ?? this.owner
    );
  }
}