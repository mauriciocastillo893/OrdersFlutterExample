import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langspeak/config/providers/user_bloc/user_bloc.dart';
import 'package:langspeak/config/providers/user_bloc/user_event.dart';
import 'package:langspeak/config/providers/user_bloc/user_state.dart';

class ShowRegisterUserPage extends StatelessWidget {
  const ShowRegisterUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailEditingController = TextEditingController();
    TextEditingController usernameEditingController = TextEditingController();
    TextEditingController passwordEditingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register (sign-up)"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextField(
              controller: usernameEditingController,
              decoration: const InputDecoration(
                hintText: 'Ingrese su nombre de usuario',
                labelText: 'Nombre de usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailEditingController,
              decoration: const InputDecoration(
                hintText: 'Ingrese su email',
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordEditingController,
              decoration: const InputDecoration(
                hintText: 'Ingrese su contraseña',
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  if (usernameEditingController.text.isNotEmpty &&
                      emailEditingController.text.isNotEmpty &&
                      passwordEditingController.text.isNotEmpty) {
                    BlocProvider.of<UserBloc>(context).add(RegisterUserEvent(
                        usernameEditingController.text,
                        emailEditingController.text,
                        passwordEditingController.text));
                  } else {
                    BlocProvider.of<UserBloc>(context)
                        .add(const UserErrorEvent("Error: Campos vacíos"));
                  }
                },
                child: const Text("Registrar nueva cuenta")),
            const SizedBox(height: 10),
            const Text("¿Ya tienes cuenta?"),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                child: const Text("Inicia sesión")),
            const SizedBox(height: 26),
            BlocBuilder<UserBloc, UserState>(builder: (context, state) {
              if (state is UserInitialState) {
                return const Text("Bienvenido, por favor registre sus datos.");
              } else if (state is UserLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RegisterUserState) {
                if (state.isRegisterCorrectly) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushNamed(context, '/menu');
                  });
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email: ${state.email}"),
                    Text("Username: ${state.name}"),
                    Text("${state.eventMsg}"),
                  ],
                );
              } else if (state is UserErrorState) {
                return Text(state.message);
              } else {
                return Container();
              }
            })
          ]),
        ),
      ),
    );
  }
}
