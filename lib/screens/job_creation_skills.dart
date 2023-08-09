
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../common/session.dart';
import '../common/utils.dart';
import '../custom_widgets/background_decor.dart';
import '../http/services.dart';
import '../models/generic_post_ok.dart';
import '../models/oferta_crear_body.dart';
import '../models/skill_body.dart';

class JobCreationSkills extends StatefulWidget {
  const JobCreationSkills({super.key});

  @override
  State<StatefulWidget> createState() => _JobCreationSkillsState();
}

class _JobCreationSkillsState extends State<JobCreationSkills> {
  final List<String> _listExperiencia = ["0.5", "1", "2", "3", "4", "+5"];
  final List<Widget> myWidgetSkills = [];
  final description = TextEditingController();
  final GlobalKey<FormFieldState> _keyDrop = GlobalKey();
  String _selectedExperience = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Oferta'),
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
              physics: const BouncingScrollPhysics(),
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
                      Column(
                        children: myWidgetSkills,
                      ),
                      skillForm(),
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
      ),
    );
  }

  Widget loadSkill(String descrip, String exp) {
    return Row(
      children: [
        Text("$descrip - Experiencia: $exp"),
        GestureDetector(
          onTap: () {},
          child: const Icon(
            Icons.delete_rounded,
            color: Colors.red,
          ),
        )
      ],
    );
  }

  Widget skillForm() {
    return Form(
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: description,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo no puede estar vacio.';
                }
                return null;
              },
              style: const TextStyle(fontSize: 15.0),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Habilidad',
                  hintText: 'Ingrese una habilidad'),
            ),
          ),
          Expanded(
            child: DropdownButtonFormField<String>(
              key: _keyDrop,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: _listExperiencia.map((years) {
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
          GestureDetector(
            onTap: () {
              setState(() {
                myWidgetSkills.add(loadSkill(description.text.toString(), _selectedExperience));
                description.clear();
                _selectedExperience = "";
                _keyDrop.currentState?.reset();
              });

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

  Future<GenericOkPost> callOfferFunction() async {
    var body = CrearOfertaBody(
      description: "hola",
      jobType: "Trabajo",
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
