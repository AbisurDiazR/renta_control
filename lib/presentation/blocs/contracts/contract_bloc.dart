import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/contract/contract_repository.dart';
import 'package:renta_control/domain/models/contract/contract_model.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_event.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_state.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  final ContractRepository repository;
  StreamSubscription<List<Contract>>? _contractsSubscription;

  ContractBloc({required this.repository}) : super(ContractInitial()) {
    on<FetchContracts>(_onFetchContracts);
    on<ContractsUpdated>(_onContractsUpdated);
    on<AddContract>(_onAddContract);
    on<UpdateContract>(_onUpdateContract);
    on<SearchContracts>(_onSearchContracts);
  }

  FutureOr<void> _onAddContract(
    AddContract event,
    Emitter<ContractState> emit,
  ) async {
    try {
      await repository.addContract(event.contract);
    } catch (e) {
      emit(ContractError(message: "Error al crear el contrato: $e"));
    }
  }

  FutureOr<void> _onFetchContracts(
    FetchContracts event,
    Emitter<ContractState> emit,
  ) async {
    emit(ContractLoading());
    await _contractsSubscription?.cancel();
    _contractsSubscription = repository.fetchContracts().listen(
      (contracts) {
        add(ContractsUpdated(contracts: contracts));
      },
      onError: (error) {
        emit(ContractError(message: 'Error al cargar contratos: $error'));
      },
    );
  }

  FutureOr<void> _onContractsUpdated(
    ContractsUpdated event,
    Emitter<ContractState> emit,
  ) {
    List<Contract> filteredContracts = event.contracts;
    emit(ContractLoaded(contracts: filteredContracts));
  }

  FutureOr<void> _onUpdateContract(
    UpdateContract event,
    Emitter<ContractState> emit,
  ) async {
    try {
      await repository.updateContract(event.contract);
    } catch (e) {
      emit(ContractError(message: 'Error al actualizar el contrato'));
    }
  }

  FutureOr<void> _onSearchContracts(
    SearchContracts event,
    Emitter<ContractState> emit,
  ) {
    if (state is ContractLoaded) {
      final currentState = state as ContractLoaded;
      final query = event.query.toLowerCase();
      final filteredContracts =
          currentState.contracts.where((contract) {
            return contract.tenant!.fullName.toLowerCase().contains(query) ||
                contract.property!.name.toLowerCase().contains(query) ||
                contract.property!.street.toLowerCase().contains(query) ||
                contract.tenant!.fullName.toLowerCase().contains(query) ||
                contract.rentalCost.toString().toLowerCase().contains(query) ||
                contract.denomination.toString().toLowerCase().contains(
                  query,
                ) ||
                contract.property!.notes.contains(query);
          }).toList();

      emit(ContractLoaded(contracts: filteredContracts));
    }
  }

  @override
  Future<void> close(){
    _contractsSubscription?.cancel();
    return super.close();
  }
}
