// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/domain/models/user/user.dart';
import 'package:renta_control/presentation/blocs/user/user_bloc.dart';
import 'package:renta_control/presentation/blocs/user/user_event.dart';

class AddUserPage extends StatefulWidget {
  final User? user;
  const AddUserPage({Key? key, this.user}) : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  // Removed the _user field as it is redundant

  @override
  void initState() {
    super.initState();
    // Removed the assignment to _user
    _initializeControllers();
  }

  void _initializeControllers() {
    final fields = ['email', 'name', 'password'];

    for (var field in fields) {
      _controllers[field] = TextEditingController();
    }

    if (widget.user != null) {
      _controllers['email']?.text = widget.user!.email;
      _controllers['name']?.text = widget.user!.name;
      _controllers['password']?.text = widget.user!.password;
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              for (var field in _controllers.keys)
                _buildTextField(field, isRequired: _isFieldRequired(field)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  widget.user == null
                      ? 'Guardar Usuario'
                      : 'Actualizar Usuario',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String field, {required bool isRequired}) {
    TextInputType keyboardType = TextInputType.text;
    List<TextInputFormatter> inputFormatters = [];
    bool obscureText = false;
    if (field == 'email') {
      keyboardType = TextInputType.emailAddress;
      inputFormatters = [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
    } else if (field == 'name') {
      keyboardType = TextInputType.name;
    } else if (field == 'password') {
      keyboardType = TextInputType.visiblePassword;
      obscureText = true;
      inputFormatters = [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controllers[field],
        decoration: InputDecoration(
          labelText: _getLabelText(field),
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (field == 'password' && value != null && value.length < 6) {
            return 'La contraseña debe tener al menos 6 caracteres';
          }
          if (field == 'password' && value != null && value.length > 128) {
            return 'La contraseña no debe exceder los 128 caracteres';
          }
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        obscureText: obscureText,
      ),
    );
  }

  bool _isFieldRequired(String field) {
    if (field == 'email') {
      return true; // El campo email es obligatorio
    } else if (field == 'name') {
      return true; // El campo name es obligatorio
    } else if (field == 'password') {
      return true; // El campo password es obligatorio
    }
    return false; // Por defecto, no es obligatorio
  }

  String _getLabelText(String field) {
    final labels = {
      'email': 'Email',
      'name': 'Nombre',
      'password': 'Contraseña',
    };
    return labels[field] ?? field;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        email: _controllers['email']!.text,
        name: _controllers['name']!.text,
        password: _controllers['password']!.text,
      );

      BlocProvider.of<UserBloc>(context).add(
        widget.user == null
            ? AddUser(user: user)
            : UpdateUser(user: user.copyWith(id: widget.user!.id)),
      );

      Navigator.pop(context, user); // Regresar el usuario creado/actualizado
    }
  }
}
