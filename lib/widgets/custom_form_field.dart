import 'package:flutter/material.dart';
import 'package:login_chat/config/colors.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final String labelText; // No es necesario
  final Icon? prefixIcon;
  final Widget? suffixIcon; // ícono al final (como el ojito)
  //final double height;
  final RegExp validationRegularExp; // RegExp para validar el campo
  final bool obscureText; // Para ocultar el texto
  final void Function(String?)
  onSaved; // Función para guardar el valor del campo, el String? es para que pueda ser null, si no se pone el ? no puede ser null y marcará error.
  final String? errorText; // mensaje de error externo
  final bool hasError; // Si tiene error pinta el borde de rojo

  const CustomFormField({
    super.key,
    required this.hintText,
    required this.labelText, // No es necesario
    this.prefixIcon,
    this.suffixIcon,
    //required this.height,
    required this.validationRegularExp,
    this.obscureText = false,
    required this.onSaved,
    this.errorText,
    this.hasError = false,
  }); // El required es para que sea obligatorio, esta parte funciona como las props de React

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          // SizedBox para limitar el tamaño del contenedor
          height:
              MediaQuery.sizeOf(context).height * 0.05, // Altura del contenedor
          child: TextFormField(
            onSaved: onSaved, // Guarda el valor del campo
            obscureText: obscureText, // Para ocultar el texto
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              labelText: labelText,
              hintText: hintText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon, // Aquí se agrega el ojito u otro ícono
              contentPadding: const EdgeInsets.fromLTRB( // Se puso paddings independientes porque con el padding de abajo se rompía el diseño
                20, // left
                10, // top
                20, // right
                0, // bottom
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                borderSide: BorderSide(
                  color:
                      hasError ? AppColors.pantone485C : AppColors.pantone3035C,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                borderSide: BorderSide(
                  color:
                      hasError ? AppColors.pantone485C : AppColors.pantone3035C,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        if (errorText != null) // Mostrar el error por fuera
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: AppColors.pantone485C,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
