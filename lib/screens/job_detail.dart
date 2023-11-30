
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:u_connect/common/session.dart';
import 'package:u_connect/screens/view_applicants.dart';

import '../common/utils.dart';
import '../custom_widgets/background_decor.dart';
import '../http/services.dart';
import '../models/generic_post_ok.dart';
import '../models/oferta_body.dart';
import 'package:http/http.dart' as http;

import '../models/student_login_response.dart';
import 'home.dart';


class JobDetail extends StatefulWidget {
  final OfertaBody offer;
  const JobDetail({Key? key, required this.offer}) : super(key: key);

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {

  late OfertaBody offer;
  List<String> values = [];

  @override
  void initState() {
    offer = widget.offer;
    values.add(offer.jobType!);
    values.add(offer.careerName!);
    values.add(offer.cityName!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle Oferta'),
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
                        // DESCRIPTION
                        Container(
                          width: double.maxFinite,
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
                                horizontal: 8.0, vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  offer.companyName!,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                    "${offer.description!}\n"
                                ),
                                if (offer.skills != null && offer.skills!.isNotEmpty) ... [
                                  const Text(
                                      "REQUISITOS:" "\n",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: offer.skills!.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                    "- ${offer.skills![index].skillName}."
                                                        "\nExperiencia: ${"${offer.skills![index].experience} años."}",
                                                  )
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10)
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        // MODALIDAD
                        DropdownButtonFormField<String>(
                            value: values[0],
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: values.map((value) {
                              return DropdownMenuItem<String>(
                                enabled: false,
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Modalidad',
                                hintText: 'Seleccione modalidad de trabajo:'),
                            onChanged: null
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        // CARRERA
                        DropdownButtonFormField<String>(
                            value: values[1],
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: values.map((value) {
                              return DropdownMenuItem<String>(
                                enabled: false,
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Carrera',
                                hintText: 'Seleccione una carrera:'),
                            onChanged: null
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        // CIUDAD
                        DropdownButtonFormField<String>(
                            value: values[2],
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: values.map((value) {
                              return DropdownMenuItem<String>(
                                enabled: false,
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Ciudad',
                                hintText: 'Seleccione su ciudad:'),
                            onChanged: null
                        ),
                        if (!Session.getInstance().isStudent &&
                            offer.users != null &&
                            offer.users!.isNotEmpty) ... [
                          const SizedBox(
                            height: 20.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(const Size(160, 35)),
                                backgroundColor: MaterialStateProperty.all(Colors.blue),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'VER APLICANTES',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward_rounded),
                                ],
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                          ViewApplicants(users: offer.users!)));
                              },
                            ),
                          ),
                        ],
                        if (offer.fileId != null) ... [
                          const SizedBox(
                            height: 30.0,
                          ),
                          InkWell(
                            child: const Icon(Icons.file_present_rounded, size: 56),
                            onTap: () async {
                              // DOWNLOAD FILE FROM OFFER
                              Utils(context).startLoading();
                              var response = await MyBaseClient().getFile(offer.fileId!) as http.Response?;
                              if (response != null && response.statusCode == 200) {
                                if (context.mounted) {
                                  Utils(context).getFileFromBinaryAndOpen(response);
                                }
                              }
                              if (context.mounted) {
                                Utils(context).stopLoading();
                              }
                            },
                          ),
                          const Text(
                            "Descargar archivo",
                          ),
                        ],
                        const SizedBox(
                          height: 50.0,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(const Size(200, 45)),
                            backgroundColor: MaterialStateProperty.all(Colors.black45),
                          ),
                          child: Text(
                            Session.getInstance().isStudent
                            ? 'APLICAR A OFERTA'
                            : 'EDITAR OFERTA',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            if (Session.getInstance().isStudent) {
                              if (offer.users != null) {
                                User? user;
                                for (var item in offer.users!) {
                                  if (item.email == Session.getInstance().userEmail) {
                                    user = item;
                                    break;
                                  }
                                }
                                if (user != null) {
                                  AwesomeDialog(
                                      context: context,
                                      dismissOnTouchOutside: false,
                                      dismissOnBackKeyPress: false,
                                      dialogType: DialogType.error,
                                      headerAnimationLoop: false,
                                      animType: AnimType.bottomSlide,
                                      title: 'Solicitud denegada',
                                      desc:
                                      'Ya ha aplicado a esta oferta',
                                      buttonsTextStyle:
                                      const TextStyle(color: Colors.black),
                                      showCloseIcon: false,
                                      btnOkText: 'ACEPTAR',
                                      btnOkColor: Colors.cyan[400],
                                      btnOkOnPress: () {
                                        Navigator.of(context).pop(true);
                                      }).show();
                                  return;
                                }
                              }
                              else if (Session.getInstance().fileId == null) {
                                AwesomeDialog(
                                    context: context,
                                    dismissOnTouchOutside: false,
                                    dismissOnBackKeyPress: false,
                                    dialogType: DialogType.error,
                                    headerAnimationLoop: false,
                                    animType: AnimType.bottomSlide,
                                    title: 'Solicitud denegada',
                                    desc:
                                    'Debe cargar su CV para poder aplicar a una oferta',
                                    buttonsTextStyle:
                                    const TextStyle(color: Colors.black),
                                    showCloseIcon: false,
                                    btnOkText: 'ACEPTAR',
                                    btnOkColor: Colors.cyan[400],
                                    btnOkOnPress: () {
                                      Navigator.of(context).pop(true);
                                    }).show();
                                return;
                              }
                              Utils(context).startLoading();
                              callApplyToOfferFunction().then((value) {
                                Utils(context).stopLoading();
                                if (value != null) {
                                  if (value.message == "OK") {
                                    AwesomeDialog(
                                        context: context,
                                        dismissOnTouchOutside: false,
                                        dismissOnBackKeyPress: false,
                                        dialogType: DialogType.success,
                                        headerAnimationLoop: false,
                                        animType: AnimType.bottomSlide,
                                        title: '¡Solicitud exitosa!',
                                        desc:
                                        'Se ha informado a la empresa de tu interés. ¡Buena suerte!',
                                        buttonsTextStyle:
                                        const TextStyle(color: Colors.black),
                                        showCloseIcon: false,
                                        btnOkText: 'ACEPTAR',
                                        btnOkOnPress: () {
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                              builder: (context) => const Home()), (Route route) => false);
                                        }).show();
                                  }
                                }
                              }).onError((error, stackTrace) {
                                Utils(context).stopLoading();
                                Utils(context).showErrorDialog(error.toString()).show();
                              });
                            }
                            else {
                              var snackBar = const SnackBar(content: Text('Próximamente...'));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
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

  Future<GenericOkPost?> callApplyToOfferFunction() async {
    return await postApplyToOffer(offer.id);
  }

  Future<GenericOkPost?> postApplyToOffer(int? offerID) async {
    if (offerID != null) {
      var response = await MyBaseClient().postApplyToOffer(offerID);
      return response;
    }
    return null;
  }
}
