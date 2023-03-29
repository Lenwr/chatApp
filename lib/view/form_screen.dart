import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/view/dashbordPage.dart';
import 'package:flutter_app/view/inscription.dart';

class FormScreen extends StatefulWidget {
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool passToggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulaire"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Form(
            key: _formfield,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/hinata.jpg",
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email)),
                    validator: (value) {
                      bool emailValid = RegExp(
                              r"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$")
                          .hasMatch(value!);
                      if (value!.isEmpty) {
                        return "Entrer Email";
                      } else if (!emailValid) {
                        return " Entrer Email valid";
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: passController,
                    obscureText: passToggle,
                    decoration: InputDecoration(
                        labelText: "Password",
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: InkWell(
                          onTap: () {
                            passToggle = !passToggle;

                            setState(() {});
                          },

                          child: Icon(passToggle
                              ? Icons.visibility
                              : Icons.visibility_off),
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Entrer un mot de passe ";
                      } else if (passController.text.length < 6) {
                        return "Le mot de passe doit etre superieur à 6 caractères ";
                      }
                    },
                  ),
                  const SizedBox(height: 60),
                  InkWell(
                      onTap: () async {
                        if (_formfield.currentState!.validate()) {
                          final emailText = emailController.text;
                          final passwordText = passController.text;

                          try {
                            final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: emailText,
                                password: passwordText
                            );
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context){
                                  return const DashboardPage();
                                }
                            ));
                            print('email and password match');
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                            }
                          }

                        }
                      },
                      child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                            child: Text(
                              "Connexion ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Vous n'avez pas de compte?",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context){
                                return const InscriptionPage();
                              }
                          ));
                        },
                        child: const Text(
                          "Inscription",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
