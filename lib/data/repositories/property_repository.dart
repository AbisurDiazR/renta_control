import 'package:renta_control/domain/models/property.dart';
import 'package:renta_control/domain/models/user_model.dart';

class PropertyRepository{
  Future<List<Property>> fetchProperties() async {
    return [
      Property(name: "Casa en la playa", address: 'Av Mendoza 23', owner: UserModel(id: '2', email: 'cayumendoza@gmail.com')),
      Property(name: "Departamento centrico", address: 'Calle Principal 564', owner: UserModel(id: '2', email: 'cayumendoza@gmail.com')),
    ];
  }
}