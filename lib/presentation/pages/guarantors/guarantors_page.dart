import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/guarantor/guarantor_repository.dart';
import 'package:renta_control/presentation/blocs/guarantor/guarantor_bloc.dart';
import 'package:renta_control/presentation/blocs/guarantor/guarantor_event.dart';
import 'package:renta_control/presentation/blocs/guarantor/guarantor_state.dart';
import 'package:renta_control/presentation/pages/guarantors/add_guarantor.dart';

class GuarantorsPage extends StatelessWidget {
  const GuarantorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => GuarantorBloc(
            repository: RepositoryProvider.of<GuarantorRepository>(context),
          )..add(FetchGuarantors()),
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GuarantorSearchBar(),
            ),
            Expanded(
              child: BlocBuilder<GuarantorBloc, GuarantorState>(
                builder: (context, state) {
                  if (state is GuarantorLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is GuarantorLoaded) {
                    final guarantors = state.guarantors;
                    return ListView.builder(
                      itemCount: guarantors.length,
                      itemBuilder: (context, index) {
                        final guarantor = guarantors[index];
                        return ListTile(
                          leading: Icon(Icons.person),
                          title: Text(guarantor.fullName),
                            subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email: ${guarantor.email}'),
                              Text('Teléfono: ${guarantor.phoneNumber}'),
                              Text('Dirección: ${guarantor.street} ${guarantor.extNumber}, ${guarantor.neighborhood}'),
                            ],
                            ),
                          onTap: () {
                            // Navigate to the guarantor details page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddGuarantorPage(guarantor: guarantor,),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is GuarantorError) {
                    return Center(child: Text('Failed to load guarantors'));
                  } else {
                    return Center(child: Text('No guarantors available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GuarantorSearchBar extends StatelessWidget {
  const GuarantorSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Buscar fiadores...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (query) {
        if (query.isEmpty) {
          context.read<GuarantorBloc>().add(FetchGuarantors());
        } else {
          context.read<GuarantorBloc>().add(SearchGuarantors(query: query));
        }
      },
    );
  }
}
