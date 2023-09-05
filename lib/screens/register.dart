
import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:u_connect/http/services.dart';
import 'package:u_connect/models/carreras_response.dart';
import 'package:u_connect/models/generic_post_ok.dart';
import 'package:u_connect/models/registro_company_body.dart';
import 'package:u_connect/models/registro_estudiante_body.dart';
import '../common/utils.dart';
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
  var _isLoading = true;

  // KEYS PARA LOS FORMULARIOS
  final _studentFormKey = GlobalKey<FormState>();
  final studentMailControl = TextEditingController();
  final studentNameControl = TextEditingController();
  final studentPassControl = TextEditingController();
  final studentPhoneControl = TextEditingController();

  final _companyFormKey = GlobalKey<FormState>();
  final companyMailControl = TextEditingController();
  final companyNameControl = TextEditingController();
  final companyPassControl = TextEditingController();
  ////////////////////////////
  // VALORES PARA CAMBIOS DE ESTADO
  var _isStudentForm = true;
  var _passHide = true;
  var _passConfirmHide = true;
  var _selectedCarrera = '';
  var _selectedShadowButton = true;
  late Future<List<Carrera>> data;
  /////////////////////////////////

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() {
      Utils(context).startLoading();
    });
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
            if (snapshot.connectionState == ConnectionState.done) {
              if (_isLoading) {
                Utils(context).stopLoading();
                _isLoading = false;
              }
              // ERROR EN SERVICIO DE CARRERAS
              if (snapshot.hasError) {
                return myDialog();
              }
              // MOSTRAMOS FORMULARIOS
              else if (snapshot.hasData) {
                return showForms(snapshot, context);
              }
              else {
                return Container();
              }
            }
            else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget studentForm(List<Carrera> carreras, BuildContext context) {
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
                controller: studentNameControl,
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
                controller: studentMailControl,
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
                controller: studentPhoneControl,
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
                    hintText: 'Ingrese su número de celular'),
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
                items: carreras.map((carrera) {
                  return DropdownMenuItem<String>(
                    value: carrera.name,
                    child: Text(carrera.name),
                  );
                }).toList(),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Carrera",
                    hintText: 'Seleccione su carrera:'),
                onChanged: (value) {
                  //setState(() {
                    _selectedCarrera = value.toString();
                  //});
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              // USER PASSWORD
              TextFormField(
                controller: studentPassControl,
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
                onPressed: () async {
                  if (_studentFormKey.currentState!.validate()) {
                    Utils(context).startLoading();
                    callStudentFunction().then((value) {
                      Utils(context).stopLoading();
                      if (value.message == "OK") {
                        AwesomeDialog(
                            context: context,
                            dismissOnTouchOutside: false,
                            dismissOnBackKeyPress: false,
                            dialogType: DialogType.success,
                            headerAnimationLoop: false,
                            animType: AnimType.bottomSlide,
                            title: '¡Registro exitoso!',
                            desc:
                            'Se ha registrado correctamente. Ya puede iniciar sesión.',
                            buttonsTextStyle:
                            const TextStyle(color: Colors.black),
                            showCloseIcon: false,
                            btnOkText: 'ACEPTAR',
                            btnOkOnPress: () {
                              Navigator.of(context).pop(true);
                            }).show();
                      }
                    }).onError((error, stackTrace) {
                      Utils(context).stopLoading();
                      Utils(context).showErrorDialog(error.toString()).show();
                    });
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
                controller: companyNameControl,
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
                controller: companyMailControl,
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
                controller: companyPassControl,
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
                onPressed: () async {
                  if (_companyFormKey.currentState!.validate()) {
                    Utils(context).startLoading();
                    callCompanyFunction().then((value) {
                      Utils(context).stopLoading();
                      if (value.message == "OK") {
                        AwesomeDialog(
                            context: context,
                            dismissOnTouchOutside: false,
                            dismissOnBackKeyPress: false,
                            dialogType: DialogType.success,
                            headerAnimationLoop: false,
                            animType: AnimType.bottomSlide,
                            title: '¡Registro exitoso!',
                            desc:
                            'Se ha registrado correctamente. Ya puede iniciar sesión.',
                            buttonsTextStyle:
                            const TextStyle(color: Colors.black),
                            showCloseIcon: false,
                            btnOkText: 'ACEPTAR',
                            btnOkOnPress: () {
                              Navigator.of(context).pop(true);
                            }).show();
                      }
                    }).onError((error, stackTrace) {
                      Utils(context).stopLoading();
                      Utils(context).showErrorDialog(error.toString()).show();
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showForms(AsyncSnapshot<dynamic> snapshot, BuildContext context) {
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
                child: _isStudentForm ? studentForm(snapshot.data as List<Carrera>, context) : companyForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget myDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
      ),
      elevation: 8,
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width *(2/3),
        decoration: BoxDecoration(
          color: Colors.cyan[300],
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(
                  Icons.error_rounded,
                  color: Colors.red,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              // TITULO
              child: Text(
                'Oops.. Ha ocurrido un error.',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              // DESCRIPCION
              child: Text(
                'Intente de nuevo por favor.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // BOTON SI
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                    ),
                    child: const Text(
                      'ACEPTAR',
                      style: TextStyle(
                        color: Colors.cyan,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 18,
            ),
          ],
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

  Future<GenericOkPost> callStudentFunction() async {
    var body = RegistroUser(
        email: studentMailControl.value.text,
        fullName: studentNameControl.value.text,
        phoneNumber: studentPhoneControl.value.text,
        password: studentPassControl.value.text,
        career: _selectedCarrera);

    return await postRegisterStudent(registroUserToJson(body));
  }

  Future<GenericOkPost> postRegisterStudent(Object body) async {
    var response = await MyBaseClient().postRegistrarEstudiante(body);
    return response;
  }

  Future<GenericOkPost> callCompanyFunction() async {
    var body = RegistroCompany(
        email: companyMailControl.value.text,
        name: companyNameControl.value.text,
        password: companyPassControl.value.text);

    return await postRegisterCompany(registroCompanyToJson(body));
  }

  Future<GenericOkPost> postRegisterCompany(Object body) async {
    var response = await MyBaseClient().postRegistrarCompanhia(body);
    return response;
  }

  // SERVICIOS A EJECUTAR EN PANTALLA
  Future<List<Carrera>> getCarreras() async {
    var response = await MyBaseClient().getCarreras();
    //var listCarreras = [Carreras(name: 'Ambiental', id: 1), Carreras(name: 'Electronica', id: 2)];
    //var response = listCarreras;
    return response;
  }
}
