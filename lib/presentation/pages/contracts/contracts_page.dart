// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:renta_control/data/repositories/contract/contract_repository.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_bloc.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_event.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_state.dart';
import 'package:renta_control/utils/components/pdf_viewer_page.dart';
import 'package:url_launcher/url_launcher.dart';

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
          Padding(padding: EdgeInsets.all(8.0), child: ContractSearchBar()),
          Expanded(
            // === AQUI SE AÑADE EL PADDING INFERIOR ===
            child: Padding(
              padding: EdgeInsets.only(bottom: 80.0),
              child: BlocBuilder<ContractBloc, ContractState>(
                builder: (context, state) {
                  if (state is ContractLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ContractLoaded) {
                    return ListView.builder(
                      itemCount: state.contracts.length,
                      itemBuilder: (context, index) {
                        final contract = state.contracts[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.description,
                              color: Colors.blueAccent,
                            ),
                            title: Text(
                              contract.denomination ?? 'Contrato',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Inquilino: ${contract.tenant?.fullName}'),
                                Text('Propiedad: ${contract.property?.name}'),
                                Text('Costo: \$ ${contract.rentalCost}'),
                                Text(
                                  'Inicio: ${DateFormat.yMMMMd('es').add_Hm().format(DateTime.parse(contract.contractStartDate.toString()))}',
                                ),
                                Text(
                                  'Fin: ${DateFormat.yMMMMd('es').add_Hm().format(DateTime.parse(contract.contractEndDate.toString()))}',
                                ),
                                Text(
                                  'Creado por: ${contract.contractCreatorFullName}',
                                ),
                              ],
                            ),
                            trailing: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.red,
                                      size: 45,
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => PdfViewerPage(
                                                pdfUrl: contract.contractUrl!,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.download,
                                      color: Colors.blue,
                                      size: 45,
                                    ),
                                    onPressed: () async {
                                      final Uri uri = Uri.parse(
                                        contract.contractUrl ?? '',
                                      );
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'No se pudo abrir el pdf',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ContractError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(
                      child: Text('No hay propiedades disponibles'),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
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
        prefixIcon: Icon(Icons.search),
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
