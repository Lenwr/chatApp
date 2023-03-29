import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/utilisateur.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final cloudUsers = FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: cloudUsers.snapshots(),
          builder: (context,snap){
          List documents = snap.data?.docs ?? [];
          print(documents.length);
          if(documents.isEmpty){
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          else {
           return  ListView.builder(
             itemCount: documents.length,
             itemBuilder: (context,index){
              Utilisateur otherUser = Utilisateur(documents[index]);
               return Center(
                 child: Card(
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: <Widget>[
                        ListTile(
                         leading: Icon(Icons.account_circle_rounded),
                         title: Text(otherUser.nom ?? ""),
                         subtitle: Text(''),
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: <Widget>[
                           TextButton(
                             child: const Text('Message'),
                             onPressed: () {/* ... */},
                           ),
                           const SizedBox(width: 8),
                           TextButton(
                             child: const Text('Appeler'),
                             onPressed: () {/* ... */},
                           ),
                           const SizedBox(height: 10),
                         ],
                       ),
                     ],
                   ),
                 ),
               );

             },

            );
          }
          }
      ),
    );
  }
}

