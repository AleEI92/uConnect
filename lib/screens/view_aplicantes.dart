
import 'package:flutter/material.dart';
import 'package:u_connect/models/student_login_response.dart';

import '../common/session.dart';
import '../custom_widgets/background_decor.dart';
import '../http/services.dart';

class ViewAplicantes extends StatefulWidget {
  final List<User> aplicantes;
  const ViewAplicantes({Key? key, required this.aplicantes}) : super(key: key);

  @override
  State<ViewAplicantes> createState() => _ViewAplicantesState();
}

class _ViewAplicantesState extends State<ViewAplicantes> {

  //late Future<dynamic> data;
  //var _isLoading = true;
  List<User> aplicantes = [];

  @override
  void initState() {
    aplicantes = widget.aplicantes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicantes'),
      ),
      body: SafeArea(
        child: showList(aplicantes),
      ),
    );
  }

  Widget showList(List<User> aplicantes) {
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
                          Text(
                              'Nombre: ${aplicantes[index].fullName}',
                              maxLines: 1, overflow:
                              TextOverflow.ellipsis
                          ),
                          Text('\nCarrera: ${aplicantes[index].careerName}'),
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
        }, itemCount: aplicantes.length),
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
