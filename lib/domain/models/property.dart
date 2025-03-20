import 'package:renta_control/domain/models/user_model.dart';

class Property {
  final String name;
  final String address;
  final UserModel owner;

  Property({ required this.name, required this.address, required this.owner });
}