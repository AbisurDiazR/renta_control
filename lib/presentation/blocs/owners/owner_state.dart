import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/owner/owner_model.dart';
import 'package:renta_control/presentation/blocs/owners/owner_event.dart';

abstract class OwnerState extends Equatable{
  @override
  List<Object> get props => [];
}

class OwnerInitial extends OwnerState{}

class OwnerLoading extends OwnerState{}

class OwnerLoaded extends OwnerState{
  final List<OwnerModel> owners;

  OwnerLoaded({required this.owners});

  @override
  List<Object> get props => [owners];
}

class OwnerError extends OwnerState{
  final String message;

  OwnerError({required this.message});

  @override
  List<Object> get props => [message];
}

class OwnerAdded extends OwnerState{}

class OwnersUpdated extends OwnerEvent{
  final List<OwnerModel> owners;

  OwnersUpdated({required this.owners});

  @override
  List<Object> get props => [owners];
}