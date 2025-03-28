import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/contract_repository.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_bloc.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_event.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_state.dart';

class ContractsPage extends StatelessWidget {
  const ContractsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ContractBloc(
            repository: RepositoryProvider.of<ContractRepository>(context),
          )..add(FetchContracts()),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(8.0), child: SearchBar(),),
          Expanded(
            child: BlocBuilder<ContractBloc, ContractState>(
              builder: (context, state) {
                if (state is ContractLoading) {
                  return Center(child: CircularProgressIndicator(),);
                } else if (state is ContractLoaded){
                  return ListView.builder(
                    itemCount: state.contracts.length,
                    itemBuilder: (context, index) {
                      final contract = state.contracts[index];
                      return ListTile(
                        title: Text(contract.propertyName),
                        subtitle: Text(contract.renter),
                        onTap: () {                          
                        },
                      );
                    },
                  );
                } else if(state is ContractError) {
                  return Center(child: Text(state.message),);
                }else{
                  return Center(child: Text('No hay contratos disponibles'),);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar contratos...',
        border: OutlineInputBorder(),
        prefix: Icon(Icons.search),
      ),
      onChanged: (query) {
        context.read<ContractBloc>().add(SearchContracts(query: query));
      },
    );
  }
}