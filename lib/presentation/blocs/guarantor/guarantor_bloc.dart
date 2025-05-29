import 'dart:async' show FutureOr, StreamSubscription;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/guarantor/guarantor_repository.dart';
import 'package:renta_control/domain/models/guarantor/guarantor.dart';
import 'package:renta_control/presentation/blocs/guarantor/guarantor_event.dart';
import 'package:renta_control/presentation/blocs/guarantor/guarantor_state.dart';

class GuarantorBloc extends Bloc<GuarantorEvent, GuarantorState> {
  final GuarantorRepository repository;
  StreamSubscription<List<Guarantor>>? _guarantorsSubscription;

  GuarantorBloc({required this.repository}) : super(GuarantorInitial()) {
    on<FetchGuarantors>(_onFetchGuarantors);
    on<GuarantorsUpdated>(_onGuarantorsUpdated);
    on<AddGuarantor>(_onAddGuarantor);
    on<UpdateGuarantor>(_onUpdateGuarantor);
    on<DeleteGuarantor>(_onDeleteGuarantor);
    on<SearchGuarantors>(_onSearchGuarantors);
  }

  FutureOr<void> _onFetchGuarantors(
    FetchGuarantors event,
    Emitter<GuarantorState> emit,
  ) {
    _guarantorsSubscription = repository.fetchGuarantors().listen(
      (guarantors) {
        add(GuarantorsUpdated(guarantors: guarantors));
      },
      onError: (error) {
        emit(GuarantorError(message: 'Error al cargar garantes: $error'));
      },
    );
  }

  FutureOr<void> _onGuarantorsUpdated(
    GuarantorsUpdated event,
    Emitter<GuarantorState> emit,
  ) {
    emit(GuarantorLoaded(guarantors: event.guarantors));
  }

  FutureOr<void> _onAddGuarantor(
    AddGuarantor event,
    Emitter<GuarantorState> emit,
  ) async {
    try {
      await repository.addGuarantor(event.guarantor);
      emit(GuarantorAdded());
    } catch (e) {
      emit(GuarantorError(message: 'Error al agregar garante: $e'));
    }
  }

  FutureOr<void> _onUpdateGuarantor(
    UpdateGuarantor event,
    Emitter<GuarantorState> emit,
  ) async {
    try {
      await repository.updateGuarantor(event.guarantor);
      emit(GuarantorUpdated());
    } catch (e) {
      emit(GuarantorError(message: 'Error al actualizar garante: $e'));
    }
  }

  FutureOr<void> _onSearchGuarantors(
    SearchGuarantors event,
    Emitter<GuarantorState> emit,
  ) {
    final currentState = state as GuarantorLoaded;
    final query = event.query.toLowerCase();
    final filteredGuarantors =
        currentState.guarantors.where((guarantor) {
          return guarantor.fullName.toLowerCase().contains(query) ||
              guarantor.phoneNumber.toLowerCase().contains(query) ||
              guarantor.email.toLowerCase().contains(query);
        }).toList();
    emit(GuarantorLoaded(guarantors: filteredGuarantors));
  }

  FutureOr<void> _onDeleteGuarantor(
    DeleteGuarantor event,
    Emitter<GuarantorState> emit,
  ) async {
    try {
      await repository.deleteGuarantor(event.guarantorId);
      if (state is GuarantorDeleted) {
        final currentState = state as GuarantorDeleted;
        final updatedGuarantors =
            currentState.guarantors
                .where((guarantor) => guarantor.id != event.guarantorId)
                .toList();
        emit(GuarantorDeleted(guarantors: updatedGuarantors));
      }
    } catch (e) {
      emit(GuarantorError(message: 'Error al eliminar al fiador: $e'));
    }
  }

  @override
  Future<void> close() {
    _guarantorsSubscription?.cancel();
    return super.close();
  }
}
