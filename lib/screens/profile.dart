
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:u_connect/models/carreras_response.dart';
import 'package:u_connect/models/company_login_response.dart';
import 'package:u_connect/models/editar_company_body.dart';
import 'package:u_connect/models/editar_user_body.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../common/constants.dart';
import '../common/session.dart';
import '../common/utils.dart';
import '../custom_widgets/background_decor.dart';
import '../http/services.dart';
import '../models/student_login_response.dart';
import 'package:http_parser/http_parser.dart';

import 'home.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {

  late Session _session;
  var _selectedCarrera = '';

  // KEYS PARA LOS FORMULARIOS
  final _studentFormKey = GlobalKey<FormState>();
  final studentMailControl = TextEditingController();
  final studentNameControl = TextEditingController();
  final studentPhoneControl = TextEditingController();

  final companyMailControl = TextEditingController();
  final companyNameControl = TextEditingController();
  /////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _session = Session.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: SafeArea(
          child: Container(
        decoration: myAppBackground(),
        width: double.maxFinite,
        height: double.maxFinite,
        constraints: const BoxConstraints.expand(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: SingleChildScrollView(
            child: _session.isStudent
                ? studentForm(_session.allCarreras!)
                : companyForm(),
          ),
        ),
      )),
    );
  }

  void setInitialValues() {
    if (_session.isStudent) {
      studentNameControl.text = _session.userName;
      studentMailControl.text = _session.userEmail;
      studentPhoneControl.text = _session.userPhoneNumber;
      _selectedCarrera = _session.userCareer;
    }
    else {
      companyNameControl.text = _session.userName;
      companyMailControl.text = _session.userEmail;
    }
  }

  Widget studentForm(List<Carrera> carreras) {

    setInitialValues();

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
                  else if (value.length != 10) {
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
                value: carreras.firstWhere((element) => element.name == _selectedCarrera).name,
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
                    hintText: 'Seleccione su carrera:'),
                onChanged: (value) {
                  _selectedCarrera = value.toString();
                },
              ),
              const SizedBox(
                height: 30.0,
              ),
              InkWell(
                child: const Icon(Icons.file_present_rounded, size: 56),
                onTap: () async {
                  chooseFile(_session.userID, _session.isStudent);
                },
              ),
              const Text(
                "Cargar archivo",
              ),
              const SizedBox(
                height: 50.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(200, 45)),
                  backgroundColor: MaterialStateProperty.all(Colors.black45),
                ),
                child: const Text(
                  'ACTUALIZAR',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  if (_studentFormKey.currentState!.validate()) {
                    Utils(context).startLoading();
                    var body = EditarUserBody(fullName: studentNameControl.value.text,
                        email: studentMailControl.value.text,
                        phoneNumber: studentPhoneControl.value.text,
                        career: _selectedCarrera);

                    await MyBaseClient().putUpdateUser(
                        _session.userID, editarUserBodyToJson(body))
                    .then((value) {
                      if (context.mounted) { Utils(context).stopLoading();}
                      if (value != null && value is User) {
                        _session.setSessionData(
                            StudentLoginResponse(
                                user: value,
                                accessToken: _session.userToken
                            )
                        );
                        AwesomeDialog(
                            context: context,
                            dismissOnTouchOutside: false,
                            dismissOnBackKeyPress: false,
                            dialogType: DialogType.success,
                            headerAnimationLoop: false,
                            animType: AnimType.bottomSlide,
                            title: '¡Actualización exitosa!',
                            desc:
                            'Se ha editado sus datos correctamente.',
                            buttonsTextStyle:
                            const TextStyle(color: Colors.black),
                            showCloseIcon: false,
                            btnOkText: 'ACEPTAR',
                            btnOkOnPress: () {
                              //Navigator.of(context).pop(true);
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                  builder: (context) => const Home()), (Route route) => false);
                            }).show();
                      }
                    }).onError((error, stackTrace) {
                      if (context.mounted) { Utils(context).stopLoading();}
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
    setInitialValues();

    return Card(
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
                  labelText: 'Nombre completo',
                  hintText: 'Ingrese nombre completo'),
            ),
            const SizedBox(
              height: 20.0,
            ),
            // USER EMAIL
            TextFormField(
              controller: companyMailControl,
              keyboardType: TextInputType.text,
              style: const TextStyle(fontSize: 15.0),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_rounded),
                  border: OutlineInputBorder(),
                  labelText: 'Correo',
                  hintText: 'Ingrese correo válido'),
            ),
            const SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(200, 45)),
                backgroundColor: MaterialStateProperty.all(Colors.black45),
              ),
              child: const Text(
                'ACTUALIZAR',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                if (companyNameControl.value.text.isNotEmpty &&
                    companyMailControl.value.text.isNotEmpty) {
                  Utils(context).startLoading();
                  var body = EditarEmpresaBody(name: companyNameControl.value.text,
                      email: companyMailControl.value.text);

                  await MyBaseClient().putUpdateUser(
                      _session.userID, editarEmpresaBodyToJson(body))
                      .then((value) {
                    if (context.mounted) { Utils(context).stopLoading();}
                    if (value != null && value is EditarEmpresaBody) {
                      _session.setSessionData(
                          CompanyLoginResponse(
                              company: Company(id: _session.userID,
                                  email: value.email, name: value.name),
                              accessToken: _session.userToken
                          )
                      );
                      AwesomeDialog(
                          context: context,
                          dismissOnTouchOutside: false,
                          dismissOnBackKeyPress: false,
                          dialogType: DialogType.success,
                          headerAnimationLoop: false,
                          animType: AnimType.bottomSlide,
                          title: '¡Actualización exitosa!',
                          desc:
                          'Se ha editado sus datos correctamente.',
                          buttonsTextStyle:
                          const TextStyle(color: Colors.black),
                          showCloseIcon: false,
                          btnOkText: 'ACEPTAR',
                          btnOkOnPress: () {
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                builder: (context) => const Home()), (Route route) => false);
                          }).show();
                    }
                  }).onError((error, stackTrace) {
                    if (context.mounted) { Utils(context).stopLoading();}
                    Utils(context).showErrorDialog(error.toString()).show();
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void chooseFile(int id, bool isStudent) async {
    String userType = Constants.company;
    if (isStudent) {
      userType = Constants.user;
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf']
    );

    if (result != null) {
      final file = result.files.first;
      final fileSizeMB = file.size/(1000*1000);
      print("MB: $fileSizeMB");

      if (file.path != null && context.mounted) {
        Utils(context).startLoading();
        String fileExtension = "pdf";
        String type = "application";

        final httpFile = http.MultipartFile.fromBytes(
            'file',
            File(file.path!).readAsBytesSync(),
            contentType: MediaType(type, fileExtension),
            filename: file.name
        );
        await MyBaseClient().postUploadFile(
            id, userType,
            fileExtension,
            httpFile
        ).then((value) {
          Utils(context).stopLoading();
          AwesomeDialog(
              context: context,
              dismissOnTouchOutside: false,
              dismissOnBackKeyPress: false,
              dialogType: DialogType.success,
              headerAnimationLoop: false,
              animType: AnimType.bottomSlide,
              title: '¡Archivo subido exitosamente!',
              desc:
              'Se ha adjuntado un pdf a su usuario.',
              buttonsTextStyle:
              const TextStyle(color: Colors.black),
              showCloseIcon: false,
              btnOkText: 'ACEPTAR',
              btnOkOnPress: () {}).show();
        }).onError((error, stackTrace) {
          Utils(context).stopLoading();
          Utils(context).showErrorDialog(error.toString()).show();
        });
      }
    } else {
      // User canceled the picker
    }
  }

  String? mailValidation(String? value) {
    if (value == null || !EmailValidator.validate(value)) {
      return 'Ingrese un correo válido.';
    }
    return null;
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
}
