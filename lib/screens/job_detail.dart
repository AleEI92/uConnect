
import 'package:flutter/material.dart';

import '../custom_widgets/background_decor.dart';
import '../models/oferta_body.dart';

class JobDetail extends StatefulWidget {
  final OfertaBody offer;
  const JobDetail({Key? key, required this.offer}) : super(key: key);

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {

  @override
  void initState() {
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
              child: Container(),
          )
      ),
    );
  }
}
