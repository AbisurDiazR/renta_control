import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/contract/contract_model.dart';

abstract class ContractEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchContracts extends ContractEvent {}

class SearchContracts extends ContractEvent {
  final String query;

  SearchContracts({required this.query});

  @override
  List<Object> get props => [query];
}

class AddContract extends ContractEvent {
  final Contract contract;
  
  AddContract({required this.contract});

  @override
  List<Object> get props => [contract];
}

class UpdateContract extends ContractEvent {
  final Contract contract;

  UpdateContract({required this.contract});

  @override
  List<Object> get props => [contract];
}
