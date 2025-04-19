import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/tenant/tenant_repository.dart';
import 'package:renta_control/domain/models/tenant/tenant.dart';
import 'package:renta_control/presentation/blocs/tenant/tenant_event.dart';
import 'package:renta_control/presentation/blocs/tenant/tenant_state.dart';

class TenantBloc extends Bloc<TenantEvent, TenantState> {
  final TenantRepository repository;
  StreamSubscription<List<Tenant>>? _tenantsSubscription;

  TenantBloc({required this.repository}) : super(TenantInitial()) {
    on<FetchTenants>(_onFetchTenants);
    on<TenantsUpdated>(_onTenantsUpdated);
    on<AddTenant>(_onAddTenant);
    on<UpdateTenant>(_onUpdateTenant);
    on<SearchTenants>(_onSearchTenants);
  }

  FutureOr<void> _onFetchTenants(
    FetchTenants event,
    Emitter<TenantState> emit,
  ) async {
    _tenantsSubscription = repository.fetchTenants().listen(
      (tenants) {
        add(TenantsUpdated(tenants: tenants));
      },
      onError: (error) {
        emit(TenantError(message: 'Error al cargar inquilinos: $error'));
      },
    );
  }

  FutureOr<void> _onTenantsUpdated(
    TenantsUpdated event,
    Emitter<TenantState> emit,
  ) {
    emit(TenantLoaded(tenants: event.tenants));
  }

  FutureOr<void> _onAddTenant(
    AddTenant event,
    Emitter<TenantState> emit,
  ) async {
    try {
      await repository.addTenant(event.tenant);
    } catch (e) {
      emit(TenantError(message: 'Error al agregar inquilino: $e'));
    }
  }

  FutureOr<void> _onUpdateTenant(
    UpdateTenant event,
    Emitter<TenantState> emit,
  ) async {
    try {
      await repository.updateTenant(event.tenant);
    } catch (e) {
      emit(TenantError(message: 'Error al actualizar inquilino: $e'));
    }
  }

  FutureOr<void> _onSearchTenants(
    SearchTenants event,
    Emitter<TenantState> emit,
  ) {
    final currentState = state as TenantLoaded;
    final query = event.query.toLowerCase();
    final filteredTenants =
        currentState.tenants.where((tenant) {
          return tenant.fullName.toLowerCase().contains(query) ||
              tenant.street.toLowerCase().contains(query) ||
              tenant.zipCode.contains(query);
        }).toList();
    emit(TenantLoaded(tenants: filteredTenants));
  }

  @override
  Future<void> close() {
    _tenantsSubscription?.cancel();
    return super.close();
  }
}
