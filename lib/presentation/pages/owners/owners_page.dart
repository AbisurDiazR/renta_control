// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/owner/owner_repository.dart';
import 'package:renta_control/presentation/blocs/owners/owner_bloc.dart';
import 'package:renta_control/presentation/blocs/owners/owner_event.dart';
import 'package:renta_control/presentation/blocs/owners/owner_state.dart';
import 'package:renta_control/presentation/pages/owners/add_owner_page.dart';
import 'package:renta_control/presentation/pages/owners/owner_properties_list.dart';

class OwnerPage extends StatelessWidget {
  const OwnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => OwnerBloc(
            repository: RepositoryProvider.of<OwnerRepository>(context),
          )..add(FetchOwners()),
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(8.0), child: OwnerSearchBar()),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 80.0),
              child: BlocBuilder<OwnerBloc, OwnerState>(
                builder: (context, state) {
                  if (state is OwnerLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is OwnerLoaded) {
                    if (state.owners.isEmpty) {
                      return const Center(
                        child: Text('No hay propietarios disponibles'),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.owners.length,
                      itemBuilder: (context, index) {
                        final owner = state.owners[index];
                        return ListTile(
                          visualDensity: VisualDensity(vertical: 4),
                          leading: CircleAvatar(
                            child: Text(
                              owner.name.isNotEmpty ? owner.name[0] : '?',
                            ),
                          ),
                          title: Text(
                            owner.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Correo: ${owner.email}'),
                              Text('Teléfono: ${owner.phone}'),
                              Text(
                                'Dirección: ${owner.street} ${owner.extNumber}'
                                '${owner.intNumber != null ? ' Int. ${owner.intNumber}' : ''}, '
                                '${owner.neighborhood}, ${owner.borough}, ${owner.city}, ${owner.state}, C.P. ${owner.zipCode}',
                              ),
                            ],
                          ),
                          trailing: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_red_eye),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => OwnerPropertiesList(
                                              owner: owner,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text(
                                              'Confirmar eliminación',
                                            ),
                                            content: Text(
                                              '¿Esta seguro de que desea eliminar este propietario?',
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
                                      context.read<OwnerBloc>().add(
                                        DeleteOwner(ownerId: owner.id!),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddOwnerPage(owner: owner),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is OwnerError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(
                      child: Text('Cargando propietarios...'),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OwnerSearchBar extends StatelessWidget {
  const OwnerSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Buscar propietarios...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (query) {
        if (query.isEmpty) {
          context.read<OwnerBloc>().add(FetchOwners());
        } else {
          context.read<OwnerBloc>().add(SearchOwners(query: query));
        }
      },
    );
  }
}
