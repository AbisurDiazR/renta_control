import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/contract_repository.dart';
import 'package:renta_control/domain/models/contract_model.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_event.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_state.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  final ContractRepository repository;

  ContractBloc({required this.repository}) : super(ContractInitial()) {
    on<AddContract>(_addContract);
  }

  FutureOr<void> _addContract(
    AddContract event,
    Emitter<ContractState> emit,
  ) async {
    try {
      final newContract = Contract(
        id: event.contract.id,
        owner: event.contract.owner,
        contractType: event.contract.contractType,
        nombre: event.contract.nombre,
        rfc: event.contract.rfc,
        telefono: event.contract.telefono,
        domicilio: event.contract.domicilio,
        colonia: event.contract.colonia,
        alcaldia: event.contract.alcaldia,
        ciudad: event.contract.ciudad,
        codigoPostal: event.contract.codigoPostal,
        estado: event.contract.estado,
        pais: event.contract.pais,
      );
      await repository.addContract(newContract);
    } catch (e) {
      emit(ContractError(message: "Error al crear el contrato: $e"));
    }
  }
}
