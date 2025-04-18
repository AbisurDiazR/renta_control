import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/tenant/tenant.dart';

abstract class TenantState extends Equatable{
  @override
  List<Object?> get props => [];
}

class TenantInitial extends TenantState{}

class TenantLoading extends TenantState{}

class TenantLoaded extends TenantState{
  final List<Tenant> tenants;

  TenantLoaded({required this.tenants});

  @override
  List<Object> get props => [tenants];
}

class TenantError extends TenantState{
  final String message;

  TenantError({required this.message});

  @override
  List<Object> get props => [message];
}

class TenantUpdated extends TenantState{}

class TenantAdded extends TenantState{}