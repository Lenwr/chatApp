import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SendMessageView extends StatefulWidget {
  final String userID ;
  const SendMessageView({Key? key, required this.userID}) : super(key: key);
  @override
  State<SendMessageView> createState() => _SendMessageViewState();
}

class _SendMessageViewState extends State<SendMessageView> {
  final String userID = "";
  final TextEditingController _textController = TextEditingController();
  List<String> _messages = [];

  void _handleSubmit(String text) {
    _textController.clear();
    setState(() {
      _messages.insert(0, text);
    });
    FirebaseFirestore.instance.collection('messages').add({
      'SENDER': "",
      'MESSAGE': text,
      'RECEIVER':widget.userID,
    });
  }

  Widget _buildTextComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmit,
              decoration: InputDecoration.collapsed(
                hintText: "Envoyer un message",
                hintStyle: TextStyle(
                  color: Colors.grey.withOpacity(0.8),
                  fontSize: 16.0,
                ),
              ),
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: () => {
                print(userID),
                if(_textController.text == "") {
                  print ("error")
                } else
                _handleSubmit(_textController.text),
              }
            ),
          ),
        ],
      ),
    );
  }

   Widget _buildMessageList() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView.builder(
          reverse: true,
          itemCount: _messages.length,
          itemBuilder: (_, int index) => _buildMessage(_messages[index]),
        ),
      ),
    );
  }



  Widget _buildMessage(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          _buildMessageList(),
          _buildTextComposer(),
        ],
      ),
    );
  }


}