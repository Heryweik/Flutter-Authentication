
import 'package:flutter/cupertino.dart';
import 'package:login_chat/pages/home_page.dart';
import 'package:login_chat/pages/login_page.dart';
import 'package:login_chat/pages/profile.page.dart';
import 'package:login_chat/pages/register_page.dart';

class NavigationService {

  late GlobalKey<NavigatorState> _navigatorKey; // GlobalKey para manejar el estado del navegador

  final Map<String, Widget Function(BuildContext)> _routes = {
    "/login": (context) => LoginPage(), // Ruta para la página de login
    "/register": (context) => RegisterPage(), // Ruta para la página de registro
    "/home": (context) => HomePage(), // Ruta para la página de inicio
    "/profile" : (context) => ProfilePage(), // Ruta para la página de perfil
  };// Mapa de rutas

  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey; // Getter para obtener el GlobalKey

  Map<String, Widget Function(BuildContext)> get routes => _routes; // Getter para obtener el mapa de rutas

  NavigationService() { // Constructor de la clase NavigationService
    _navigatorKey = GlobalKey<NavigatorState>(); // Inicializa el GlobalKey
  }

  void pushNamed(String routeName) { // Método para navegar a una ruta
    _navigatorKey.currentState?.pushNamed(routeName); // Navega a la ruta, el ? es para evitar errores si el valor es null
  }

  void pushReplacementNamed(String routeName) { // Método para navegar a una ruta y reemplazar la ruta actual
    _navigatorKey.currentState?.pushReplacementNamed(routeName); // navega a la ruta y reemplaza la ruta actual
  }

  void goBack() { // Método para regresar a la ruta anterior
    _navigatorKey.currentState?.pop(); // Regresa a la ruta anterior
  }

}