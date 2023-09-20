
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:u_connect/models/oferta_body.dart';
import 'package:u_connect/models/skill_body.dart';
import 'package:u_connect/screens/profile.dart';
import 'package:u_connect/screens/view_jobs.dart';
import '../common/session.dart';
import '../common/utils.dart';
import '../custom_widgets/background_decor.dart';
import '../http/services.dart';
import 'job_creation.dart';
import 'job_detail.dart';
import 'login.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Session _session;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  late Future<dynamic> data;
  var _isLoading = true;

  List<OfertaBody> ofertasAll = [];
  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    _session = Session.getInstance();
    if (_session.isStudent) {
      Future.delayed(Duration.zero,() {
        Utils(context).startLoading();
      });
      data = getAllOfertas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        key: _key,
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF64B5F6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _session.isStudent
                        ? const Icon(Icons.account_circle_rounded, size: 62)
                        : const Icon(Icons.business_rounded, size: 62),
                    //Text(_session.userName),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      _session.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.manage_accounts_rounded),
                title: const Text(
                  'Perfil',
                  style: TextStyle(fontSize: 14)
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                          const Profile()));
                },
              ),
              const Divider(thickness: 2),
              ListTile(
                leading: const Icon(Icons.info_rounded),
                title: const Text(
                    'Información',
                    style: TextStyle(fontSize: 14)
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(thickness: 2),
            ],
          ),
        ),
        drawerEnableOpenDragGesture: false,
        appBar: AppBar(
          title: const Text('uConnect'),
          leading: IconButton(
            icon: const Icon(
              Icons.menu_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              _key.currentState!.openDrawer();
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
            child: _session.isStudent
            ? FutureBuilder<dynamic>(
              future: data,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (_isLoading) {
                    Utils(context).stopLoading();
                    _isLoading = false;
                  }
                  if (snapshot.hasError) {
                    return myDialog();
                  }
                  // MOSTRAMOS FORMULARIOS
                  else if (snapshot.hasData) {
                    return LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        ofertasAll.addAll(snapshot.data);
                        for (var k = 0; k < ofertasAll.length; k++) {
                          OfertaBody item = ofertasAll[k];
                          widgets.add(
                            SizedBox(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 16, bottom: constraints.maxHeight*0.25),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                JobDetail(offer: item)));
                                  },
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
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // DESCRIPTION
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8.0, vertical: 4.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.companyName!,
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(
                                                    height: 12.0,
                                                  ),
                                                  Text(
                                                    item.description!,
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  /*if (item.skills != null && item.skills!.isNotEmpty) ... [
                                                    const Text(
                                                      "\n""REQUISITOS:" "\n",
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    loadUserSkills(item.skills!),
                                                  ],*/
                                                  const SizedBox(
                                                    height: 12.0,
                                                  ),
                                                  Text('Fecha: '
                                                      '${item.creationDate!.day}'
                                                      '-${item.creationDate!.month}'
                                                      '-${item.creationDate!.year}'),
                                                  if (item.users != null && item.users!.isNotEmpty) ... [

                                                  ],
                                                ],
                                              ),
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
                        return Container(
                          alignment: Alignment.topCenter,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const PageScrollPhysics(), // this for snapping
                            itemCount: widgets.length,
                            itemBuilder: (_, index) => widgets[index],
                          ),
                        );
                      },
                    );
                  }
                  else {
                    return Container();
                  }
                }
                else {
                  return Container();
                }
              },
            )
            : Column(
              children: [
                const SizedBox(
                  height: 40.0,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(200, 45)),
                    backgroundColor: MaterialStateProperty.all(Colors.black45),
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
                    backgroundColor: MaterialStateProperty.all(Colors.black45),
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

  Widget loadUserSkills(List<Skill> skills) {
    String resumenSkills = "";
    for (var p = 0; p < skills.length; p++) {
      resumenSkills =
          "$resumenSkills- ${skills[p].skillName}.\nExperiencia: ${"${skills[p].experience} años."}" "\n\n";
    }
    return Text(resumenSkills);
  }

  Future<dynamic> getAllOfertas() async {
    var response = await MyBaseClient().getAllOfertas(getCareerID(), null);
    return response;
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
                      Navigator.of(context, rootNavigator: false).pop();
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

  int? getCareerID() {
    for (var i = 0; i < _session.allCarreras!.length; i++) {
      if (_session.userCareer == _session.allCarreras![i].name) {
        return (i + 1);
      }
    }
    return null;
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
