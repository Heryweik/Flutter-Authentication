
import 'dart:io'; // Este paquete nos permite trabajar con archivos
import 'package:image_picker/image_picker.dart';

class MediaService {

  final ImagePicker _picker = ImagePicker(); // Usamos el paquete image_picker para seleccionar imágenes de la galería o tomar una foto

  MediaService(); // Se le pueden quitar los corchetes porque no se le pasan argumentos al constructor y funciona igual

  Future<File?> getImageFromGallery() async { // Método para obtener una imagen de la galería
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery); // XFile es un archivo temporal que contiene la imagen seleccionada
    
    if (file != null) { // Si el archivo es diferente de null
      return File(file.path); // Retorna el archivo
    }
    return null; // De lo contrario retorna null
  }

  Future<File?> takePhoto() async { // Método para tomar una foto
    final XFile? file = await _picker.pickImage(source: ImageSource.camera); // XFile es un archivo temporal que contiene la imagen tomada
    
    if (file != null) { // Si el archivo es diferente de null
      return File(file.path); // Retorna el archivo
    }
    return null; // De lo contrario retorna null
  }

}