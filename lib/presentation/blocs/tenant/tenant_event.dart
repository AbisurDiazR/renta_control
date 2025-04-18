import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/tenant/tenant.dart';

abstract class TenantEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTenants extends TenantEvent {}

class AddTenant extends TenantEvent {
  final Tenant tenant;

  AddTenant({required this.tenant});

  @override
  List<Object> get props => [tenant];
}

class UpdateTenant extends TenantEvent {
  final Tenant tenant;

  UpdateTenant({required this.tenant});

  @override
  List<Object> get props => [tenant];
}

class SearchTenants extends TenantEvent {
  final String query;

  SearchTenants({required this.query});

  @override
  List<Object?> get props => [query];
}

class TenantsUpdated extends TenantEvent {
  final List<Tenant> tenants;

  TenantsUpdated({required this.tenants});

  @override
  List<Object> get props => [tenants];
}
