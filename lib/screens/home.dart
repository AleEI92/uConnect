import 'package:flutter/material.dart';
import 'package:u_connect/screens/login.dart';
import '../custom_widgets/my_dialog.dart';
import '../custom_widgets/background_decor.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
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
                // do something
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

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => MyAlertDialog(
            showNoButton: true,
            icon: Icons.warning_rounded,
            iconColor: Colors.yellow[700]!,
            title: '¿Desea cerrar sesión?',
            description: '',
            yesBtnText: 'SI',
            noBtnText: 'NO',
            yesFunction: closeSession,
            noFunction: closeDialog
          ),
        ) ??
        false;
  }

  Function closeSession() {
    return () {
      Navigator.of(context).pop(false);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) =>
              const Login()));
    };
  }

  Function closeDialog() {
    return () {
      Navigator.of(context).pop(false);
    };
  }
}
