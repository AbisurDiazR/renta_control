// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:renta_control/data/repositories/users/user_repository.dart';
import 'package:renta_control/presentation/blocs/user/user_bloc.dart';
import 'package:renta_control/presentation/blocs/user/user_event.dart';
import 'package:renta_control/presentation/blocs/user/user_state.dart';
import 'package:renta_control/presentation/pages/users/add_user.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UserBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
          )..add(FetchUsers()),
      child: Scaffold(
        body: Column(
          children: [
            const Padding(padding: EdgeInsets.all(8.0), child: UserSearchBar()),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 80.0),
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is UserLoaded) {
                      return ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          final user = state.users[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                user.name.isNotEmpty ? user.name[0] : '?',
                              ),
                            ),
                            title: Text(user.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email: ${user.email}'),
                                Text(
                                  'Creado en: ${DateFormat.yMMMMd('es').add_Hm().format(DateTime.parse(user.createdAt ?? '1970-01-01T00:00:00'))}',
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: Text('Confirmar eliminación'),
                                        content: Text(
                                          '¿Estás seguro de que deseas borrar a "${user.name}"?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.of(
                                                  context,
                                                ).pop(false),
                                            child: Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed:
                                                () => Navigator.of(
                                                  context,
                                                ).pop(true),
                                            child: Text('Borrar'),
                                          ),
                                        ],
                                      ),
                                );
                                if (confirm == true) {
                                  context.read<UserBloc>().add(
                                    DeleteUser(id: user.id!),
                                  );
                                }
                              },
                            ),
                            onTap: () {
                              final currentUserEmail =
                                  FirebaseAuth.instance.currentUser?.email;
                              if (currentUserEmail ==
                                  "mendozacayu3@gmail.com") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => AddUserPage(user: user),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Acceso denegado.'),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    } else if (state is UserError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return const Center(child: Text('No users available.'));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserSearchBar extends StatelessWidget {
  const UserSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Buscar usuario...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (query) {
        if (query.isEmpty) {
          context.read<UserBloc>().add(FetchUsers());
        } else {
          context.read<UserBloc>().add(SearchUsers(query: query));
        }
      },
    );
  }
}
