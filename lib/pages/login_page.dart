import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:login_chat/config/colors.dart';
import 'package:login_chat/config/responsive_designe.dart';
import 'package:login_chat/consts.dart';
import 'package:login_chat/services/alert_service.dart';
import 'package:login_chat/services/auth_service.dart';
import 'package:login_chat/services/navigation_service.dart';
import 'package:login_chat/widgets/custom_button_gradient.dart';
import 'package:login_chat/widgets/custom_button_icon.dart';
import 'package:login_chat/widgets/custom_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt =
      GetIt.instance; // GetIt.instance es una instancia global de GetIt
  // El GetIt es un contenedor de servicios, se usa para registrar y obtener servicios en toda la aplicación

  final GlobalKey<FormState> _loginFormKey =
      GlobalKey<FormState>(); // GlobalKey para manejar el estado del formulario

  late AuthService
  _authService; // late para que la variable no sea null y le decimos al lenguaje que la variable será inicializada después
  late NavigationService
  _navigationService; // navigationService para manejar la navegación
  late AlertService _alertService; // alertService para mostrar alertas

  String? errorEmail, // Variable para guardar el error del email
      email,
      errorPassword, // Variables para guardar el errorde la contraseña
      password; // Variables para guardar el email y la contraseña

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
  }

  @override
  /* Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Para evitar que el teclado haga resize de la pantalla
      body: _buildUI(),
    );
  } */
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
    // Metodo para construir la UI en dispositivos móviles
    return _buildUI();
  }

  Widget _buildTabletUI() {
    // Metodo para construir la UI en dispositivos tablet
    return _buildUI();
  }

  Widget _buildDesktopUI() {
    // Metodo para construir la UI en dispositivos de escritorio
    return Center(child: SizedBox(width: 500.0, child: _buildUI()));
  }

  Widget _buildUI() {
    return SafeArea(
      // SafeArea para evitar que el contenido se superponga con la barra de estado, barra de navegación y barra de notificaciones
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ), // padding de toda la pantalla
        child: Center(
          child: Column(
            children: [
              _headerText(),

              // Centrando el formulario
              Spacer(), // Spacer para ocupar el espacio restante
              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(child: _loginForm()),
              ),
              Spacer(), // Spacer para ocupar el espacio restante
              _createAnAccountLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      // SizedBox para limitar el tamaño del contenedor
      width: MediaQuery.sizeOf(context).width, // Toma el ancho de la pantalla
      child: Column(
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
          Image(image: AssetImage('lib/assets/images/logo.png'),
            width: 100,
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _loginFormKey, // Asigna la llave al formulario
      child: Column(
        mainAxisSize:
            MainAxisSize
                .min, // MainAxisSize.min para que el Column tome el tamaño minimo
        mainAxisAlignment:
            MainAxisAlignment
                .center, // MainAxisAlignment.spaceAround para que los elementos se distribuyan de manera uniforme
        crossAxisAlignment:
            CrossAxisAlignment
                .center, // CrossAxisAlignment.center para alinear los elementos al centro
        // Form para manejar el estado del formulario
        children: [
          Text(
            'Iniciar sesión',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 15), // Espacio entre los elementos
          CustomFormField(
            hintText: 'Escribe tu correo',
            labelText: 'Correo',
            prefixIcon: Icon(Icons.email),
            validationRegularExp: EMAIL_VALIDATION_REGEX,
            // Muetsra un mensaje de error si el email no es valido
            errorText: errorEmail,
            hasError: errorEmail != null,
            onSaved: (value) {
              setState(() {
                // setState para actualizar el estado de la variable email declarada arriba en la clase
                email = value;

                // Validar el email, si no es valido, muestra un mensaje de error
                if (value != null && !EMAIL_VALIDATION_REGEX.hasMatch(value)) {
                  errorEmail = 'Escribe un correo válido';
                } else {
                  errorEmail = null;
                }
              });
            },
          ),
          SizedBox(height: 15), // Espacio entre los elementos
          CustomFormField(
            hintText: 'Escribe tu contraseña',
            labelText: 'Contraseña',
            prefixIcon: Icon(Icons.lock),
            validationRegularExp: PASSWORD_VALIDATION_REGEX,
            obscureText: true,
            // Muetsra un mensaje de error si la contraseña no es valida
            errorText: errorPassword,
            hasError: errorPassword != null,
            onSaved: (value) {
              setState(() {
                // setState para actualizar el estado de la variable password declarada arriba en la clase
                password = value;

                // Validar la contraseña, si no es valida, muestra un mensaje de error
                if (value != null &&
                    !PASSWORD_VALIDATION_REGEX.hasMatch(value)) {
                  errorPassword = 'Escribe una contraseña válida';
                } else {
                  errorPassword = null;
                }
              });
            },
          ),

          SizedBox(height: 10), // Espacio entre los elementos
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿Olvidaste tu contraseña? ',
                style: TextStyle(
                  color: AppColors.softBlack,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                // GestureDetector para manejar el evento de presionar el texto
                onTap: () {
                  // onTap para manejar el evento de presionar el texto
                  _navigationService.pushNamed(
                    "/register",
                  ); // Navega a la ruta /register
                },
                child: const Text(
                  "Ayuda",
                  style: TextStyle(
                    color: AppColors.gradientEnd,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10), // Espacio entre los elementos

          _loginButton(),

          SizedBox(height: 10), // Espacio entre los elementos
          Text(
            'O inicia sesión con',
            style: TextStyle(color: AppColors.softBlack),
          ),
          SizedBox(height: 10), // Espacio entre los elementos
          // Botones de Google y Facebook
          Column(
            children: [
              IconButtonCustom(
                text: "Continuar con Facebook",
                iconPath: 'lib/assets/icons/facebook.svg',
                backgroundColor: AppColors.gradientEnd,
                textColor: Colors.white,
                onPressed: () {
                  // Tu acción aquí
                },
              ),

              SizedBox(height: 15), // Espacio entre los elementos

              IconButtonCustom(
                text: "Continuar con Google",
                iconPath: 'lib/assets/icons/google.svg',
                backgroundColor: AppColors.lightGray,
                textColor: AppColors.softBlack,
                onPressed: () {
                  // Tu acción aquí
                },
              ),

              SizedBox(height: 15), // Espacio entre los elementos

              IconButtonCustom(
                text: "Continuar con Teléfono",
                iconPath: 'lib/assets/icons/phone.svg',
                backgroundColor: AppColors.pantone11C,
                textColor: AppColors.offWhite,
                onPressed: () {
                  // Tu acción aquí
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      // SizedBox para limitar el tamaño del contenedor
      width: MediaQuery.sizeOf(context).width, // Toma el ancho de la pantalla
      child: GradientButton(
        text: "Iniciar sesión",
        onPressed: () async {
          // onPressed para manejar el evento de presionar el botón
          try {
            if (_loginFormKey.currentState?.validate() ?? false) {
              // La traduccion de la linea anterior es: si el formulario es valido, entonces. el ? es para hacer una pregunta, si el formulario es null, entonces, retorna false
              _loginFormKey.currentState
                  ?.save(); // Guarda el estado del formulario
              bool result = await _authService.login(
                email!,
                password!,
              ); // Llama al método login del servicio AuthService, los signos de exclamación son para decirle al lenguaje que no puede ser null

              if (result) {
                _alertService.showToast(
                  text: 'Inicio de sesión exitoso',
                  icon: Icons.check,
                ); // Muestra un mensaje de éxito

                _navigationService.pushReplacementNamed(
                  "/home",
                ); // Navega a la ruta /home y reemplaza la ruta actual
              } else {
                _alertService.showToast(
                  text: 'Error al iniciar sesión',
                  icon: Icons.error,
                ); // Muestra un mensaje de error
              }
            } else {
              _alertService.showToast(
                text: 'Por favor ingresa tus credenciales',
                icon: Icons.error,
              ); // Muestra un mensaje de error
            }
          } catch (e) {
            _alertService.showToast(
              text: "Un error ocurrió, por favor intenta de nuevo",
              icon: Icons.error,
            );
          }
        },
      ),
    );
  }

  Widget _createAnAccountLink() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            const Text("¿No tienes una cuenta? "),
            GestureDetector(
              // GestureDetector para manejar el evento de presionar el texto
              onTap: () {
                // onTap para manejar el evento de presionar el texto
                _navigationService.pushNamed(
                  "/register",
                ); // Navega a la ruta /register
              },
              child: const Text(
                "Regístrate aquí",
                style: TextStyle(
                  color: AppColors.gradientEnd,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15), // Espacio entre los elementos
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              "Al registrarse, acepta nuestros ",
              style: TextStyle(fontSize: 10),
            ),
            GestureDetector(
              // GestureDetector para manejar el evento de presionar el texto
              onTap: () {
                // onTap para manejar el evento de presionar el texto
                _navigationService.pushNamed(
                  "/register",
                ); // Navega a la ruta /register
              },
              child: const Text(
                "Términos & Política de Privacidad",
                style: TextStyle(
                  color: AppColors.gradientEnd,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
