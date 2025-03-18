import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:login_chat/services/alert_service.dart';
import 'package:login_chat/services/auth_service.dart';
import 'package:login_chat/services/navigation_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;

  @override
  void initState() {
    // Se inicializan los servicios en el constructor de la clase
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        actions: [
          Row(
            children: [
              IconButton( // este botón es para navegar a la ruta /profile
                onPressed: () { 
                  _alertService.showToast(
                    text: "This is your profile",
                    icon: Icons.check,
                  );
                  _navigationService.pushNamed("/profile");
                },
                color: Colors.green,
                icon: const Icon(Icons.person),
              ),
              IconButton(
                onPressed: () async {
                  bool result = await _authService.logout();
                  if (result) {
                    // Si el resultado es verdadero navega a la ruta /login
                    _alertService.showToast(
                      text: "Logged out successfully",
                      icon: Icons.check,
                    );
                    _navigationService.pushReplacementNamed("/login");
                  }
                },
                color: Colors.red,
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Welcome to the chat app"),
          Text("You are logged in"),
        ],
      ),
    );
  }
}
