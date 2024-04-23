import 'package:etkinlikuygulamasi/api/firebase_api.dart';
import 'package:etkinlikuygulamasi/controller/auth_controller.dart';
import 'package:etkinlikuygulamasi/screens/RegisterScreen.dart';
import 'package:etkinlikuygulamasi/screens/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                const SizedBox(
                  height: 50,
                ),
                loginContainer(),
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

  Row loginContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                color: const Color(0xffF3F3F5),
                borderRadius: BorderRadius.circular(20)),
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
                  const SizedBox(height: 30.0),
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
                            var bytes = utf8.encode(_passwordcontroller.text);
                            var hash = sha256.convert(bytes);
                            if (_formKey.currentState!.validate()) {
                              ref
                                  .read(authControllerProvider)
                                  .signInWithEmailAndPassword(
                                      email: _emailcontroller.text,
                                      password: hash.toString())
                                  .then((value) {
                                FirebaseApi().initNotifications().then((_) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainPage(),
                                      ),
                                      (route) => false);
                                }).catchError((error) {
                                  print('Error: $error');
                                });
                              }).catchError((error) {
                                print('Sign in error: $error');
                              });
                            }
                          },
                          minWidth: MediaQuery.of(context).size.width * 0.6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: const Color(0xFF3F3D56),
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                  TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          )),
                      child: const Text("Sign Up")),
                ],
              ),
            ),
          ),
        ),
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
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.width * 0.5,
            )));
  }

  Positioned waveDown() {
    return Positioned(
        bottom: 0,
        child: Opacity(
            opacity: 0.1,
            child: SvgPicture.asset(
              "assets/images/wave-grey_down.svg",
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.width * 0.25,
            )));
  }
}
