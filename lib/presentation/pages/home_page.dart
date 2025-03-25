import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:renta_control/data/repositories/property_repository.dart';
import 'package:renta_control/presentation/blocs/properties/property_bloc.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';
import 'package:renta_control/presentation/blocs/properties/property_state.dart';
import 'package:renta_control/presentation/pages/add_property_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de propiedades')),
      body: BlocProvider(
        create:
            (context) => PropertyBloc(
              repository: RepositoryProvider.of<PropertyRepository>(context),
            )..add(FetchProperties()),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(8.0), child: SearchBar()),
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
                          title: Text(property.name),
                          subtitle: Text(property.address),
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
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.home),
            label: 'Registrar propiedad',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPropertyPage()),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.person_add),
            label: 'Registrar usuario',
            onTap: () {},
          ),
          SpeedDialChild(
            child: Icon(Icons.assignment),
            label: 'Generar contrato',
            onTap: () {},
          ),
          SpeedDialChild(
            child: Icon(Icons.receipt),
            label: 'Generar factura',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar propiedades...',
        border: OutlineInputBorder(),
        prefix: Icon(Icons.search),
      ),
      onChanged: (query) {
        context.read<PropertyBloc>().add(SearchProperties(query: query));
      },
    );
  }
}