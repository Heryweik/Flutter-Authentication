import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:login_chat/services/navigation_service.dart';

class AlertService {
  final GetIt _getIt = GetIt.instance; // Obtiene la instancia global de GetIt

  late NavigationService _navigationService; // NavigationService para manejar la navegación


  AlertService() {
    _navigationService = _getIt.get<NavigationService>(); // Obtiene el servicio NavigationService
  }

  // Método para mostrar una alerta
  void showToast({required String text, IconData icon = Icons.info}) {
    // Método para mostrar un mensaje
    try {
      DelightToastBar( // Creamos una alerta con el paquete Delightful Toast
        autoDismiss: true, // Se cierra automáticamente
        position: DelightSnackbarPosition.top,
        builder: (context) {
          return ToastCard(
            leading: Icon(
            icon,
            size: 28,),
            title: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          );
        },
      ).show(_navigationService.navigatorKey!.currentContext!); // Le decimos que se muestre la alerta
    } catch (e) {
      throw Exception("Error showing alert: $e");
    }
  }
}
