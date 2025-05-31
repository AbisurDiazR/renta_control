import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/representative/representative.dart';

abstract class RepresentativeState extends Equatable {
  const RepresentativeState();

  @override
  List<Object?> get props => [];
}

class RepresentativeInitial extends RepresentativeState {}

class RepresentativeLoading extends RepresentativeState {}

class RepresentativeLoaded extends RepresentativeState {
  final List<Representative> representatives;

  const RepresentativeLoaded({required this.representatives});

  @override
  List<Object?> get props => [representatives];
}

class RepresentativeError extends RepresentativeState {
  final String message;

  const RepresentativeError({required this.message});

  @override
  List<Object?> get props => [message];
}

class RepresentativeUpdated extends RepresentativeState {}

class RepresentativeAdded extends RepresentativeState {}

class RepresentativeDeleted extends RepresentativeState {}
