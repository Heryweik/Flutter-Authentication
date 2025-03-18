import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:login_chat/firebase_options.dart';
import 'package:login_chat/services/alert_service.dart';
import 'package:login_chat/services/auth_service.dart';
import 'package:login_chat/services/database.service.dart';
import 'package:login_chat/services/media_service.dart';
import 'package:login_chat/services/navigation_service.dart';
import 'package:login_chat/services/storage.service.dart';

// Set up Firebase for the current platform
Future<void> setUpFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance; // GetIt.instance es una instancia global de GetIt
  getIt.registerSingleton<AuthService>(
    AuthService()
  ); // Registra el servicio AuthService, si no se hace esto, no se puede usar el servicio en toda la aplicación
  // El singleton es para que solo haya una instancia de AuthService en toda la aplicación

  getIt.registerSingleton<NavigationService>( // Registra el servicio NavigationService
    NavigationService()
  );

  getIt.registerSingleton<AlertService>( // Registra el servicio AlertService
    AlertService()
  );

  getIt.registerSingleton<MediaService>( // Registra el servicio MediaService
    MediaService()
  );

  getIt.registerSingleton<StorageService>( // Registra el servicio StorageService
    StorageService()
  );

  getIt.registerSingleton<DatabaseService>( // Registra el servicio DatabaseService
    DatabaseService()
  );
}
