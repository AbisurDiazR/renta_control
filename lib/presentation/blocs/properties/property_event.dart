import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/user_model.dart';

abstract class PropertyEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class FetchProperties extends PropertyEvent {}

class SearchProperties extends PropertyEvent{
  final String query;

  SearchProperties({ required this.query });

  @override
  List<Object> get props => [query];
}

class AddProperty extends PropertyEvent{
  final String name;
  final String address;
  final UserModel owner;

  AddProperty({ required this.name, required this.address, required this.owner });

  @override
  List<Object> get props => [name, address, owner];
}