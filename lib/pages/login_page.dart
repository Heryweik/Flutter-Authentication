import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:login_chat/consts.dart';
import 'package:login_chat/services/alert_service.dart';
import 'package:login_chat/services/auth_service.dart';
import 'package:login_chat/services/navigation_service.dart';
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

  String?
  email,
  password; // Variables para guardar el email y la contraseña, el ? es para que puedan ser null

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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Para evitar que el teclado haga resize de la pantalla
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      // SafeArea para evitar que el contenido se superponga con la barra de estado, barra de navegación y barra de notificaciones
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ), // padding de toda la pantalla
        child: Column(
          children: [_headerText(),

          // Centrando el formulario
          Spacer(), // Spacer para ocupar el espacio restante
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: _loginForm(),
            ),
          ),
          Spacer(), // Spacer para ocupar el espacio restante
          
          _createAnAccountLink()],
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
                .start, // MainAxisAlignment.start para alinear el texto al inicio
        crossAxisAlignment:
            CrossAxisAlignment
                .start, // CrossAxisAlignment.start para alinear el texto al inicio
        children: [
          Text(
            'Hi, Welcome back!',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
          ),
          Text(
            "Hello again, you've been missed!",
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
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
            CustomFormField(
              hintText: 'Enter your email',
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              validationRegularExp: EMAIL_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  // setState para actualizar el estado de la variable email declarada arriba en la clase
                  email = value;
                });
              },
            ),
            SizedBox(height: 20), // Espacio entre los elementos
            CustomFormField(
              hintText: 'Enter your password',
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              validationRegularExp: PASSWORD_VALIDATION_REGEX,
              obscureText: true,
              onSaved: (value) {
                setState(() {
                  // setState para actualizar el estado de la variable password declarada arriba en la clase
                  password = value;
                });
              },
            ),
            SizedBox(height: 20), // Espacio entre los elementos
            _loginButton(),
          ],
        ),
      );
  }

  Widget _loginButton() {
    return SizedBox(
      // SizedBox para limitar el tamaño del contenedor
      width: MediaQuery.sizeOf(context).width, // Toma el ancho de la pantalla
      child: MaterialButton(
        // MaterialButton para darle un estilo de botón
        height:
            MediaQuery.sizeOf(context).height *
            0.07, // Toma el 5% de la pantalla
        onPressed: () async {
          // onPressed para manejar el evento de presionar el botón
          if (_loginFormKey.currentState?.validate() ?? false) {
            // La traduccion de la linea anterior es: si el formulario es valido, entonces. el ? es para hacer una pregunta, si el formulario es null, entonces, retorna false
            _loginFormKey.currentState
                ?.save(); // Guarda el estado del formulario
            bool result = await _authService.login(
              email!,
              password!,
            ); // Llama al método login del servicio AuthService, los signos de exclamación son para decirle al lenguaje que no puede ser null

            if (result) {
              // Aqui podria ir una alerta de que el login fue exitoso
              _navigationService.pushReplacementNamed(
                "/home",
              ); // Navega a la ruta /home y reemplaza la ruta actual
            } else {
              _alertService.showToast(
                text: 'Failed to login, Please try again',
                icon: Icons.error,
              ); // Muestra un mensaje de error
            }
          }
        },
        color:
            Theme.of(context)
                .colorScheme
                .primary, // Toma el color primario del tema, Theme se usa para acceder a los colores del tema
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ),
    );
  }

  Widget _createAnAccountLink() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text("Don't have an account? "),
          GestureDetector( // GestureDetector para manejar el evento de presionar el texto
            onTap: () { // onTap para manejar el evento de presionar el texto
              _navigationService.pushNamed("/register"); // Navega a la ruta /register
            },
            child: const Text(
              "Sing up",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
