
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../custom_widgets/background_decor.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
            child: const Column(
              children: [

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
        btnCancelOnPress: () => Navigator.of(context).pop()).show();

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
