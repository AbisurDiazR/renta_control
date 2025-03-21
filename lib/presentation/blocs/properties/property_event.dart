import 'package:equatable/equatable.dart';

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