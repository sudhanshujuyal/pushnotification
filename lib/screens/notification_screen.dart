import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class NotificationScreen extends StatefulWidget
{
  final DocumentSnapshot to;

  NotificationScreen({
    required this.to,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
{
  TextEditingController _messageController = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late User user;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.to['email']),
      ),
      body: Container(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: "Write message here",
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: handleInput(_messageController.text),
                ),
              ),
              FloatingActionButton(
                onPressed: (){
                  handleInput(_messageController.text);
                },
                child: Icon(
                    Icons.send
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void fetchUser() async {
    User? u = await auth.currentUser;
    setState(() {
      user = u!;
    });
  }
  handleInput(String input) {
    print(input);

    db.collection("users").doc(widget.to.id)
        .collection("notifications").add({
      "message": input,
      "title": user.email,
      "date": FieldValue.serverTimestamp()
    }).then((doc){
      _messageController.clear();
    });
  }
}
