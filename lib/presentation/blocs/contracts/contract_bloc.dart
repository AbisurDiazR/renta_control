import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
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
    on<AddContract>(_addContract);
  }

  FutureOr<void> _addContract(
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
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email;

    List<Contract> filteredContracts = event.contracts;

    if (userEmail != null && userEmail != 'mendozacayu3@gmail.com') {
      filteredContracts =
          event.contracts
              .where((contract) => contract.ownerEmail == userEmail)
              .toList();
    }

    emit(ContractLoaded(contracts: filteredContracts));
  }
}
