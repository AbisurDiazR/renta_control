// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/representative/representative_repository.dart';
import 'package:renta_control/presentation/blocs/representative/representative_bloc.dart';
import 'package:renta_control/presentation/blocs/representative/representative_event.dart';
import 'package:renta_control/presentation/blocs/representative/representative_state.dart';
import 'package:renta_control/presentation/pages/representatives/add_representative_page.dart';

class RepresentativesPage extends StatelessWidget {
  const RepresentativesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => RepresentativeBloc(
            repository: RepositoryProvider.of<RepresentativeRepository>(
              context,
            ),
          )..add(FetchRepresentatives()),
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RepresentativeSearchBar(),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 80.0),
                child: BlocBuilder<RepresentativeBloc, RepresentativeState>(
                  builder: (context, state) {
                    if (state is RepresentativeLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is RepresentativeLoaded) {
                      final representatives = state.representatives;
                      return ListView.builder(
                        itemCount: representatives.length,
                        itemBuilder: (context, index) {
                          final representative = representatives[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                representative.fullName.isNotEmpty
                                    ? representative.fullName[0]
                                    : '?',
                              ),
                            ),
                            title: Text(representative.fullName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email: ${representative.email}'),
                                Text('Teléfono: ${representative.phoneNumber}'),
                                Text(
                                  'Dirección: ${representative.street} ${representative.extNumber}, ${representative.neighborhood}',
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: Text('Confirmar eliminación'),
                                        content: Text(
                                          '¿Esta seguro de que desea eliminar este fiador?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  context,
                                                  false,
                                                ),
                                            child: Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  context,
                                                  true,
                                                ),
                                            child: Text('Aceptar'),
                                          ),
                                        ],
                                      ),
                                );
                                if (confirm == true) {
                                  context.read<RepresentativeBloc>().add(
                                    DeleteRepresentative(
                                      id: representative.id!,
                                    ),
                                  );
                                }
                              },
                            ),
                            onTap: () {
                              // Navigate to the guarantor details page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => AddRepresentativePage(
                                        representative: representative,
                                      ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else if (state is RepresentativeError) {
                      return Center(
                        child: Text('Failed to load representatives'),
                      );
                    } else {
                      return Center(
                        child: Text('No representatives available'),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RepresentativeSearchBar extends StatelessWidget {
  const RepresentativeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Buscar representantes...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (query) {
        if (query.isEmpty) {
          context.read<RepresentativeBloc>().add(FetchRepresentatives());
        } else {
          context.read<RepresentativeBloc>().add(
            SearchRepresentatives(query: query),
          );
        }
      },
    );
  }
}
