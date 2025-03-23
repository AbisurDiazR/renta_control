import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/property_repository.dart';
import 'package:renta_control/domain/models/property.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';
import 'package:renta_control/presentation/blocs/properties/property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final PropertyRepository repository;
  StreamSubscription<List<Property>>? _propertiesSubscription;

  PropertyBloc({required this.repository}) : super(PropertyInitial()) {
    on<FetchProperties>(_onFetchProperties);
    on<PropertiesUpdated>(_onPropertiesUpdated);
    on<AddProperty>(_onAddProperty);
    on<SearchProperties>(_onSearchProperties);
    /*on<AddProperty>((event, emit) async {
      try {
        final newProperty = Property(name: event.name, address: event.address, owner: event.owner);
        await repository.addProperty(newProperty);
        // Actualizar la lista local de propiedades
        allProperties.add(newProperty);
        // Emitir el estado actualizado con la lista de propiedades actualizada
        emit(PropertyLoaded(properties: List.from(allProperties)));
      } catch (e) {
        emit(PropertyError(message: 'Error al agregar la propiedad $e',));
      }
    });

    on<FetchProperties>((event, emit) async {
      emit(PropertyLoading());
      try {
        allProperties = await repository.fetchProperties();

        //Obtener correo del usuario autenticado
        User? user = FirebaseAuth.instance.currentUser;
        String? userEmail = user?.email;

        //Filtrar propiedades si el correo es diferente a 'mendozacayu3@gmail.com
        if (userEmail != null && userEmail != 'mendozacayu3@gmail.com') {
          allProperties = allProperties.where((property) {
            return property.owner.email == userEmail;
          }).toList();
        }
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
    });*/
  }

  FutureOr<void> _onFetchProperties(
    FetchProperties event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    await _propertiesSubscription?.cancel();
    _propertiesSubscription = repository.fetchProperties().listen(
      (properties) {
        add(PropertiesUpdated(properties: properties));
      },
      onError: (error) {
        emit(PropertyError(message: 'Error al cargar propiedades: $error'));
      },
    );
  }

  void _onPropertiesUpdated(
    PropertiesUpdated event,
    Emitter<PropertyState> emit,
  ) {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email;

    List<Property> filteredProperties = event.properties;

    if (userEmail != null && userEmail != 'mendozacayu3@gmail.com') {
      filteredProperties =
          event.properties
              .where((property) => property.owner.email == userEmail)
              .toList();
    }

    emit(PropertyLoaded(properties: filteredProperties));
  }

  FutureOr<void> _onAddProperty(
    AddProperty event,
    Emitter<PropertyState> emit,
  ) async {
    try {
      final newProperty = Property(
        name: event.name,
        address: event.address,
        owner: event.owner,
      );
      await repository.addProperty(newProperty);
    } catch (e) {
      emit(PropertyError(message: 'Error al cargar la propiedad: $e'));
    }
  }

  FutureOr<void> _onSearchProperties(
    SearchProperties event,
    Emitter<PropertyState> emit,
  ) {
    if (state is PropertyLoaded) {
      final currentState = state as PropertyLoaded;
      final query = event.query.toLowerCase();
      final filteredProperties = currentState.properties.where((property) {
        return property.name.toLowerCase().contains(query) || property.address.contains(query);
      }).toList();
      emit(PropertyLoaded(properties: filteredProperties));
    }
  }

  @override
  Future<void> close(){
    _propertiesSubscription?.cancel();
    return super.close();
  }
}
