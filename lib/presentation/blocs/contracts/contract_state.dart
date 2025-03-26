import 'package:equatable/equatable.dart';

abstract class ContractState extends Equatable{
  @override
  List<Object> get props => [];
}

class ContractInitial extends ContractState{}

class ContractLoading extends ContractState{}

class ContractLoaded extends ContractState{}

class ContractError extends ContractState{
  final String message;

  ContractError({ required this.message });

  @override
  List<Object> get props => [message];
}

class ContractAdded extends ContractState{}

class ContractsUpdated extends ContractState{}