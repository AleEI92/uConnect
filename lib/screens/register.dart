
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:u_connect/http/base_client.dart';
import '../custom_widgets/background_decor.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final int minPassInput = 8;
  final int maxPassInput = 12;
  String password = '';

  // KEYS PARA LOS FORMULARIOS
  final _studentFormKey = GlobalKey<FormState>();
  final _companyFormKey = GlobalKey<FormState>();
  ////////////////////////////
  // VALORES PARA CAMBIOS DE ESTADO
  var _isStudentForm = true;
  var _passHide = true;
  var _passConfirmHide = true;
  var _selectedCarrera = '';
  var _selectedShadowButton = true;
  late Future<dynamic> data;
  /////////////////////////////////

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    data = getCarreras();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: SafeArea(
        child: FutureBuilder<dynamic>(
          future: data,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              // LOGICA DE ERROR DE SERVICIO
              return CupertinoAlertDialog(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_rounded,
                      color: Colors.red,
                      size: 28,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Oops...',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                content: const Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Algo ha fallado. Por favor inténtelo de nuevo.',
                      style: TextStyle(
                        fontSize: 14,
                      ),),
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Aceptar'),
                  ),
                ],
              );
            }
            else if (snapshot.hasData) {
              return Container(
                decoration: myAppBackground(),
                width: double.maxFinite,
                height: double.maxFinite,
                constraints: const BoxConstraints.expand(),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: double.maxFinite,
                      color: Colors.blue[300],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shadowColor: _selectedShadowButton
                                      ? MaterialStateProperty.all(
                                      Colors.cyan[50])
                                      : MaterialStateProperty.all(Colors.black),
                                  minimumSize: MaterialStateProperty.all(
                                      const Size(0, 45)),
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.white10),
                                ),
                                child: const Text(
                                  'ESTUDIANTE',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  if (!_isStudentForm) {
                                    setState(() {
                                      _isStudentForm = true;
                                      _selectedShadowButton = true;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shadowColor: !_selectedShadowButton
                                      ? MaterialStateProperty.all(
                                      Colors.cyan[50])
                                      : MaterialStateProperty.all(Colors.black),
                                  minimumSize: MaterialStateProperty.all(
                                      const Size(0, 45)),
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.white10),
                                ),
                                child: const Text(
                                  'EMPRESA',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  if (_isStudentForm) {
                                    setState(() {
                                      _isStudentForm = false;
                                      _selectedShadowButton = false;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: _isStudentForm ? studentForm(snapshot.data as List<String>) : companyForm(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            // SE MUESTRA PROGRESO
            else {
              return const SpinKitRipple(
                color: Colors.cyan,
                size: 80.0,
              );
            }
          },
        ),
      ),
    );
  }

  Widget studentForm(List<String> carreras) {
    return Form(
      key: _studentFormKey,
      child: Card(
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8.0,
        color: Colors.cyan[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 32),
          child: Column(
            children: [
              // FULL NAME
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Debe insertar un nombre para el registro.';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 15.0),
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_2_rounded),
                    border: OutlineInputBorder(),
                    labelText: 'Nombre completo',
                    hintText: 'Ingrese nombre completo'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              // USER EMAIL
              TextFormField(
                validator: (value) {
                  return mailValidation(value);
                },
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 15.0),
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_rounded),
                    border: OutlineInputBorder(),
                    labelText: 'Correo',
                    hintText: 'Ingrese correo válido'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              // USER PHONE NUMBER
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Debe insertar un número de celular.';
                  }
                  else if (!value.startsWith('099') &&
                      !value.startsWith('098') &&
                      !value.startsWith('097') &&
                      !value.startsWith('096')) {
                    return 'Formato de número de celular incorrecto.';
                  }
                  else if (value.length < 10) {
                    return 'El campo debe tener 10 números exactos.';
                  }
                  return null;
                },
                maxLength: 10,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 15.0),
                decoration: const InputDecoration(
                    counterText: '',
                    prefixIcon: Icon(Icons.phone_android_rounded),
                    border: OutlineInputBorder(),
                    labelText: 'Celular',
                    hintText: 'Ingrese su nro de celular'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              DropdownButtonFormField<String>(
                validator: (value) {
                  if (_selectedCarrera.isEmpty) {
                    return ('Debe seleccionar una carrera.');
                  }
                  return null;
                },
                icon: const Icon(Icons.keyboard_arrow_down),
                items: carreras.map((name) {
                  return DropdownMenuItem<String>(
                    value: name,
                    child: Text(name),
                  );
                }).toList(),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Seleccione su carrera:'),
                onChanged: (value) {
                  setState(() {
                    _selectedCarrera = value.toString();
                  });
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              // USER PASSWORD
              TextFormField(
                validator: (value) {
                  return passwordValidation(value);
                },
                maxLength: maxPassInput,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _passHide,
                style: const TextStyle(fontSize: 15.0),
                decoration: InputDecoration(
                    counterText: '',
                    prefixIcon: const Icon(Icons.key_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passHide
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          _passHide = !_passHide;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Contraseña',
                    hintText: 'Ingrese contraseña segura'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              // USER PASSWORD CONFIRMATION
              TextFormField(
                validator: (value) {
                  return passwordConfirmValidation(value);
                },
                maxLength: maxPassInput,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _passConfirmHide,
                style: const TextStyle(fontSize: 15.0),
                decoration: InputDecoration(
                    counterText: '',
                    prefixIcon: const Icon(Icons.key_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passConfirmHide
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          _passConfirmHide = !_passConfirmHide;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Confirmar contraseña',
                    hintText: 'Ingrese su contraseña'),
              ),
              const SizedBox(
                height: 50.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(200, 45)),
                  backgroundColor: MaterialStateProperty.all(Colors.white54),
                ),
                child: const Text(
                  'REGISTRAR',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => {
                  if (!_studentFormKey.currentState!.validate()) {

                  }
                  else {

                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget companyForm() {
    return Form(
      key: _companyFormKey,
      child: Card(
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8.0,
        color: Colors.cyan[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 32),
          child: Column(
            children: [
              // COMPANY NAME
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Debe insertar un nombre para el registro.';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 15.0),
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_2_rounded),
                    border: OutlineInputBorder(),
                    labelText: 'Nombre de la empresa',
                    hintText: 'Ingrese nombre de la empresa'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              // COMPANY EMAIL
              TextFormField(
                validator: (value) {
                  return mailValidation(value);
                },
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 15.0),
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_rounded),
                    border: OutlineInputBorder(),
                    labelText: 'Correo',
                    hintText: 'Ingrese correo válido'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              // COMPANY PHONE
              /*TextFormField(
                maxLength: 10,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 15.0),
                decoration: const InputDecoration(
                    counterText: '',
                    prefixIcon: Icon(Icons.phone_android_rounded),
                    border: OutlineInputBorder(),
                    labelText: 'Celular',
                    hintText: 'Ingrese su nro de celular'),
              ),*/
              /*const SizedBox(
                height: 20.0,
              ),*/
              // COMPANY PASSWORD
              TextFormField(
                validator: (value) {
                  return passwordValidation(value);
                },
                maxLength: maxPassInput,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _passHide,
                style: const TextStyle(fontSize: 15.0),
                decoration: InputDecoration(
                    counterText: '',
                    prefixIcon: const Icon(Icons.key_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passHide
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          _passHide = !_passHide;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Contraseña',
                    hintText: 'Ingrese contraseña segura'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              // COMPANY PASSWORD CONFIRMATION
              TextFormField(
                validator: (value) {
                  return passwordConfirmValidation(value);
                },
                maxLength: maxPassInput,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _passConfirmHide,
                style: const TextStyle(fontSize: 15.0),
                decoration: InputDecoration(
                    counterText: '',
                    prefixIcon: const Icon(Icons.key_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passConfirmHide
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          _passConfirmHide = !_passConfirmHide;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Confirmar contraseña',
                    hintText: 'Ingrese su contraseña'),
              ),
              const SizedBox(
                height: 50.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(200, 45)),
                  backgroundColor: MaterialStateProperty.all(Colors.white54),
                ),
                child: const Text(
                  'REGISTRAR',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => {
                  if (!_companyFormKey.currentState!.validate()) {

                  }
                  else {

                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? passwordValidation(String? value) {
    if (value == null || value.isEmpty || value.length < minPassInput) {
      password = '';
      return 'La contraseña debe tener mínimo 8 caracteres.';
    }
    password = value;
    return null;
  }

  String? passwordConfirmValidation(String? value) {
    if (value == null || value.isEmpty || value != password) {
      return 'Las contraseñas deben ser iguales.';
    }
    return null;
  }

  String? mailValidation(String? value) {
    if (value == null || !EmailValidator.validate(value)) {
      return 'Ingrese un correo válido.';
    }
    return null;
  }

  Future<dynamic> getCarreras() async {
    var response = await MyBaseClient().getCarreras();
    return response;
  }
}
