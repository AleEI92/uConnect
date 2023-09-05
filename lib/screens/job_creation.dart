
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:u_connect/common/constants.dart';
import 'package:u_connect/common/session.dart';
import 'package:u_connect/models/oferta_crear_body.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../common/utils.dart';
import '../custom_widgets/background_decor.dart';
import '../http/services.dart';
import '../models/carreras_response.dart';
import '../models/oferta_body.dart';
import '../models/skill_body.dart';
import 'package:http_parser/http_parser.dart';


class JobCreation extends StatefulWidget {
  const JobCreation({super.key});

  @override
  State<StatefulWidget> createState() => _JobCreationState();
}

class _JobCreationState extends State<JobCreation> {
  final _formKey = GlobalKey<FormState>();
  List<Carrera> _listCarreras = [];
  List<Carrera> _listCiudades = [];
  String _selectedModalidad = '';
  String _selectedCarrera = '';
  String _selectedCiudad = '';
  final descriptionControl = TextEditingController();
  final descriptionSkillControl = TextEditingController();
  final GlobalKey<FormFieldState> _keyExperience = GlobalKey();

  final List<String> listDescription = [""];
  final List<String> listEXP = [""];
  String _selectedExperience = '';

  @override
  void initState() {
    super.initState();
    loadCiudadesYCarreras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Oferta'),
      ),
      body: SafeArea(
        child: showForm(),
      ),
    );
  }

  Widget showForm() {
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
                      items: Constants.listaModalidad.map((carrera) {
                        return DropdownMenuItem<String>(
                          value: carrera.name,
                          child: Text(carrera.name),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Modalidad',
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
                          labelText: 'Carrera',
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
                          labelText: 'Ciudad',
                          hintText: 'Seleccione su ciudad:'),
                      onChanged: (value) {
                        _selectedCiudad = value.toString();
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    skillForm(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: listDescription.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            index > 0
                                ? loadSkill(
                                    index,
                                    listDescription[index].toString(),
                                    listEXP[index].toString())
                                : const SizedBox()
                          ],
                        );
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
                        'CREAR OFERTA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        Utils(context).startLoading();
                        callOfferFunction().then((value) {
                          Utils(context).stopLoading();
                          AwesomeDialog(
                              context: context,
                              dismissOnTouchOutside: false,
                              dismissOnBackKeyPress: false,
                              dialogType: DialogType.success,
                              headerAnimationLoop: false,
                              animType: AnimType.bottomSlide,
                              title: '¡Oferta creada exitosamente!',
                              desc:
                              'Se ha creado la oferta con éxito.\n\n¿Desea adjuntar un archivo(imagen o pdf) a la oferta creada?',
                              buttonsTextStyle:
                              const TextStyle(color: Colors.black),
                              showCloseIcon: false,
                              btnCancelText: 'VOLVER',
                              btnCancelOnPress: () {
                                Navigator.of(context).pop(true);
                              },
                              btnOkText: 'CARGAR',
                              btnOkOnPress: () {
                                chooseFile(value.id);
                              }).show();
                        }).onError((error, stackTrace) {
                          Utils(context).stopLoading();
                          Utils(context).showErrorDialog(error.toString()).show();
                        });
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

  Widget loadSkill(int index, String descrip, String exp) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withOpacity(0.8),
                spreadRadius: 4,
                blurRadius: 4,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(child: Text(
                    "$descrip\nExperiencia: $exp años.",
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                )),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      listDescription.removeAt(index);
                      listEXP.removeAt(index);
                    });
                  },
                  child: const Icon(
                    Icons.delete_rounded,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 8)
      ]
    );
  }

  Widget skillForm() {
    return Form(
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: descriptionSkillControl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo no puede estar vacío.';
                }
                return null;
              },
              style: const TextStyle(fontSize: 15.0),
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 23.0, horizontal: 12.0),
                  border: OutlineInputBorder(),
                  labelText: 'Habilidad',
                  hintText: 'Ingrese una habilidad'),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 90,
            child: DropdownButtonFormField<String>(
              key: _keyExperience,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: Constants.listaExperiencia.map((years) {
                return DropdownMenuItem<String>(
                  value: years,
                  child: Text(years),
                );
              }).toList(),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Años'),
              onChanged: (value) {
                _selectedExperience = value.toString();
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              if (descriptionSkillControl.text.isEmpty ||
                  _selectedExperience.isEmpty) {
                return;
              }
              setState(() {
                listDescription.add(descriptionSkillControl.text.toString());
                listEXP.add(_selectedExperience);
              });
              descriptionSkillControl.clear();
              _selectedExperience = "";
              _keyExperience.currentState?.reset();
            },
            child: const Icon(
              Icons.add_box_rounded,
              color: Colors.green,
            ),
          )
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

  void loadCiudadesYCarreras() {
    _listCarreras = Session.getInstance().allCarreras!;
    _listCiudades = Session.getInstance().allCiudades!;
  }

  Future<OfertaBody> callOfferFunction() async {
    final List<Skill> list = [];
    for (var i = 0; i < listDescription.length; i++) {
      list.add(Skill(skillName: listDescription[i], experience: listEXP[i]));
    }
    list.removeAt(0);

    var body = CrearOfertaBody(
      description: descriptionControl.text.toString().trim(),
      jobType: _selectedModalidad,
      career: _selectedCarrera,
      city: _selectedCiudad,
      companyId: Session.getInstance().userID,
      skills: list,
    );

    return await postCreateOffer(ofertaToJson(body));
  }

  Future<OfertaBody> postCreateOffer(Object body) async {
    var response = await MyBaseClient().postCrearOferta(body);
    return response;
  }

  void chooseFile(int? id) async {
    if (id != null) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['png', 'pdf', 'jpg']
      );

      if (result != null) {
        final file = result.files.first;
        final fileSizeMB = file.size/(1000*1000);
        print("MB: $fileSizeMB");

        if (file.path != null && context.mounted) {
          Utils(context).startLoading();
          String fileExtension = "pdf";
          String type = "application";
          if (file.extension == "png") {
            fileExtension = file.extension!;
            type = "image";
          }
          else if (file.extension == "jpeg" || file.extension == "jpg") {
            fileExtension = file.extension!;
            type = "image";
          }

          final httpFile = http.MultipartFile.fromBytes(
              'file',
              File(file.path!).readAsBytesSync(),
              contentType: MediaType(type, fileExtension),
              filename: file.name
          );
          await MyBaseClient().postUploadFile(
              id, "job",
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
                'Se ha adjuntado un archivo a la oferta creada. Puede visualizarla en la sección de VER MIS OFERTAS.',
                buttonsTextStyle:
                const TextStyle(color: Colors.black),
                showCloseIcon: false,
                btnOkText: 'ACEPTAR',
                btnOkOnPress: () {
                  Navigator.of(context).pop(true);
                }).show();
          }).onError((error, stackTrace) {
            Utils(context).stopLoading();
            Utils(context).showErrorDialog(error.toString()).show();
          });
        }
      } else {
        // User canceled the picker
      }
    }
  }
}
