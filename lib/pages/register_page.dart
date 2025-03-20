
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
  late DatabaseService _databaseService; // databaseService para manejar la base de datos

  bool isLoading = false; // Variable para manejar el estado de carga
  String?
  name,
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
    _databaseService = _getIt.get<DatabaseService>(); // Obtiene el servicio DatabaseService
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
     return Center(
      child: SizedBox(
        width: 500.0,
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: [
            _headerText(),

            // Todo este contenido de abajo es para el formulario de registro que quede centrado
            Spacer(), // El spacer se usa para agregar espacio flexible
            Align(
              // Align para alinear el contenido al centro
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: isLoading
                  ? CircularProgressIndicator()
                  : SingleChildScrollView(child: _registerForm()),
              ),
            ),
            Spacer(), // Agrega espacio flexible abajo

            if (!isLoading)
              _loginAccountLink(), // Si no está cargando muestra el link para ir a la pantalla de login

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
          Text(
            "Regístrate",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
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
          // _pfpSelectionField(),
          SizedBox(height: 15), // Espacio entre los elementos
          CustomFormField(
            hintText: 'Enter your name',
            labelText: 'Name',
            prefixIcon: Icon(Icons.person),
            validationRegularExp: NAME_VALIDATION_REGEX,
            onSaved: (value) {
              setState(() {
                name = value;
              });
            },
          ),
          SizedBox(height: 15),
          CustomFormField(
            hintText: 'Enter your email',
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
            validationRegularExp: EMAIL_VALIDATION_REGEX,
            onSaved: (value) {
              setState(() {
                email = value;
              });
            },
          ),
          SizedBox(height: 15),
          CustomFormField(
            hintText: 'Enter your password',
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),
            validationRegularExp: PASSWORD_VALIDATION_REGEX,
            obscureText: true,
            onSaved: (value) {
              setState(() {
                password = value;
              });
            },
          ),
          SizedBox(height: 15),
          _registerButton(),
        ],
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      // SizedBox para limitar el tamaño del contenedor
      width: MediaQuery.sizeOf(context).width, // Toma el ancho de la pantalla
      child: GradientButton(
        text: "Register",
        onPressed: () async {
          // onPressed para manejar el evento de presionar el botón

          setState(() {
            isLoading = true; // Actualiza el estado de isLoading a true
          });

          try {
            if ((_registerFormKey.currentState?.validate() ?? false)) {  // && selectedImage != null
              _registerFormKey.currentState
                  ?.save(); // Guarda el estado del formulario
              bool result = await _authService.signUp(
                email!,
                password!,
              ); // Llama al método signUp del servicio AuthService, los signos de exclamación son para decirle al lenguaje que no puede ser null
              if (result) { // Si el resultado es verdadero entonces se guardan los datos del usuario
                
                // Aqui se guardaba la imagen en Firebase Storage
                //String? pfpURL = await _storageService.uploadUserPfp(file: selectedImage!, uid: _authService.user!.uid); // El uid es el id del usuario proporcionado por Firebase, se guarda en una variable ya qu ela funcion retorna la url de la imagen

                // Aqui se guardan los datos del usuario en Firestore
                await _databaseService.createUserProfile(
                  userProfile: UserProfile(
                    uid: _authService.user!.uid,
                    name: name!,
                    //pfpURL: pfpURL,
                  ),
                );

                _alertService.showToast(
                  text: "Account created successfully",
                  icon: Icons.check,
                );

                _navigationService.goBack(); // Aunque esto no es necesario se pone para que realmente se elemine la pantalla de registro y se muestre la de home sin problemas
                _navigationService.pushReplacementNamed("/home"); // Navega a la ruta /home y reemplaza la ruta actual
              } else {
                _alertService.showToast(
                  text: 'Failed to register, Please try again',
                  icon: Icons.error,
                );
              }
            } else {
              _alertService.showToast(
                text: 'Please fill all the fields',
                icon: Icons.error,
              );
            }
          } catch (e) {
            _alertService.showToast(
              text: "An error occurred, please try again",
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

  Widget _loginAccountLink() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text("Already have an account? "),
          GestureDetector(
            // GestureDetector para manejar el evento de presionar el texto
            onTap: () {
              // onTap para manejar el evento de presionar el texto
              _navigationService.goBack(); // Navega a la ruta anterior
            },
            child: const Text(
              "Login",
              style: TextStyle(color: AppColors.gradientEnd, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
