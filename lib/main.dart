//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_chat/config/colors.dart';
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
  final GetIt _getIt =
      GetIt.instance; // GetIt.instance es una instancia global de GetIt

  late NavigationService
  _navigationService; // NavigationService para manejar la navegación
  // Lo usaremos en la raiz de la app para manejar cuando el usuario esta logueado
  late AuthService _authService; // AuthService para manejar la autenticación

  MyApp({super.key}) {
    // Se le quito el const al constructor para poder inicializar el servicio NavigationService
    _navigationService =
        _getIt
            .get<NavigationService>(); // Obtiene el servicio NavigationService
    _authService = _getIt.get<AuthService>(); // Obtiene el servicio AuthService
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey:
          _navigationService
              .navigatorKey, // navigatorKey para manejar la navegación
      debugShowCheckedModeBanner: false, // Se quita el banner de debug
      title: 'Viajú',
      theme: ThemeData(
        // Usar la paleta de colores personalizada
        colorScheme: ColorScheme.light(
          primary: AppColors.pantone3035C,
          secondary: AppColors.pantone7408C,
          surface: AppColors.offWhite,
          error: AppColors.pantone485C,
          onPrimary: AppColors.offWhite, // Texto en botones primarios
          onSecondary: AppColors.softBlack, // Texto en botones secundarios
        ),
        useMaterial3: true, // 
        primaryColor: AppColors.pantone3035C,
        cardColor: AppColors.offWhite, // Para alertas, toasts o cards
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.offWhite,
          foregroundColor: AppColors.softBlack, // Íconos y textos
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.softBlack,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: AppColors.softBlack),
        ),

        scaffoldBackgroundColor: AppColors.offWhite, // Fondo de las pantallas

        textTheme: GoogleFonts.montserratTextTheme(), // Google Fonts
      ),
      initialRoute:
          _authService.user == null
              ? "/login"
              : "/home", // Ruta inicial de la aplicación
      routes: _navigationService.routes, // Rutas de la aplicación
      // home: LoginPage() se quitó para que la aplicación inicie en la ruta /login
    );
  }
}
