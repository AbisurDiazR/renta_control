// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:renta_control/domain/models/tenant/tenant.dart';

class AddTenantPage extends StatefulWidget{
  final Tenant? tenant;
  const AddTenantPage({super.key, this.tenant});

  @override
  _AddTenantPageState createState() => _AddTenantPageState();
}

class _AddTenantPageState extends State<AddTenantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Inquilino'),),
      body: Center(
        child: Text('Agregar Inquilino'),
      ),
    );
  }

}