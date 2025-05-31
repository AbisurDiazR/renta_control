import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/representative/representative.dart';

abstract class RepresentativeEvent extends Equatable {
  const RepresentativeEvent();

  @override
  List<Object?> get props => [];
}

class FetchRepresentatives extends RepresentativeEvent {}

class AddRepresentative extends RepresentativeEvent {
  final Representative representative;

  const AddRepresentative({required this.representative});

  @override
  List<Object> get props => [representative];
}

class UpdateRepresentative extends RepresentativeEvent {
  final Representative representative;

  const UpdateRepresentative({required this.representative});

  @override
  List<Object> get props => [representative];
}

class SearchRepresentatives extends RepresentativeEvent {
  final String query;

  const SearchRepresentatives({required this.query});

  @override
  List<Object> get props => [query];
}

class RepresentativesUpdated extends RepresentativeEvent {
  final List<Representative> representatives;

  const RepresentativesUpdated({required this.representatives});

  @override
  List<Object> get props => [representatives];
}

class DeleteRepresentative extends RepresentativeEvent {
  final String id;

  const DeleteRepresentative({required this.id});

  @override
  List<Object> get props => [id];
}
