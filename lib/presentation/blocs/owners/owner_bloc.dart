import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/owner/owner_repository.dart';
import 'package:renta_control/domain/models/owner/owner_model.dart';
import 'package:renta_control/presentation/blocs/owners/owner_event.dart';
import 'package:renta_control/presentation/blocs/owners/owner_state.dart';

class OwnerBloc extends Bloc<OwnerEvent, OwnerState> {
  final OwnerRepository repository;
  StreamSubscription<List<OwnerModel>>? _ownersSubscription;

  OwnerBloc({required this.repository}) : super(OwnerInitial()) {
    on<FetchOwners>(_onFetchOwners);
    on<OwnersUpdated>(_onOwnersUpdated);
    on<AddOwner>(_onAddOwner);
    on<UpdateOwner>(_onUpdateOwner);
    on<SearchOwners>(_onSearchOwners);
  }

  FutureOr<void> _onFetchOwners(
    FetchOwners event,
    Emitter<OwnerState> emit,
  ) async {
    emit(OwnerLoading());
    await _ownersSubscription?.cancel();
    _ownersSubscription = repository.fetchOwners().listen(
      (owners) {
        add(OwnersUpdated(owners: owners));
      },
      onError: (error) {
        emit(OwnerError(message: 'Error al cargar propiedades: $error'));
      },
    );
  }

  void _onOwnersUpdated(OwnersUpdated event, Emitter<OwnerState> emit) {
    List<OwnerModel> filteredOwners = event.owners;

    emit(OwnerLoaded(owners: filteredOwners));
  }

  FutureOr<void> _onAddOwner(AddOwner event, Emitter<OwnerState> emit) async {
    try {
      final newOwner = OwnerModel(
        name: event.owner.name,
        email: event.owner.email,
        phone: event.owner.phone,
        street: event.owner.street,
        extNumber: event.owner.extNumber,
        neighborhood: event.owner.neighborhood,
        borough: event.owner.borough,
        city: event.owner.city,
        state: event.owner.state,
        zipCode: event.owner.zipCode,
      );
      await repository.addOwner(newOwner);
    } catch (e) {
      emit(OwnerError(message: 'Error al cargar la propiedad: $e'));
    }
  }

  FutureOr<void> _onUpdateOwner(
    UpdateOwner event,
    Emitter<OwnerState> emit,
  ) async {
    try {
      await repository.updateOwner(event.owner);
    } catch (e) {
      emit(OwnerError(message: 'Error al actualizar la propiedad: $e'));
    }
  }

  FutureOr<void> _onSearchOwners(SearchOwners event, Emitter<OwnerState> emit) {
    if (state is OwnerLoaded) {
      final currentState = state as OwnerLoaded;
      final query = event.query.toLowerCase();
      final filteredOwners =
          currentState.owners.where((owner) {
            return owner.name.toLowerCase().contains(query) ||
                owner.street.contains(query) ||
                owner.zipCode.contains(query);
          }).toList();
      emit(OwnerLoaded(owners: filteredOwners));
    }
  }

  @override
  Future<void> close() {
    _ownersSubscription?.cancel();
    return super.close();
  }
}
