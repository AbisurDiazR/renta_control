import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/contract/contract_model.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_event.dart';

abstract class ContractState extends Equatable{
  @override
  List<Object> get props => [];
}

class ContractInitial extends ContractState{}

class ContractLoading extends ContractState{}

class ContractLoaded extends ContractState{
  final List<Contract> contracts;

  ContractLoaded({required this.contracts});

  @override
  List<Object> get props => [contracts];
}

class ContractError extends ContractState{
  final String message;

  ContractError({ required this.message });

  @override
  List<Object> get props => [message];
}

class ContractAdded extends ContractState{}

class ContractsUpdated extends ContractEvent{
  final List<Contract> contracts;

  ContractsUpdated({required this.contracts});

  @override
  List<Object> get props => [contracts];
}