import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/view/form_screen.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({Key? key}) : super(key: key);


  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
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
                  const SizedBox(height: 50),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: nameController,
                    decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.account_circle_rounded)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Entrer un nom ";
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: surnameController,
                    decoration: const InputDecoration(
                        labelText: "Prénoms",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.account_circle_rounded)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Entrer un prénom ";
                      }
                    },
                  ),
                  const SizedBox(height: 30),
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


                          final userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(email: emailText, password: passwordText);
                          print(userCredential.user?.uid) ;
                          Map<String,dynamic> map = {
                            "NOM":nameController.text,
                            "PRENOM":surnameController.text,
                            "FAVORIS":[],
                            "EMAIL":emailController.text
                          };
                          FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).set(map);

                          Navigator.push(context, MaterialPageRoute(
                              builder: (context){
                                return FormScreen();
                              }
                          ));

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
                              "Inscription ",
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
                        "Vous avez déja un compte?",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context){
                                return FormScreen();
                              }
                          ));
                        },
                        child: const Text(
                          "Connexion",
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
