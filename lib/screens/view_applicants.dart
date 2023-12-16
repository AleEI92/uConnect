
import 'package:flutter/material.dart';
import 'package:u_connect/common/session.dart';
import 'package:u_connect/screens/profile.dart';

import '../common/utils.dart';
import '../custom_widgets/background_decor.dart';
import '../http/services.dart';
import '../models/student_login_response.dart';

class ViewApplicants extends StatefulWidget {
  final List<User> users;
  const ViewApplicants({Key? key, required this.users}) : super(key: key);

  @override
  State<ViewApplicants> createState() => _ViewApplicantsState();
}

class _ViewApplicantsState extends State<ViewApplicants> {

  final List<User> users = [];

  @override
  void initState() {
    super.initState();
    users.addAll(widget.users);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicantes'),
      ),
      body: SafeArea(
        child: showList(users),
      ),
    );
  }

  Widget showList(List<User> users) {
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
              onTap: () async {
                Utils(context).startLoading();
                final response = await getUserByMail(users[index].email!);
                if (!mounted) return;
                Utils(context).stopLoading();
                if (response != null && response.email != null) {
                  response.careerName = getCareerNameById(response.careerId!);
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Profile(user: response)));
                }
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
                            'Nombre: ${users[index].fullName}',
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Carrera: ${users[index].career}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
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
        }, itemCount: users.length),
      ),
    );
  }

  String getCareerNameById(int value) {
    for (var i = 0; i < Session.getInstance().allCarreras!.length; i++) {
      if (value == Session.getInstance().allCarreras![i].id) {
        return Session.getInstance().allCarreras![i].name;
      }
    }
    return "";
  }

  Future<User> getUserByMail(String mail) async {
    var response = await MyBaseClient().getUserByMail(mail);
    return response;
  }
}
