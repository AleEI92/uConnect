
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:u_connect/models/carreras_response.dart';

import '../common/session.dart';
import '../custom_widgets/background_decor.dart';


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
                height: 50.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(200, 45)),
                  backgroundColor: MaterialStateProperty.all(Colors.white54),
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
                  ScaffoldMessenger
                      .of(context)
                      .showSnackBar(const SnackBar(
                      content: Text('Próximamente...')));
                },
              ),
            ],
          ),
        ),
      ),
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
            /*const SizedBox(
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
                  hintText: 'Ingrese su número de celular'),
            ),*/
            const SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(200, 45)),
                backgroundColor: MaterialStateProperty.all(Colors.white54),
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
                ScaffoldMessenger
                    .of(context)
                    .showSnackBar(const SnackBar(
                    content: Text('Próximamente...')));
              },
            ),
          ],
        ),
      ),
    );
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
