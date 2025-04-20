import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/tenant/tenant_repository.dart';
import 'package:renta_control/presentation/blocs/tenant/tenant_bloc.dart';
import 'package:renta_control/presentation/blocs/tenant/tenant_event.dart';
import 'package:renta_control/presentation/blocs/tenant/tenant_state.dart';
import 'package:renta_control/presentation/pages/tenants/add_tenant.dart';

class TenantsPage extends StatelessWidget {
  const TenantsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => TenantBloc(
            repository: RepositoryProvider.of<TenantRepository>(context),
          )..add(FetchTenants()),
      child: Scaffold(
        body: Column(
          children: [
            Padding(padding: EdgeInsets.all(8.0), child: TenantSearchBar()),
            Expanded(
              child: BlocBuilder<TenantBloc, TenantState>(
                builder: (context, state) {
                  if (state is TenantLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TenantLoaded) {
                    return ListView.builder(
                      itemCount: state.tenants.length,
                      itemBuilder: (context, index) {
                        final tenant = state.tenants[index];
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(
                            tenant.fullName,
                          ), // Replace with tenant name
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email: ${tenant.email}'),
                              Text('Teléfono: ${tenant.phone}'),
                              Text(
                                'Dirección: ${tenant.street} ${tenant.extNumber}, ${tenant.neighborhood}',
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AddTenantPage(tenant: tenant),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is TenantError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const Center(child: Text('No tenants available.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TenantSearchBar extends StatelessWidget {
  const TenantSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar inquilinos...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (query) {
        if (query.isEmpty) {
          context.read<TenantBloc>().add(FetchTenants());
        } else {
          context.read<TenantBloc>().add(SearchTenants(query: query));
        }
      },
    );
  }
}
