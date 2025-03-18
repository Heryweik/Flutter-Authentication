import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_chat/models/user_profile.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore
          .instance; //El firestore es la instancia de la base de datos de Firebase que sirve para interactuar con la base de datos, final indica que no se puede cambiar el valor de la variable

  CollectionReference?
  _usersCollection; // Referencia a la colección de usuarios

  DatabaseService() {
    _setupCollectionReferences(); // Inicializa las referencias a las colecciones
  }

  void _setupCollectionReferences() {
    _usersCollection = _firebaseFirestore
        .collection('users') // Referencia a la colección de usuarios
        .withConverter<UserProfile>( // withConverter es un método que se usa para convertir los datos de Firestore a un objeto de Dart
          fromFirestore: (snapshots, _) => UserProfile.fromJson(snapshots.data()!), // Convierte los datos de Firestore a un objeto de Dart
          toFirestore: (userProfile, _) => userProfile.toJson(), // Convierte un objeto de Dart a los datos de Firestore
        ); 
  }

  Future<void> createUserProfile({ // Future es un objeto que representa un valor o error que estará disponible en el futuro
    required UserProfile userProfile,
  }) async {
    await _usersCollection!
        .doc(userProfile.uid)
        .set(userProfile); // Crea un documento con el uid del usuario y guarda el userProfile
  }
}
