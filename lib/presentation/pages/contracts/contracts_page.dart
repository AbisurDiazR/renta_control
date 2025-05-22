import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_bloc.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_event.dart';

class ContractsPage extends StatelessWidget {
  const ContractsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Contratos'),
    );
  }
}

class ContractSearchBar extends StatelessWidget {
  const ContractSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar contratos...',
        border: OutlineInputBorder(),
        prefix: Icon(Icons.search),
      ),
      onChanged: (query) {
        if (query.isEmpty) {
          context.read<ContractBloc>().add(FetchContracts());
        } else {
          context.read<ContractBloc>().add(SearchContracts(query: query));
        }
      },
    );
  }
}