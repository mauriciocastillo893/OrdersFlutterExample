import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:langspeak/config/providers/user_bloc/user_bloc.dart';
import 'package:langspeak/config/providers/user_bloc/user_event.dart';
import 'package:langspeak/config/providers/user_bloc/user_state.dart';

class ShowLoginUserPage extends StatelessWidget {
  const ShowLoginUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailEditingController = TextEditingController();
    TextEditingController passwordEditingController = TextEditingController();
    FlutterNativeSplash.remove();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login (sign-in)"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  if (emailEditingController.text.isNotEmpty &&
                      passwordEditingController.text.isNotEmpty) {
                    BlocProvider.of<UserBloc>(context).add(LoginUserEvent(
                        emailEditingController.text,
                        passwordEditingController.text));
                  } else {
                    BlocProvider.of<UserBloc>(context)
                        .add(const UserErrorEvent("Error: Campos vacíos"));
                  }
                },
                child: const Text("Iniciar sesión")),
            const SizedBox(height: 10),
            const Text("¿No tienes cuenta?"),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signUp');
                },
                child: const Text("Crear cuenta")),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/menu');
                },
                child: const Text("Navegar a menu")),
            const SizedBox(height: 26),
            BlocBuilder<UserBloc, UserState>(builder: (context, state) {
              if (state is UserInitialState) {
                return const Text(
                    "Bienvenido, por favor ingrese su correo y contraseña.");
              } else if (state is UserLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LoginUserState) {
                if (state.isLoginCorrectly) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushNamed(context, '/menu');
                  });
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email: ${state.email}"),
                    Text("${state.isLoginCorrectly}")
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
