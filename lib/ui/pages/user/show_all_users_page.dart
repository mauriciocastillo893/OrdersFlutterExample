import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langspeak/config/providers/user_bloc/user_bloc.dart';
import 'package:langspeak/config/providers/user_bloc/user_event.dart';
import 'package:langspeak/config/providers/user_bloc/user_state.dart';
import 'package:langspeak/ui/pages/user/show_one_user_page.dart';

class ShowAllUsersPage extends StatelessWidget {
  const ShowAllUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Users registered"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserInitialState) {
                    return const Text("Bienvenido, estamos cargando los datos");
                  } else if (state is UserLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetAllUsersState) {
                    print(
                        "Displaying ${state.users.length} users"); // Verificación
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        return ListTile(
                          title: Text((user['username'] ?? 'Sin nombre') +
                                  " - " +
                                  user['email'] ??
                              'Sin correo'),
                          subtitle: Text(user['id']),
                          // onTap: () {
                          //   print("Tapped on user ${user['id']}");
                          // },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowOneUserPage(
                                  id: user['id'],
                                  username: user['username'],
                                  email: user['email'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is UserErrorState) {
                    return Text(state.message);
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<UserBloc>(context).add(GetAllUsersEvent());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
