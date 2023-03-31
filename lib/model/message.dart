import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  //attributs
  late String uid;
  late String senderId;
  late String receiverId;
  late String message;
  late DateTime date;

  //constructeur
 Message.empty(){
    uid = "";
    senderId = "";
   receiverId = "";
    message = "";
    date = DateTime.now();
  }

  Message(DocumentSnapshot snapshot){
    uid = snapshot.id;
    Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
    senderId = map["SENDER"];
    receiverId = map["RECEIVER"];
    message = map["MESSAGE"];
    Timestamp timestamp = map["DATE"];
    date = timestamp.toDate();

  }








}