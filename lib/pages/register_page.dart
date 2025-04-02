import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:login_chat/config/colors.dart';
import 'package:login_chat/config/responsive_designe.dart';
import 'package:login_chat/consts.dart';
import 'package:login_chat/models/user_profile.dart';
import 'package:login_chat/services/alert_service.dart';
import 'package:login_chat/services/auth_service.dart';
import 'package:login_chat/services/database.service.dart';
import 'package:login_chat/services/navigation_service.dart';
import 'package:login_chat/widgets/custom_button_gradient.dart';
import 'package:login_chat/widgets/custom_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt =
      GetIt.instance; // GetIt.instance es una instancia global de GetIt
  // El GetIt es un contenedor de servicios, se usa para registrar y obtener servicios en toda la aplicación

  final GlobalKey<FormState> _registerFormKey =
      GlobalKey<FormState>(); // GlobalKey para manejar el estado del formulario

  late AuthService
  _authService; // late para que la variable no sea null y le decimos al lenguaje que la variable será inicializada después
  late NavigationService
  _navigationService; // navigationService para manejar la navegación
  late AlertService _alertService; // alertService para mostrar alertas
  late DatabaseService
  _databaseService; // databaseService para manejar la base de datos

  bool isLoading = false; // Variable para manejar el estado de carga
  String? errorName, // Variable para guardar el error del nombre
      name,
      errorEmail, // Variable para guardar el error del email
      email,
      errorPassword, // Variables para guardar el errorde la contraseña
      password; // Variables para guardar el nombre, email y la contraseña

  // Variables para manejar la visibilidad y comparacion de las contraseña
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String? confirmPassword;
  String? errorConfirmPassword;

  // Asi se inicializan los servicios en el constructor de la clase
  @override
  void initState() {
    // initState es un método que se llama cuando el widget es insertado en el árbol de widgets, en otras palabras aqui se inicializa todo lo necesario para los stateful widgets antes de renderizarse
    super.initState();
    _authService = _getIt.get<AuthService>(); // Obtiene el servicio AuthService
    _navigationService =
        _getIt
            .get<NavigationService>(); // Obtiene el servicio NavigationService
    _alertService =
        _getIt.get<AlertService>(); // Obtiene el servicio AlertService
    _databaseService =
        _getIt.get<DatabaseService>(); // Obtiene el servicio DatabaseService
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Para evitar que el teclado haga resize de la pantalla
      body: ResponsiveWidget(
        // ResponsiveWidget para hacer la pantalla responsive
        mobile: _buildMobileUI(),
        tablet: _buildTabletUI(),
        desktop: _buildDesktopUI(),
      ),
    );
  }

  Widget _buildMobileUI() {
    return _buildUI();
  }

  Widget _buildTabletUI() {
    return _buildUI();
  }

  Widget _buildDesktopUI() {
    return Center(child: SizedBox(width: 500.0, child: _buildUI()));
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
        child: Column(
          children: [
            _headerText(),

            Expanded(
              child: Center(
                child:
                    isLoading ? CircularProgressIndicator() : _registerForm(),
              ),
            ),

            if (!isLoading) _loginAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      // SizedBox para limitar el tamaño del contenedor
      width: MediaQuery.sizeOf(context).width, // Toma el ancho de la pantalla
      child: const Column(
        mainAxisSize:
            MainAxisSize
                .max, // MainAxisSize.max para que el Column tome el tamaño maximo
        mainAxisAlignment:
            MainAxisAlignment
                .center, // MainAxisAlignment.start para alinear el texto al inicio
        crossAxisAlignment:
            CrossAxisAlignment
                .center, // CrossAxisAlignment.start para alinear el texto al inicio
        children: [
          Image(
            image: AssetImage('lib/assets/images/logo.png'),
            width: 100,
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Los elementos ocupan solo el espacio necesario
        mainAxisAlignment:
            MainAxisAlignment.center, // Centra los elementos verticalmente
        crossAxisAlignment:
            CrossAxisAlignment.center, // Centra los elementos horizontalmente
        children: [
          Text(
            'Registrate',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 15), // Espacio entre los elementos
          CustomFormField(
            hintText: 'Escribe tu nombre',
            labelText: 'Nombre',
            prefixIcon: Icon(Icons.person),
            validationRegularExp: NAME_VALIDATION_REGEX,
            errorText: errorName,
            hasError: errorName != null,
            onSaved: (value) {
              setState(() {
                name = value;

                if (value != null && !NAME_VALIDATION_REGEX.hasMatch(value)) {
                  errorName = 'Escribe un nombre válido';
                } else {
                  errorName = null;
                }
              });
            },
          ),
          SizedBox(height: 15),
          CustomFormField(
            hintText: 'Escribe tu correo',
            labelText: 'Correo',
            prefixIcon: Icon(Icons.email),
            validationRegularExp: EMAIL_VALIDATION_REGEX,
            errorText: errorEmail,
            hasError: errorEmail != null,
            onSaved: (value) {
              setState(() {
                email = value;

                if (value != null && !EMAIL_VALIDATION_REGEX.hasMatch(value)) {
                  errorEmail = 'Escribe un correo válido';
                } else {
                  errorEmail = null;
                }
              });
            },
          ),
          SizedBox(height: 15),
          CustomFormField(
            hintText: 'Escribe tu contraseña',
            labelText: 'Contraseña',
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible
                    ? Icons.visibility_off
                    : Icons
                        .visibility, // Icono para mostrar o ocultar la contraseña
                color: AppColors.pantone11C,
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible =
                      !isPasswordVisible; // Cambia el estado de la contraseña
                });
              },
            ),
            validationRegularExp: PASSWORD_VALIDATION_REGEX,
            errorText: errorPassword,
            hasError: errorPassword != null, // Si hay un error en la contraseña
            obscureText:
                !isPasswordVisible, // Si isPasswordVisible es true entonces se muestra la contraseña
            onSaved: (value) {
              setState(() {
                password = value;

                if (value != null &&
                    !PASSWORD_VALIDATION_REGEX.hasMatch(value)) {
                  errorPassword = 'Escribe una contraseña válida';
                } else {
                  errorPassword = null;
                }

                // También se puede hacer de esta forma
                /* errorPassword = (value != null &&
                      !PASSWORD_VALIDATION_REGEX.hasMatch(value))
                  ? 'Escribe una contraseña válida'
                  : null; */
              });
            },
          ),
          const SizedBox(height: 15),
          CustomFormField(
            hintText: 'Confirma tu contraseña',
            labelText: 'Confirmar contraseña',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColors.pantone11C,
              ),
              onPressed: () {
                setState(() {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
                });
              },
            ),
            validationRegularExp: RegExp(r'.*'), // Solo que no esté vacío
            errorText: errorConfirmPassword,
            hasError: errorConfirmPassword != null,
            obscureText: !isConfirmPasswordVisible,
            onSaved: (value) {
              setState(() {
                confirmPassword = value;
                if (value != password) {
                  errorConfirmPassword = 'Las contraseñas no coinciden';
                } else {
                  errorConfirmPassword = null;
                }
              });
            },
          ),
          SizedBox(height: 15),
          _registerButton(),
          SizedBox(height: 15),
          _passwordRequirements(),
        ],
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      // SizedBox para limitar el tamaño del contenedor
      width: MediaQuery.sizeOf(context).width, // Toma el ancho de la pantalla
      child: GradientButton(
        text: "Registrate",
        onPressed: () async {
          // onPressed para manejar el evento de presionar el botón

          setState(() {
            isLoading = true; // Actualiza el estado de isLoading a true
          });

          try {
            if ((_registerFormKey.currentState?.validate() ?? false)) {
              // && selectedImage != null
              _registerFormKey.currentState
                  ?.save(); // Guarda el estado del formulario
              bool result = await _authService.signUp(
                email!,
                password!,
              ); // Llama al método signUp del servicio AuthService, los signos de exclamación son para decirle al lenguaje que no puede ser null
              if (result) {
                // Si el resultado es verdadero entonces se guardan los datos del usuario

                // Aqui se guardaba la imagen en Firebase Storage
                //String? pfpURL = await _storageService.uploadUserPfp(file: selectedImage!, uid: _authService.user!.uid); // El uid es el id del usuario proporcionado por Firebase, se guarda en una variable ya qu ela funcion retorna la url de la imagen

                // Aqui se guardan los datos del usuario en Firestore
                await _databaseService.createUserProfile(
                  userProfile: UserProfile(
                    uid: _authService.user!.uid,
                    name: name!,
                    email: email!,
                    //pfpURL: pfpURL,
                  ),
                );

                _alertService.showToast(
                  text: "Usuario registrado correctamente",
                  icon: Icons.check,
                );

                _navigationService
                    .goBack(); // Aunque esto no es necesario se pone para que realmente se elemine la pantalla de registro y se muestre la de home sin problemas
                _navigationService.pushReplacementNamed(
                  "/home",
                ); // Navega a la ruta /home y reemplaza la ruta actual
              } else {
                _alertService.showToast(
                  text: 'Por favor llena todos los campos',
                  icon: Icons.error,
                );
              }
            } else {
              _alertService.showToast(
                text: 'Por favor valida los campos',
                icon: Icons.error,
              );
            }
          } catch (e) {
            _alertService.showToast(
              text: "Ocurrío un error, por favor intenta de nuevo",
              icon: Icons.error,
            );
          }

          setState(() {
            isLoading = false; // Actualiza el estado de isLoading a false
          });
        },
      ),
    );
  }

  Widget _passwordRequirements() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'La contraseña debe contener:',
          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 0.0),
          child: Column(
            children: [
              _buildCenteredBullet('Al menos 8 caracteres'),
              _buildCenteredBullet(
                'Al menos una letra mayúscula, una minúscula, un número y un carácter especial?',
              ),
              _buildCenteredBullet('No debe llevar espacios en blanco'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCenteredBullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.pantone3035C,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: AppColors.pantone11C),
              textAlign:
                  TextAlign.left, // o center si quieres centrar multilínea
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginAccountLink() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("¿Ya tienes una cuenta?"),
        GestureDetector(
          // GestureDetector para manejar el evento de presionar el texto
          onTap: () {
            // onTap para manejar el evento de presionar el texto
            _navigationService.goBack(); // Navega a la ruta anterior
          },
          child: const Text(
            "Inicia sesión",
            style: TextStyle(
              color: AppColors.gradientEnd,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
