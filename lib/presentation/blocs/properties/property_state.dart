import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/property.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';

abstract class PropertyState extends Equatable{
  @override
  List<Object> get props => [];
}

class PropertyInitial extends PropertyState{}

class PropertyLoading extends PropertyState{}

class PropertyLoaded extends PropertyState{
  final List<Property> properties;

  PropertyLoaded({required this.properties});

  @override
  List<Object> get props => [properties];
}

class PropertyError extends PropertyState{
  final String message;

  PropertyError({required this.message});

  @override
  List<Object> get props => [message];
}

class PropertyAdded extends PropertyState{}

class PropertiesUpdated extends PropertyEvent{
  final List<Property> properties;

  PropertiesUpdated({required this.properties});

  @override
  List<Object> get props => [properties];
}