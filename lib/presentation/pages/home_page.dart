import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/property_repository.dart';
import 'package:renta_control/presentation/blocs/properties/property_bloc.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';
import 'package:renta_control/presentation/blocs/properties/property_state.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de propiedades'),
      ),
      body: BlocProvider(create: (context) => PropertyBloc(repository: RepositoryProvider.of<PropertyRepository>(context),)..add(FetchProperties()),
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
                  subtitle: Text(property.address),
                  onTap: () {
                    //Detalles de la propiedad                    
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
      ),),
    );
  }
}