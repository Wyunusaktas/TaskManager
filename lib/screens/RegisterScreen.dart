import 'package:etkinlikuygulamasi/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 250,
                ),
                SvgPicture.asset(
                  "assets/images/welcome.svg",
                  height: 100,
                ),
                const SizedBox(
                  height: 50,
                ),
                RegisterContainer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        indent: 5,
                        thickness: 0.5,
                        color: Colors.grey[400],
                      )),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("StajApp")),
                      Expanded(
                          child: Divider(
                        indent: 5,
                        thickness: 0.5,
                        color: Colors.grey[400],
                      )),
                    ],
                  ),
                )
              ],
            ),
            waveUp(),
            waveDown()
          ],
        ));
  }

  Row RegisterContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(20),
          height: 320,
          width: 350,
          decoration: BoxDecoration(
              color: const Color(0xffF3F3F5),
              borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailcontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email is required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(color: Color(0xFF3F3D56))),
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordcontroller,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password is required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(color: Color(0xFF3F3D56))),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: MaterialButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              var bytes = utf8.encode(_passwordcontroller.text);
                              var hash = sha256.convert(bytes);
                              ref
                                  .read(authControllerProvider)
                                  .signUpWithEmailAndPassword(
                                      email: _emailcontroller.text,
                                      password: hash.toString())
                                  .then((value) => Navigator.pop(context));
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: const Color(0xFF3F3D56),
                          minWidth: MediaQuery.of(context).size.width * 0.6,
                          child: const Text(
                            "Register",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Positioned waveUp() {
    return Positioned(
        top: 0,
        child: Opacity(
            opacity: 0.7,
            child: SvgPicture.asset(
              "assets/images/wave_purple_up.svg",
              height: 250,
              width: 100,
            )));
  }

  Positioned waveDown() {
    return Positioned(
        bottom: 0,
        child: Opacity(
            opacity: 0.1,
            child: SvgPicture.asset(
              "assets/images/wave-grey_down.svg",
              height: 300,
              width: 100,
            )));
  }
}
