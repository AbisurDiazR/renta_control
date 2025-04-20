// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/property/property_repository.dart';
import 'package:renta_control/domain/models/owner/owner_model.dart';
import 'package:renta_control/presentation/blocs/properties/property_bloc.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';
import 'package:renta_control/presentation/blocs/properties/property_state.dart';

class OwnerPropertiesList extends StatefulWidget {
  final OwnerModel owner; // Current owner

  const OwnerPropertiesList({super.key, required this.owner});

  @override
  State<OwnerPropertiesList> createState() => _OwnerPropertiesListState();
}

class _OwnerPropertiesListState extends State<OwnerPropertiesList> {
  late PropertyBloc _propertyBloc;
  late final OwnerModel _owner; // Current owner

  @override
  void initState() {
    super.initState();
    _owner = widget.owner;
    _propertyBloc = PropertyBloc(
      repository: RepositoryProvider.of<PropertyRepository>(context),
    )..add(FetchProperties());
  }

  @override
  void dispose() {
    _propertyBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _propertyBloc,
      child: Scaffold(
        appBar: AppBar(title: Text('Propiedades de ${_owner.name}')),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<PropertyBloc, PropertyState>(
                builder: (context, state) {
                  if (state is PropertyLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PropertyLoaded) {
                    return ListView.builder(
                      itemCount:
                          state.properties
                              .where(
                                (property) => property.ownerId == _owner.id,
                              )
                              .length,
                      itemBuilder: (context, index) {
                        final filteredProperties =
                            state.properties
                                .where(
                                  (property) => property.ownerId == _owner.id,
                                )
                                .toList();
                        final property = filteredProperties[index];
                        return Material(
                          child: Card(
                            child: ListTile(
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
                                          property.status == 'disponible'
                                              ? Colors.red
                                              : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is PropertyError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(
                      child: Text('No hay propiedades disponibles'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
