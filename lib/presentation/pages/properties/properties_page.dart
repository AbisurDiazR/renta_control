import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/property/property_repository.dart';
import 'package:renta_control/presentation/blocs/properties/property_bloc.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';
import 'package:renta_control/presentation/blocs/properties/property_state.dart';
import 'package:renta_control/presentation/pages/properties/add_property_page.dart';

class PropertiesPage extends StatelessWidget{
  const PropertiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PropertyBloc(
        repository: RepositoryProvider.of<PropertyRepository>(context),
      )..add(FetchProperties()),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(8.0), child: SearchBar(),),
          Expanded(
            child: BlocBuilder<PropertyBloc, PropertyState>(
              builder: (context, state) {
                if (state is PropertyLoading) {
                  return Center(child: CircularProgressIndicator(),);
                } else if(state is PropertyLoaded) {
                  return ListView.builder(
                    itemCount: state.properties.length,
                    itemBuilder: (context, index) {
                      final property = state.properties[index];
                      return ListTile(
                        title: Text(property.name),
                        subtitle: Text(property.street),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPropertyPage(property: property,),));
                        },
                      );
                    },
                  );
                } else if(state is PropertyError){
                  return Center(child: Text(state.message),);
                } else {
                  return Center(child: Text('No hay propiedades disponibles'),);
                }
              },
            ),
          )
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