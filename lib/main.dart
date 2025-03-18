//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_chat/services/auth_service.dart';
import 'package:login_chat/services/navigation_service.dart';
import 'package:login_chat/utils.dart';

void main() async {
  await setUp();
  runApp(MyApp());
}

// This function is for Firebase setup
Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by Firebase

  await setUpFirebase();
  await registerServices(); 
}

// ignore: must_be_immutable, esto es para que no marque error
class MyApp extends StatelessWidget { 

  final GetIt _getIt = GetIt.instance; // GetIt.instance es una instancia global de GetIt

  late NavigationService _navigationService; // NavigationService para manejar la navegación
  // Lo usaremos en la raiz de la app para manejar cuando el usuario esta logueado
  late AuthService _authService; // AuthService para manejar la autenticación

  MyApp({super.key}) { // Se le quito el const al constructor para poder inicializar el servicio NavigationService
    _navigationService = _getIt.get<NavigationService>(); // Obtiene el servicio NavigationService
    _authService = _getIt.get<AuthService>(); // Obtiene el servicio AuthService
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationService.navigatorKey, // navigatorKey para manejar la navegación
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: GoogleFonts.montserratTextTheme(), // Google Fonts
      ),
      initialRoute: _authService.user == null ? "/login" : "/home", // Ruta inicial de la aplicación
      routes: _navigationService.routes, // Rutas de la aplicación
      // home: LoginPage() se quitó para que la aplicación inicie en la ruta /login
    );
  }
}