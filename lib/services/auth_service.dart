import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? _user; // User? para que pueda ser null, este User es de Firebase y sirve para manejar la autenticación

  User? get user => _user; // Getter para obtener el usuario, el => es para retornar el valor de la variable _user, es como las funciones flecha de JavaScript

  AuthService() {
    _firebaseAuth.authStateChanges().listen(authStateChangesStreamListener); // authStateChanges para escuchar los cambios de estado de la autenticación
  } // este es el constructor de la clase AuthService

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword( // signInWithEmailAndPassword para loguear con email y contraseña
        email: email,
        password: password,
      );

      if (credential.user != null) { // Si el usuario es diferente de null
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
      final credential = await _firebaseAuth.createUserWithEmailAndPassword( // createUserWithEmailAndPassword para registrar un usuario con email y contraseña
        email: email,
        password: password,
      );

      if (credential.user != null) { // Si el usuario es diferente de null
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
      await _firebaseAuth.signOut(); // signOut para cerrar sesión
      return true;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
