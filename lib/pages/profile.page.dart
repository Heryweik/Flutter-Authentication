
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:login_chat/consts.dart';
import 'package:login_chat/services/media_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GetIt _getIt = GetIt.instance; // GetIt.instance es una instancia global de GetIt
  // El GetIt es un contenedor de servicios, se usa para registrar y obtener servicios en toda la aplicación

  late MediaService _mediaService; // mediaService para manejar la selección de imágenes
  // late StorageService _storageService; // storageService para manejar el almacenamiento de archivos
  
  File? selectedImage; // Variable para guardar la imagen de perfil

    // Asi se inicializan los servicios en el constructor de la clase
  @override
  void initState() {
    // initState es un método que se llama cuando el widget es insertado en el árbol de widgets, en otras palabras aqui se inicializa todo lo necesario para los stateful widgets antes de renderizarse
    super.initState();
    _mediaService =
        _getIt.get<MediaService>(); // Obtiene el servicio MediaService
    // _storageService = _getIt.get<StorageService>(); // Obtiene el servicio StorageService
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Para evitar que el teclado haga resize de la pantalla
      body: _buildUI(),
    );
  }

    // Modale con las opciones de la cámara y la galería
  void _showImageOptions() {
    showDialog(
      // Muestra un diálogo modal centrado en la pantalla
      // Si se quisiera una modal que ocupe toda la pantalla se puede usar showModalBottomSheet (Aparece desde abajo)
      // Para una modal con mas detalles se puede usar showGeneralDialog
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Usa AlertDialog para un diseño centrado
          title: Text("Selecciona una opción"), // Título del modal
          content: Column(
            mainAxisSize:
                MainAxisSize
                    .min, // Hace que la columna sea lo más pequeña posible
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Seleccionar de la galería"),
                onTap: () async {
                  Navigator.pop(
                    context,
                  ); // Cierra el diálogo, este naviator es de flutter
                  File? file =
                      await _mediaService
                          .getImageFromGallery(); // Obtiene la imagen seleccionada
                  if (file != null) {
                    setState(() {
                      // Actualiza el estado con la imagen seleccionada
                      selectedImage = file;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Tomar foto con la cámara"),
                onTap: () async {
                  Navigator.pop(
                    context,
                  ); // Cierra el diálogo, este naviator es de flutter
                  File? file =
                      await _mediaService
                          .takePhoto(); // Obtiene la imagen tomada
                  if (file != null) {
                    setState(() {
                      // Actualiza el estado con la imagen tomada
                      selectedImage = file;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildUI() {
    return SafeArea(
      // SafeArea para evitar que el contenido se superponga con la barra de estado, barra de navegación y barra de notificaciones
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              _pfpSelectionField(),
            ],
          ),
        ),
      ),
    );
  }

    Widget _pfpSelectionField() {
    // pfp es por profile picture
    return GestureDetector(
      onTap: () {
        // onTap para manejar el evento de presionar el campo
        _showImageOptions(); // Muestra el modal con las opciones de la cámara y la galería
      },
      child: CircleAvatar(
        // CircleAvatar para mostrar la imagen de perfil
        radius:
            MediaQuery.of(context).size.width *
            0.15, // Toma el 15% de la pantalla
        backgroundImage:
            selectedImage != null
                ? FileImage(
                  selectedImage!,
                ) // Si la imagen es diferente de null, entonces muestra la imagen seleccionada
                : NetworkImage(
                      PLACEHOLDER_PFP,
                    ) // De lo contrario muestra una imagen por defecto
                    as ImageProvider, // as ImageProvider para decirle al lenguaje que es una imagen
        child:
            selectedImage ==
                    null // Si la imagen es null, entonces muestra el icono de la cámara
                ? Icon(Icons.camera_alt, size: 30.0, color: Colors.grey[800])
                : null,
      ),
    );
  }

  /* Cuando ya este en el perfil correcto abra alguna forma de guardar los valores cambiados incluidos la imagen de perfil si es que se ha cambiado o agregado, para ellos hay que usar el servicio storage para que aparte de guardar todos los datos tambien subamos la imagen en su carpeta correcta dentro del storage de firebase */

  /* if (result) {
        String? pfpURL = await _storageService.uploadUserPfp(file: selectedImage!, uid: _authService.user!.uid); // El uid es el id del usuario proporcionado por Firebase

        if (pfpURL != null) {
          // Aqui se guardan los datos del usuario en Firestore
                await _databaseService.createUserProfile(
                  userProfile: UserProfile(
                    uid: _authService.user!.uid,
                    name: name!,
                    pfpURL: pfpURL,
                  ),
                );

                _alertService.showToast(
                  text: "Account edited successfully",
                  icon: Icons.check,
                );
        } else {
          throw Exception("Enable to upload profile picture");
        }
      } else {
        throw Exception("Enable to create account");
      } */

}