
import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String yesBtnText;
  final String? noBtnText;
  final Function yesFunction;
  final Function? noFunction;
  final bool showNoButton;

  const MyAlertDialog(
      {Key? key,
      required this.icon,
      required this.iconColor,
      required this.title,
      required this.description,
      required this.yesBtnText,
      this.noBtnText,
      required this.yesFunction,
      required this.showNoButton,
      this.noFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 80,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              // TITULO
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              // DESCRIPCION
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                showNoButton
                    ? TextButton(
                        onPressed: noFunction!(),
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white),
                        ),
                        child: Text(
                          noBtnText!,
                          style: const TextStyle(
                            color: Colors.cyan,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )):
                    // BOTON NO
                showNoButton
                ? const SizedBox(
                  width: 24,
                ):
                // BOTON SI
                TextButton(
                    onPressed: yesFunction(),
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                    ),
                    child: Text(
                      yesBtnText,
                      style: const TextStyle(
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
}
