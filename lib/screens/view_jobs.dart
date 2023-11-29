
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:u_connect/models/oferta_body.dart';
import 'package:u_connect/screens/job_detail.dart';

import '../common/session.dart';
import '../common/utils.dart';
import '../custom_widgets/background_decor.dart';
import '../http/services.dart';

class ViewJobs extends StatefulWidget {
  const ViewJobs({super.key});

  @override
  State<ViewJobs> createState() => _ViewJobsState();
}

class _ViewJobsState extends State<ViewJobs> {

  late Future<dynamic> data;
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() {
      Utils(context).startLoading();
    });
    data = getOfertasByCompany();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Ofertas'),
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
                return showList(snapshot.data);
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

  Widget showList(List<OfertaBody> ofertas) {
    return Container(
      decoration: myAppBackground(),
      width: double.maxFinite,
      height: double.maxFinite,
      constraints: const BoxConstraints.expand(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 12),
        child: ListView.builder(itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                        JobDetail(offer: ofertas[index])));
              },
              onLongPress: () async {
                await AwesomeDialog(
                    context: context,
                    autoDismiss: false,
                    dismissOnBackKeyPress: false,
                    onDismissCallback: (type) {},
                    useRootNavigator: false,
                    dialogType: DialogType.info,
                    animType: AnimType.rightSlide,
                    dismissOnTouchOutside: false,
                    title: '¿Desea eliminar esta oferta?',
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
                    btnOkOnPress: () async {
                      Navigator.of(context).pop();
                      Utils(context).startLoading();
                      final response = await MyBaseClient().deleteJob(ofertas[index].id!);
                      if (!mounted) return;
                      Utils(context).stopLoading();

                      if (response != null && response.message.isNotEmpty) {
                        setState(() {
                          ofertas.removeAt(index);
                        });
                      }
                    },
                    btnCancelOnPress: () async {
                      Navigator.of(context).pop();
                    }).show();
              },
              child: Card(
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8.0,
                color: Colors.cyan[100],
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tipo: ${ofertas[index].jobType}'),
                          Text('Carrera: ${ofertas[index].careerName}'),
                          Text('Fecha: '
                              '${ofertas[index].creationDate!.day}'
                              '-${ofertas[index].creationDate!.month}'
                              '-${ofertas[index].creationDate!.year}'),
                          const SizedBox(height: 8),
                          if (ofertas[index].users != null && ofertas[index].users!.isNotEmpty) ... [
                            Text(
                              "Solicitudes: ${ofertas[index].users!.length}",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]
                          else ... [
                            const Text(
                              "Solicitudes: 0",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                ),
              ),
            ),
          );
        }, itemCount: ofertas.length),
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

  // SERVICIOS A EJECUTAR EN PANTALLA
  Future<dynamic> getOfertasByCompany() async {
    var response = await MyBaseClient().getOfertasByID(Session.getInstance().userID);
    return response;
  }
}
