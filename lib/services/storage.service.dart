import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  StorageService(); // Se le pueden quitar los corchetes porque no se le pasan argumentos al constructor y funciona igual

  Future<String?> uploadUserPfp({
    required File file,
    required String uid,
  }) async {
    Reference fileRef = _firebaseStorage
        .ref('users/pfps')
        .child(
          '$uid${p.extension(file.path)}',
        ); // Reference para guardar la imagen en la carpeta users/pfps con el nombre del uid del usuario y la extensión del archivo
    // Se usa el paquede de path para obtener la extensión del archivo
    UploadTask task = fileRef.putFile(file); // UploadTask para subir el archivo
    return task.then((p) {
      if (p.state == TaskState.success) {
        return p.ref
            .getDownloadURL(); // Retorna la URL de descarga de la imagen
      }
      return null; // Retorna null si no se subió la imagen
    }); // Retorna la URL de descarga de la imagen
  }
}
