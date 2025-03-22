import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/property_repository.dart';
import 'package:renta_control/domain/models/property.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';
import 'package:renta_control/presentation/blocs/properties/property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final PropertyRepository repository;
  List<Property> allProperties = [];

  PropertyBloc({required this.repository}) : super(PropertyInitial()) {
    on<AddProperty>((event, emit) async {
      try {
        final newProperty = Property(name: event.name, address: event.address, owner: event.owner);
        await repository.addProperty(newProperty);
        emit(PropertyAdded());
        await Future.delayed(Duration(milliseconds: 100));
        add(FetchProperties());
      } catch (e) {
        emit(PropertyError(message: 'Error al agregar la propiedad $e',));
      }
    });

    on<FetchProperties>((event, emit) async {
      emit(PropertyLoading());
      try {
        allProperties = await repository.fetchProperties();
        emit(PropertyLoaded(properties: allProperties));
      } catch (e) {
        emit(PropertyError(message: 'Error al cargar propiedades'));
      }
    });

    on<SearchProperties>((event, emit) async {
      final query = event.query.toLowerCase();
      final filteredProperties =
          allProperties.where((property) {
            return property.name.toLowerCase().contains(query) ||
                property.address.toLowerCase().contains(query);
          }).toList();
      emit(PropertyLoaded(properties: filteredProperties));
    });
  }
}
