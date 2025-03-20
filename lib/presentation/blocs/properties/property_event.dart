import 'package:equatable/equatable.dart';

abstract class PropertyEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class FetchProperties extends PropertyEvent {}