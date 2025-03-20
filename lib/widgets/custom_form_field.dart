import 'package:flutter/material.dart';
import 'package:login_chat/config/colors.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final String labelText; // No es necesario
  final Icon? prefixIcon;
  //final double height;
  final RegExp validationRegularExp; // RegExp para validar el campo
  final bool obscureText; // Para ocultar el texto
  final void Function(String?)
  onSaved; // Función para guardar el valor del campo, el String? es para que pueda ser null, si no se pone el ? no puede ser null y marcará error.

  const CustomFormField({
    super.key,
    required this.hintText,
    required this.labelText, // No es necesario
    this.prefixIcon,
    //required this.height,
    required this.validationRegularExp,
    this.obscureText = false,
    required this.onSaved,
  }); // El required es para que sea obligatorio, esta parte funciona como las props de React

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // SizedBox para limitar el tamaño del contenedor
      height: MediaQuery.sizeOf(context).height * 0.06, // Altura del contenedor
      child: TextFormField(
        onSaved: onSaved, // Guarda el valor del campo
        obscureText: obscureText, // Para ocultar el texto
        validator: (value) {
          // Validator para validar el valor del campo, usando una expresión regular
          if (value != null && validationRegularExp.hasMatch(value)) {
            return null;
          }
          return 'enter a valid ${labelText.toLowerCase()}'; // Si no se cumple la expresión regular, retorna un mensaje de error
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          isDense: false, // Hace el input más compacto
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
          
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            borderSide: BorderSide(color: AppColors.pantone485C, ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            borderSide: BorderSide(color: AppColors.pantone485C),
          ),
          
        ),
      ),
    );
  }
}
