import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/representative/representative_repository.dart';
import 'package:renta_control/domain/models/representative/representative.dart';
import 'package:renta_control/presentation/blocs/representative/representative_event.dart';
import 'package:renta_control/presentation/blocs/representative/representative_state.dart';

class RepresentativeBloc
    extends Bloc<RepresentativeEvent, RepresentativeState> {
  final RepresentativeRepository repository;
  StreamSubscription<List<Representative>>? _subscription;

  RepresentativeBloc({required this.repository})
    : super(RepresentativeInitial()) {
    on<FetchRepresentatives>(_onFetchRepresentatives);
    on<RepresentativesUpdated>(_onRepresentativesUpdated);
    on<AddRepresentative>(_onAddRepresentative);
    on<UpdateRepresentative>(_onUpdateRepresentative);
    on<SearchRepresentatives>(_onSearchRepresentatives);
    on<DeleteRepresentative>(_onDeleteRepresentative);
  }

  FutureOr<void> _onFetchRepresentatives(
    FetchRepresentatives event,
    Emitter<RepresentativeState> emit,
  ) {
    _subscription = repository.fetchRepresentatives().listen(
      (representatives) {
        add(RepresentativesUpdated(representatives: representatives));
      },
      onError: (error) {
        emit(
          RepresentativeError(message: 'Error loading representatives: $error'),
        );
      },
    );
  }

  FutureOr<void> _onRepresentativesUpdated(
    RepresentativesUpdated event,
    Emitter<RepresentativeState> emit,
  ) {
    emit(RepresentativeLoaded(representatives: event.representatives));
  }

  FutureOr<void> _onAddRepresentative(
    AddRepresentative event,
    Emitter<RepresentativeState> emit,
  ) {
    try {
      repository.addRepresentative(event.representative);
    } catch (e) {
      emit(RepresentativeError(message: 'Error adding representative: $e'));
    }
  }

  FutureOr<void> _onUpdateRepresentative(
    UpdateRepresentative event,
    Emitter<RepresentativeState> emit,
  ) {}

  FutureOr<void> _onSearchRepresentatives(
    SearchRepresentatives event,
    Emitter<RepresentativeState> emit,
  ) {
    final currentSate = state as RepresentativeLoaded;
    final query = event.query.toLowerCase();
    final filteredUsers =
        currentSate.representatives.where((user) {
          return user.fullName.toLowerCase().contains(query) ||
              user.email.toLowerCase().contains(query);
        }).toList();
    emit(RepresentativeLoaded(representatives: filteredUsers));
  }

  FutureOr<void> _onDeleteRepresentative(
    DeleteRepresentative event,
    Emitter<RepresentativeState> emit,
  ) {
    try {
      repository.deleteRepresentative(event.id);
      emit(RepresentativeDeleted());
    } catch (e) {
      emit(RepresentativeError(message: 'Error deleting representative: $e'));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
