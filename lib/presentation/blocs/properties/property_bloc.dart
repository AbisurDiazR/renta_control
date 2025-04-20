import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/property/property_repository.dart';
import 'package:renta_control/domain/models/property/property.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';
import 'package:renta_control/presentation/blocs/properties/property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final PropertyRepository repository;
  StreamSubscription<List<Property>>? _propertiesSubscription;

  PropertyBloc({required this.repository}) : super(PropertyInitial()) {
    on<FetchProperties>(_onFetchProperties);
    on<PropertiesUpdated>(_onPropertiesUpdated);
    on<AddProperty>(_onAddProperty);
    on<UpdateProperty>(_onUpdateProperty);
    on<SearchProperties>(_onSearchProperties);
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
    List<Property> filteredProperties = event.properties;

    emit(PropertyLoaded(properties: filteredProperties));
  }

  FutureOr<void> _onAddProperty(
    AddProperty event,
    Emitter<PropertyState> emit,
  ) async {
    try {
      final newProperty = Property(
        name: event.property.name,
        street: event.property.street,
        extNumber: event.property.extNumber,
        intNumber: event.property.intNumber, // Puede ser null
        neighborhood: event.property.neighborhood,
        borough: event.property.borough,
        city: event.property.city,
        state: event.property.state,
        zipCode: event.property.zipCode,
        notes: event.property.notes,
        ownerId:
            event
                .property
                .ownerId, // Se usa ownerId en lugar de un objeto UserModel
        status: event.property.status,
        ownerName: event.property.ownerName,
      );

      await repository.addProperty(newProperty);
    } catch (e) {
      emit(PropertyError(message: 'Error al cargar la propiedad: $e'));
    }
  }

  FutureOr<void> _onUpdateProperty(
    UpdateProperty event,
    Emitter<PropertyState> emit,
  ) async {
    try {
      await repository.updateProperty(event.property);
    } catch (e) {
      emit(PropertyError(message: 'Error al actualizar la propiedad: $e'));
    }
  }

  FutureOr<void> _onSearchProperties(
    SearchProperties event,
    Emitter<PropertyState> emit,
  ) {
    if (state is PropertyLoaded) {
      final currentState = state as PropertyLoaded;
      final query = event.query.toLowerCase();
      final filteredProperties =
          currentState.properties.where((property) {
            return property.name.toLowerCase().contains(query) ||
                property.street.contains(query) ||
                property.zipCode.contains(query);
          }).toList();
      emit(PropertyLoaded(properties: filteredProperties));
    }
  }

  @override
  Future<void> close() {
    _propertiesSubscription?.cancel();
    return super.close();
  }
}
