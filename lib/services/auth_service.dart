import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_chat/models/user_profile.dart';
import 'package:login_chat/services/database.service.dart';

class AuthService {
  final GetIt _getIt =
      GetIt.instance; // GetIt.instance es una instancia global de GetIt

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User?
  _user; // User? para que pueda ser null, este User es de Firebase y sirve para manejar la autenticación

  User? get user =>
      _user; // Getter para obtener el usuario, el => es para retornar el valor de la variable _user, es como las funciones flecha de JavaScript

  late DatabaseService
  _databaseService; // databaseService para manejar la base de datos

  AuthService() {
    _firebaseAuth.authStateChanges().listen(
      authStateChangesStreamListener,
    ); // authStateChanges para escuchar los cambios de estado de la autenticación
    _databaseService =
        _getIt.get<DatabaseService>(); // Obtiene el servicio DatabaseService
  } // este es el constructor de la clase AuthService

  // Obtenemos el usuario actual

  Future<UserProfile?> getUserProfile() async {
    try {
      final uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) return null;

      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!doc.exists) return null;

      return UserProfile.fromJson(doc.data()!);
    } catch (e) {
      print("Error obteniendo perfil: $e");
      return null;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        // signInWithEmailAndPassword para loguear con email y contraseña
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Si el usuario es diferente de null
        _user = credential.user; // Guarda el usuario en la variable _user
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  // este metodo maneja el cambio de estado de la autenticación
  void authStateChangesStreamListener(User? user) {
    if (user != null) {
      _user = user;
    } else {
      _user = null;
    }
  }

  // este metodo es para registrar un usuario
  Future<bool> signUp(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        // createUserWithEmailAndPassword para registrar un usuario con email y contraseña
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Si el usuario es diferente de null
        _user = credential.user; // Guarda el usuario en la variable _user
        return true; // Al ponerlo en true en el archivo main se aplica la logica de que el usuario existe entonce lo redirige a la pantalla de inicio
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  // este metodo es para cerrar sesión
  Future<bool> logout() async {
    try {
      await GoogleSignIn().signOut(); // signOut para cerrar sesión de Google
      await _firebaseAuth.signOut(); // signOut para cerrar sesión
      return true;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Iniciar sección con Google
  Future<bool> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser =
          await GoogleSignIn()
              .signIn(); // GoogleSignIn para iniciar sesión con Google
      GoogleSignInAuthentication? googleAuth =
          await googleUser
              ?.authentication; // authentication para obtener la autenticación de Google
      final credential = GoogleAuthProvider.credential(
        // credential para obtener la credencial de Google
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _firebaseAuth.signInWithCredential(
        credential,
      ); // signInWithCredential para iniciar sesión con la credencial de Google
      _user =
          _firebaseAuth.currentUser; // Guarda el usuario en la variable _user

      if (_user != null) {
        final uid = _user!.uid;
        final doc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get(); // Obtiene el documento del usuario de la base de datos

        if (!doc.exists) { // Si el documento no existe, lo crea
          await _databaseService.createUserProfile(
            userProfile: UserProfile(
              uid: uid,
              name: _user!.displayName,
              email: _user!.email,
              pfpURL:
                  _user!.photoURL ??
                  'https://hospitalveterinariodonostia.com/wp-content/uploads/2020/10/gatos-854x427.png',
            ),
          );
        }

        return true;
      } else {
        return false; // Si el usuario es null, retorna false
      }
    } catch (e) {
      print(e);
    }

    return false;
  }
}
