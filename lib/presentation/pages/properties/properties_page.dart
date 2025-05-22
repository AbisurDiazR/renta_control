// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/property/property_repository.dart';
import 'package:renta_control/presentation/blocs/properties/property_bloc.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';
import 'package:renta_control/presentation/blocs/properties/property_state.dart';
import 'package:renta_control/presentation/pages/properties/add_property_page.dart';

class PropertiesPage extends StatelessWidget {
  const PropertiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => PropertyBloc(
            repository: RepositoryProvider.of<PropertyRepository>(context),
          )..add(FetchProperties()),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(8.0), child: PropertySearchBar()),
          Expanded(
            child: BlocBuilder<PropertyBloc, PropertyState>(
              builder: (context, state) {
                if (state is PropertyLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is PropertyLoaded) {
                  return ListView.builder(
                    itemCount: state.properties.length,
                    itemBuilder: (context, index) {
                      final property = state.properties[index];
                      return ListTile(
                        leading: Icon(Icons.home),
                        title: Text(
                          property.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Propietario: ${property.ownerName}'),
                            Text(
                              'Dirección: ${property.street} ${property.extNumber}, ${property.neighborhood}',
                            ),
                            Text(
                              'Estatus: ${property.status}',
                              style: TextStyle(
                                color:
                                    property.status == 'rentado'
                                        ? Colors.red
                                        : Colors.green,
                              ),
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
                                    title: Text('Cofirmar eliminación'),
                                    content: Text(
                                      '¿Estas seguro de eliminar esta propiedad?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, false),
                                        child: Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => {
                                              Navigator.pop(context, true),
                                            },
                                        child: Text('Eliminar'),
                                      ),
                                    ],
                                  ),
                            );
                            if (confirm == true) {
                              context.read<PropertyBloc>().add(
                                DeleteProperty(propertyId: property.id!),
                              );
                            }
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      AddPropertyPage(property: property),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is PropertyError) {
                  return Center(child: Text(state.message));
                } else {
                  return Center(child: Text('No hay propiedades disponibles'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PropertySearchBar extends StatelessWidget {
  const PropertySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar propiedades...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (query) {
        if (query.isEmpty) {
          context.read<PropertyBloc>().add(FetchProperties());
        } else {
          context.read<PropertyBloc>().add(SearchProperties(query: query));
        }
      },
    );
  }
}
