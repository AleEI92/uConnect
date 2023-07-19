import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:u_connect/common/session.dart';
import 'package:u_connect/models/oferta_crear_body.dart';

import '../common/utils.dart';
import '../custom_widgets/background_decor.dart';
import '../http/services.dart';
import '../models/carreras_response.dart';
import '../models/generic_post_ok.dart';
import '../models/skill_body.dart';

class JobCreation extends StatefulWidget {
  const JobCreation({super.key});

  @override
  State<StatefulWidget> createState() => _JobCreationState();
}

class _JobCreationState extends State<JobCreation> {
  final _formKey = GlobalKey<FormState>();
  late Future<dynamic> data;
  final List<Carrera> _listModalidades = [Carrera(name: 'Trabajo', id: 1), Carrera(name: 'Pasantía', id: 2)];
  final List<Carrera> _listCarreras = [];
  final List<Carrera> _listCiudades = [];
  String _selectedModalidad = '';
  String _selectedCarrera = '';
  String _selectedCiudad = '';
  final descriptionControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() {
      Utils(context).startLoading();
    });
    data = getCiudadesYCarreras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Oferta'),
      ),
      body: SafeArea(
        child: FutureBuilder<dynamic>(
          future: data,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Utils(context).stopLoading();
              // ERROR EN SERVICIO DE CARRERAS
              if (snapshot.hasError) {
                return myDialog();
              }
              // MOSTRAMOS FORMULARIOS
              else if (snapshot.hasData) {
                return showForm(snapshot.data);
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

  Widget showForm(List<Carrera> ciudades) {
    return Container(
      decoration: myAppBackground(),
      width: double.maxFinite,
      height: double.maxFinite,
      constraints: const BoxConstraints.expand(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0, vertical: 8),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
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
                    // DESCRIPTION
                    TextFormField(
                      controller: descriptionControl,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Debe insertar una descripción.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 15.0),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Descripción',
                          hintText: 'Ingrese una descripción'),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    // MODALIDAD
                    DropdownButtonFormField<String>(
                      validator: (value) {
                        if (_selectedModalidad.isEmpty) {
                          return ('Debe seleccionar una modalidad.');
                        }
                        return null;
                      },
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: _listModalidades.map((carrera) {
                        return DropdownMenuItem<String>(
                          value: carrera.name,
                          child: Text(carrera.name),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Seleccione modalidad de trabajo:'),
                      onChanged: (value) {
                        _selectedModalidad = value.toString();
                        print("MODALIDAD: $_selectedModalidad");
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    // CARRERA
                    DropdownButtonFormField<String>(
                      validator: (value) {
                        if (_selectedCarrera.isEmpty) {
                          return ('Debe seleccionar una carrera.');
                        }
                        return null;
                      },
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: _listCarreras.map((carrera) {
                        return DropdownMenuItem<String>(
                          value: carrera.name,
                          child: Text(carrera.name),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Seleccione una carrera:'),
                      onChanged: (value) {
                        _selectedCarrera = value.toString();
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    // CIUDAD
                    DropdownButtonFormField<String>(
                      validator: (value) {
                        if (_selectedCiudad.isEmpty) {
                          return ('Debe seleccionar una ciudad.');
                        }
                        return null;
                      },
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: _listCiudades.map((carrera) {
                        return DropdownMenuItem<String>(
                          value: carrera.name,
                          child: Text(carrera.name),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Seleccione su ciudad:'),
                      onChanged: (value) {
                        _selectedCiudad = value.toString();
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
                        'REGISTRAR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        //if (_companyFormKey.currentState!.validate()) {
                          Utils(context).startLoading();
                          callOfferFunction().then((value) {
                            Utils(context).stopLoading();
                            if (value.message == "OK") {
                              AwesomeDialog(
                                  context: context,
                                  dismissOnTouchOutside: false,
                                  dismissOnBackKeyPress: false,
                                  dialogType: DialogType.success,
                                  headerAnimationLoop: false,
                                  animType: AnimType.bottomSlide,
                                  title: '¡Creación de oferta exitosa!',
                                  desc:
                                  'Se ha creado la oferta correctamente.',
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
                        //}
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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

  Future<List<Carrera>> getCiudadesYCarreras() async {
    List<Carrera> resultado = [];
    List<Carrera> ciudades = await MyBaseClient().getCiudades();
    List<Carrera> carreras = await MyBaseClient().getCarreras();

    if (ciudades.isNotEmpty && carreras.isNotEmpty) {
      resultado.addAll(ciudades);
      resultado.addAll(carreras);
    }

    return resultado;
  }

  Future<GenericOkPost> callOfferFunction() async {
    var body = CrearOfertaBody(
      description: descriptionControl.text.toString().trim(),
      jobType: _selectedModalidad,
      career: 'Ing. Civil',
      city: 'San Lorenzo',
      companyId: Session.getInstance().userID,
      skill: [Skill(skillName: 'Kotlin', experience: '2'), Skill(skillName: 'Flutter', experience: '1')],
    );

    return await postCreateOffer(ofertaToJson(body));
  }

  Future<GenericOkPost> postCreateOffer(Object body) async {
    var response = await MyBaseClient().postCrearOferta(body);
    return response;
  }
}
