import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:renta_control/presentation/blocs/auth/auth_bloc.dart';
import 'package:renta_control/presentation/blocs/auth/auth_event.dart';
import 'package:renta_control/presentation/pages/contracts/create_contract_page.dart';
import 'package:renta_control/presentation/pages/invoices/create_invoice_page.dart';
import 'package:renta_control/presentation/pages/owners/add_owner_page.dart';
import 'package:renta_control/presentation/pages/owners/owners_page.dart';
import 'package:renta_control/presentation/pages/properties/add_property_page.dart';
import 'package:renta_control/presentation/pages/contracts/contracts_page.dart';
import 'package:renta_control/presentation/pages/invoices/invoices_page.dart';
import 'package:renta_control/presentation/pages/properties/properties_page.dart';
import 'package:renta_control/presentation/pages/tenants/add_tenant.dart';
import 'package:renta_control/presentation/pages/tenants/tenants_page.dart';
import 'package:renta_control/presentation/pages/users_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    PropertiesPage(),
    ContractsPage(),
    InvoicesPage(),
    UsersPage(),
    OwnerPage(),
    TenantsPage()
  ];

  //Metodo para actualizar el indice seleccionado
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Control de rentas')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menú de navegación',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Propiedades'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Contratos'),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Facturas'),
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Usuarios'),
              onTap: () => _onItemTapped(3),
            ),
            ListTile(
              leading: Icon(Icons.person_pin),
              title: Text('Propietarios'),
              onTap: () => _onItemTapped(4),
            ),
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Inquilinos'),
              onTap: () => _onItemTapped(5),
            ),
            Divider(height: 50),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar sesión'),
              onTap: () {
                context.read<AuthBloc>().add(LogoutRequested());
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.home),
            label: 'Registrar propiedad',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPropertyPage()),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.person_add),
            label: 'Registrar usuario',
            onTap: () {},
          ),
          SpeedDialChild(
            child: Icon(Icons.person_pin),
            label: 'Registrar propietario',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddOwnerPage()),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.person_outlined),
            label: 'Registrar inquilino',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTenantPage()),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.assignment),
            label: 'Generar contrato',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateContractPage()),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.receipt),
            label: 'Generar factura',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateInvoicePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
