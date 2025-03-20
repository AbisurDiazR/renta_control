import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/property_repository.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';
import 'package:renta_control/presentation/blocs/properties/property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState>{
  final PropertyRepository repository;

  PropertyBloc({ required this.repository }) : super(PropertyInitial()){
    on<FetchProperties>((event, emit) async {
      emit(PropertyLoading());
      try {
        final properties = await repository.fetchProperties();
        emit(PropertyLoaded(properties: properties));
      } catch (e) {
        emit(PropertyError(message: 'Error al cargar propiedades'));
      }
    });
  }
}