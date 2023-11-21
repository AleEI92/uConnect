
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:u_connect/models/carreras_response.dart';

import '../common/session.dart';
import '../custom_widgets/background_decor.dart';


class JobsFilter extends StatefulWidget {
  const JobsFilter({Key? key}) : super(key: key);

  @override
  State<JobsFilter> createState() => _JobsFilterState();
}

class _JobsFilterState extends State<JobsFilter> {

  // FILTRAMOS POR: TODAS LAS OFERTAS, CARRERA, MODALIDAD Y HABILIDADES
  late Session _session;
  List<Carrera> listaCarreras = [];
  List<String> modalidades = ["Ambas", "Trabajo", "Pasantía"];
  late String currentModalidad;
  var _selectedCarrera = '';
  final List<String> listDescription = [""];
  final descriptionSkillControl = TextEditingController();

  @override
  void initState() {
    _session = Session.getInstance();
    listaCarreras.add(Carrera(name: "Todas", id: 0));
    _selectedCarrera = listaCarreras[0].name;
    if (_session.allCarreras != null) {
      listaCarreras.addAll(_session.allCarreras!);
    }
    currentModalidad = modalidades[0];
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
                          itemCount: listDescription.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                index > 0
                                    ? loadSkill(index,
                                    listDescription[index].toString())
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
      currentModalidad = modalidades[0];
      descriptionSkillControl.clear();
      listDescription.clear();
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
                listDescription.add(descriptionSkillControl.text.toString());
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
                        listDescription.removeAt(index);
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
}
