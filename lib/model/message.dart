import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  //attributs
  late String uid;
  String? senderId;
  String? receiverId;
  String? message;





  //constructeur

 Message.empty(){
    uid = "";
    senderId = "";
   receiverId = "";
    message = "";
  }

  Message(DocumentSnapshot snapshot){
    uid = snapshot.id;
    Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
    senderId = map["SENDER"];
    receiverId = map["RECEIVER"];
    message = map["MESSAGE"];

  }








}