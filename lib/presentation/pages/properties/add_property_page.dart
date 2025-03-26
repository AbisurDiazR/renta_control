import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/domain/models/property.dart';
import 'package:renta_control/domain/models/user_model.dart';
import 'package:renta_control/presentation/blocs/properties/property_bloc.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';

class AddPropertyPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final Property? property;

  AddPropertyPage({Key? key, this.property}) : super(key: key) {
    if (property != null) {
      _nameController.text = property!.name;
      _addressController.text = property!.address;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(property == null ? "Registrar nueva propiedad" : "Editar propiedad")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre de la propiedad'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Dirección de la propiedad',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final address = _addressController.text;
                User? firebaseUser = FirebaseAuth.instance.currentUser;

                if (name.isNotEmpty &&
                    address.isNotEmpty &&
                    firebaseUser != null) {
                  UserModel owner = UserModel(
                    id: firebaseUser.uid,
                    email: firebaseUser.email ?? '',
                    name: firebaseUser.displayName ?? '',
                    profileImageUrl: firebaseUser.photoURL ?? '',
                  );
                  
                  if (property == null) {
                    BlocProvider.of<PropertyBloc>(context).add(
                      AddProperty(name: name, address: address, owner: owner)
                    );
                  } else {
                    BlocProvider.of<PropertyBloc>(context).add(
                      UpdateProperty(property: property!.copyWith(id: property!.id, name: name, address: address))
                    );
                  }
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor complete todos los campos'),
                    ),
                  );
                }
              },
              child: Text(property == null ? 'Registrar propiedad' : 'Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
