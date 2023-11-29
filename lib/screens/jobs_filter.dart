
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:u_connect/models/carreras_response.dart';
import 'package:u_connect/screens/home.dart';

import '../common/session.dart';
import '../custom_widgets/background_decor.dart';


class JobsFilter extends StatefulWidget {
  final FilterObj filters;
  const JobsFilter({Key? key, required this.filters}) : super(key: key);

  @override
  State<JobsFilter> createState() => _JobsFilterState();
}

class _JobsFilterState extends State<JobsFilter> {

  // FILTRAMOS POR: TODAS LAS OFERTAS, CARRERA, MODALIDAD Y HABILIDADES
  late Session _session;
  List<Carrera> listaCarreras = [];
  List<String> modalidades = ["Ambas", "Trabajo", "Pasantía"];
  final descriptionSkillControl = TextEditingController();

  late FilterObj activeFilters;
  late String currentModalidad;
  var _selectedCarrera = '';
  var _selectedCarreraId = 0;
  final List<String> listSkillDescription = [""];

  @override
  void initState() {
    _session = Session.getInstance();
    listaCarreras.add(Carrera(name: "Todas", id: 0));
    _selectedCarrera = listaCarreras[0].name;
    _selectedCarreraId = listaCarreras[0].id;
    if (_session.allCarreras != null) {
      listaCarreras.addAll(_session.allCarreras!);
    }
    currentModalidad = modalidades[0];

    // SETEAMOS LOS FILTROS ACTIVOS SI ES QUE LOS HAY
    activeFilters = widget.filters;
    if (activeFilters.idCarrera != null) {
      _selectedCarreraId = activeFilters.idCarrera!;
      _selectedCarrera = getCarreraNameById(_selectedCarreraId);
    }
    if (activeFilters.jobType != null) {
      currentModalidad = activeFilters.jobType!;
    }
    if (activeFilters.skills != null && activeFilters.skills!.isNotEmpty) {
      listSkillDescription.addAll(activeFilters.skills!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtros'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_forever_rounded,
              color: Colors.white,
            ),
            onPressed: () async {
              await AwesomeDialog(
                  context: context,
                  autoDismiss: false,
                  dismissOnBackKeyPress: false,
                  onDismissCallback: (type) {},
                  useRootNavigator: false,
                  dialogType: DialogType.info,
                  animType: AnimType.rightSlide,
                  dismissOnTouchOutside: false,
                  title: '¿Desea limpiar los filtros?',
                  desc: '',
                  buttonsTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  btnOkText: 'SI',
                  btnOkColor: Colors.cyan[400],
                  btnCancelText: 'NO',
                  btnCancelColor: Colors.grey[400],
                  btnOkOnPress: () {
                    Navigator.of(context).pop();
                    cleanFilters();
                  },
                  btnCancelOnPress: () async {
                    Navigator.of(context).pop();
                  }
              ).show();
            },
          )
        ],
      ),
      body: SafeArea(
          child: Container(
            decoration: myAppBackground(),
            width: double.maxFinite,
            height: double.maxFinite,
            constraints: const BoxConstraints.expand(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 8),
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
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Por carrera", style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        DropdownButtonFormField<String>(
                          value: listaCarreras.firstWhere((element) => element.name == _selectedCarrera).name,
                          validator: (value) {
                            if (_selectedCarrera.isEmpty) {
                              return ('Debe seleccionar una carrera.');
                            }
                            return null;
                          },
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: listaCarreras.map((carrera) {
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
                            setState(() {
                              _selectedCarrera = value.toString();
                              _selectedCarreraId = getCareerID(_selectedCarrera);
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Por modalidad", style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),),
                            for (int i=0; i<modalidades.length; i++)
                              RadioListTile(
                                contentPadding: const EdgeInsets.only(left: 0),
                                title: Text(modalidades[i]),
                                value: modalidades[i],
                                groupValue: currentModalidad,
                                onChanged: (value) {
                                  setState(() {
                                    currentModalidad = value.toString();
                                  });
                                },
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Por habilidad", style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),),
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
                          itemCount: listSkillDescription.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                index > 0
                                    ? loadSkill(index,
                                    listSkillDescription[index].toString())
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
                            backgroundColor: MaterialStateProperty.all(Colors.black45),
                          ),
                          child: const Text(
                            'APLICAR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            saveFilters();
                            Navigator.of(context).pop(activeFilters);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }

  void cleanFilters() {
    setState(() {
      _selectedCarrera = listaCarreras[0].name;
      _selectedCarreraId = listaCarreras[0].id;
      currentModalidad = modalidades[0];
      descriptionSkillControl.clear();
      listSkillDescription.clear();
    });
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
          GestureDetector(
            onTap: () {
              if (descriptionSkillControl.text.isEmpty) {
                return;
              }
              setState(() {
                listSkillDescription.add(descriptionSkillControl.text.toString());
              });
              descriptionSkillControl.clear();
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

  Widget loadSkill(int index, String descrip) {
    return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.cyan[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.black54.withOpacity(0.7),
                  spreadRadius: 1,
                  blurRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(child: Text(
                    descrip,
                    style: TextStyle(
                      color: Colors.black54.withOpacity(0.7),
                      fontSize: 16.0,
                    ),
                  )),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        listSkillDescription.removeAt(index);
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

  String getCarreraNameById(int value) {
    for (var i = 0; i < listaCarreras.length; i++) {
      if (value == listaCarreras[i].id) {
        _selectedCarreraId = listaCarreras[i].id;
        return listaCarreras[i].name;
      }
    }
    return listaCarreras[0].name;
  }

  int getCareerID(String  value) {
    for (var i = 0; i < listaCarreras.length; i++) {
      if (value == listaCarreras[i].name) {
        return i;
      }
    }
    return 0;
  }

  void saveFilters() {
    if (_selectedCarreraId == 0) {
      activeFilters.idCarrera = null;
    }
    else {
      activeFilters.idCarrera = _selectedCarreraId;
    }

    if (currentModalidad == "Ambas") {
      activeFilters.jobType = null;
    }
    else {
      activeFilters.jobType = currentModalidad;
    }

    // FALTA LOGICA PARA SKILLS
    activeFilters.skills = null;
    if (listSkillDescription.length <= 1) {
      activeFilters.skills = null;
    }
    else {
      activeFilters.skills = [];
      listSkillDescription.removeWhere((element) => element == "");
      activeFilters.skills!.addAll(listSkillDescription);
    }
  }
}
