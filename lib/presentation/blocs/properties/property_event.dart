import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/property/property.dart';

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
  final Property property;

  AddProperty({ required this.property });

  @override
  List<Object> get props => [property];
}

class UpdateProperty extends PropertyEvent{
  final Property property;

  UpdateProperty({ required this.property });

  @override
  List<Object> get props => [property];
}