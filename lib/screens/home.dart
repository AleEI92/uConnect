
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:u_connect/common/constants.dart';
import 'package:u_connect/models/oferta_body.dart';
import 'package:u_connect/models/skill_body.dart';
import 'package:u_connect/screens/password_change_reset.dart';
import 'package:u_connect/screens/profile.dart';
import 'package:u_connect/screens/view_jobs.dart';
import '../common/session.dart';
import '../common/utils.dart';
import '../custom_widgets/background_decor.dart';
import '../http/services.dart';
import 'job_creation.dart';
import 'job_detail.dart';
import 'jobs_filter.dart';
import 'login.dart';


class FilterObj {
  int? idCarrera;
  String? jobType;
  List<String>? skills;

  FilterObj({required this.idCarrera, required this.jobType, required this.skills});
}

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

  // SETEAMOS LOS FILTROS POR DEFAULT -> SE MUESTRA TRABAJO Y PASANTIA POR DEFAULT (Ambas)
  var activeFilters = FilterObj(idCarrera: null, jobType: null, skills: null);

  List<OfertaBody> ofertasAll = [];
  List<Widget> widgets = [];
  bool newDataFromFilter = false;

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
              const Divider(thickness: 1.5),
              ListTile(
                leading: const Icon(Icons.password_rounded),
                title: const Text(
                    'Cambiar contraseña',
                    style: TextStyle(fontSize: 14)
                ),
                onTap: () {
                  Navigator.pop(context);
                  _changePassword();
                },
              ),
              const Divider(thickness: 1.5),
              ListTile(
                leading: const Icon(Icons.info_rounded),
                title: const Text(
                    'Información',
                    style: TextStyle(fontSize: 14)
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await AwesomeDialog(
                      context: context,
                      autoDismiss: false,
                      dismissOnBackKeyPress: false,
                      onDismissCallback: (type) {},
                      useRootNavigator: false,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      dismissOnTouchOutside: false,
                      title: 'Información',
                      desc: 'Programador: Alejandro Elías Insaurralde\n'
                          'Backend: Manuel Martínez\n\n'
                          'Contacto: uconnect.uca@gmail.com\n\n'
                          'Versión: ${Constants.versionCode}',
                      buttonsTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      btnOkText: 'ACEPTAR',
                      btnOkColor: Colors.cyan[400],
                      btnOkOnPress: () {
                        Navigator.of(context).pop();
                      }).show();
                },
              ),
              const Divider(thickness: 1.5),
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(fontSize: 14)
                ),
                onTap: () {
                  Navigator.pop(context);
                  _onBackPressed(context);
                },
              ),
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
            if (_session.isStudent) ... [
              IconButton(
                icon: const Icon(
                  Icons.filter_alt_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                          JobsFilter(filters: activeFilters)))
                      .then((value) async {
                        if (value != null) {
                          final newFilters = value as FilterObj;
                          activeFilters.idCarrera = newFilters.idCarrera;
                          activeFilters.jobType = newFilters.jobType;
                          activeFilters.skills = newFilters.skills;
                          /*print(activeFilters.idCarrera);
                          print(activeFilters.jobType);
                          print(activeFilters.skills);*/

                          final newData = await getAllOfertas();
                          newDataFromFilter = true;
                          setState(() {
                            ofertasAll.clear();
                            ofertasAll.addAll(newData);
                          });
                        }
                  });
                },
              )
            ]
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
                    if (!newDataFromFilter) {
                      ofertasAll.addAll(snapshot.data);
                    }
                    newDataFromFilter = false;

                    return showList(ofertasAll);
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

  String setActiveFiltersText() {
    String value = "";

    if (activeFilters.idCarrera != null) {
      value = value + getCarreraNameById(activeFilters.idCarrera!);
    }

    if (activeFilters.jobType != null) {
      if (value.isEmpty) {
        value = value + activeFilters.jobType!;
      }
      else {
        value = "$value / ${activeFilters.jobType!}";
      }
    }

    if (activeFilters.skills != null) {
      for (var skill in activeFilters.skills!) {
        if (value.isEmpty) {
          value = value + skill;
        }
        else {
          value = "$value / $skill";
        }
      }
    }

    if (value.isEmpty) {
      value = "Todas las ofertas";
    }
    else {
      value = "Filtros activos: $value";
    }
    return value.toUpperCase();
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
        child: Column(
          children: [
            /*const SizedBox(
              height: 4.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(setActiveFiltersText(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
            ),
            const SizedBox(
              height: 4.0,
            ),*/
            Expanded(
              child: ListView.builder(itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  JobDetail(offer: ofertasAll[index])));
                    },
                    child: Card(
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8.0,
                      color: Colors.cyan[200],
                      child: SizedBox(
                        height: 130,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 16),
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
                                        "${ofertas[index].careerName!} - ${ofertas[index].jobType!}",
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        ofertas[index].companyName!,
                                        style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15.0),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 16.0,
                                      ),
                                      Text('Fecha: '
                                          '${ofertas[index].creationDate!.day}'
                                          '-${ofertas[index].creationDate!.month}'
                                          '-${ofertas[index].creationDate!.year}'),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }, itemCount: ofertas.length),
            ),
          ],
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
    var response = await MyBaseClient().getAllOfertas(
        activeFilters.idCarrera,
        activeFilters.jobType,
        activeFilters.skills
    );
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

  String getCarreraNameById(int value) {
    for (var i = 0; i < _session.allCarreras!.length; i++) {
      if (value == _session.allCarreras![i].id) {
        return _session.allCarreras![i].name;
      }
    }
    return "";
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

  Future<bool> _changePassword() async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => PasswordChangeReset(isRecovering: false),
    ) ??
        false;
  }
}
