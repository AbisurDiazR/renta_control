import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/owner/owner_model.dart';

abstract class OwnerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchOwners extends OwnerEvent {}

class SearchOwners extends OwnerEvent {
  final String query;

  SearchOwners({required this.query});

  @override
  List<Object> get props => [query];
}

class AddOwner extends OwnerEvent {
  final OwnerModel owner;

  AddOwner({required this.owner});

  @override
  List<Object> get props => [owner];
}

class UpdateOwner extends OwnerEvent {
  final OwnerModel owner;

  UpdateOwner({required this.owner});

  @override
  List<Object> get props => [owner];
}
