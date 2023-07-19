
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:u_connect/screens/view_jobs.dart';
import '../common/session.dart';
import '../custom_widgets/background_decor.dart';
import '../http/services.dart';
import '../models/oferta_body.dart';
import 'job_creation.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isStudentSession = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('uConnect'),
          leading: IconButton(
            icon: const Icon(
              Icons.menu_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                _onBackPressed(context);
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
            child: Column(
              children: [
                // PANTALLA DE ESTUDIANTES
                if (isStudentSession) ...[

                ]

                  // PANTALLA DE EMPRESAS
                else ...[
                  const SizedBox(
                    height: 40.0,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size(200, 45)),
                      backgroundColor: MaterialStateProperty.all(Colors.white54),
                    ),
                    child: const Text(
                      'VER MIS OFERTAS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      //OfertaBody response = await MyBaseClient().getOfertasByID(Session.getInstance().userID);
                      //print(response);
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                              const ViewJobs()));
                    },
                  ),
                  const SizedBox(
                    height: 40.0,
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
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                              const JobCreation()));
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    await AwesomeDialog(
        context: context,
        autoDismiss: false,
        dismissOnBackKeyPress: false,
        onDismissCallback: (type) {},
        useRootNavigator: false,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        dismissOnTouchOutside: false,
        title: '¿Desea cerrar sesión?',
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
          closeSession();
        },
        btnCancelOnPress: () async {
          Navigator.of(context).pop();
        }
    ).show();

    return false;
  }

  void closeSession() {
    Navigator.of(context)
        .pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext
            context) =>
            const Login()));
  }
}
