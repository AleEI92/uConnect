
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class PasswordReset extends StatelessWidget {
  PasswordReset({Key? key}) : super(key: key);

  // KEYS PARA LOS FORMULARIOS
  final _formKey = GlobalKey<FormState>();

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
          color: Colors.cyan[400],
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, size: 28),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Le enviaremos una contraseña temporal a su correo para que pueda cambiarla en su siguiente inicio de sesion.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,

                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (value) {
                        return mailValidation(value);
                      },
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 15.0),
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_rounded),
                          border: OutlineInputBorder(),
                          labelText: 'Correo',
                          hintText: 'Ingrese correo válido'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size(200, 45)),
                      backgroundColor: MaterialStateProperty.all(Colors.white54),
                    ),
                    child: const Text(
                      'RECUPERAR CONTRASEÑA',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => {
                      if (_formKey.currentState!.validate()) {

                      }
                    },
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? mailValidation(String? value) {
    if (value == null || !EmailValidator.validate(value)) {
      return 'Ingrese un correo válido.';
    }
    return null;
  }
}
