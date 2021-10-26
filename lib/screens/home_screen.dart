import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'notification_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;


  late List<DocumentSnapshot> users;

  @override
  void initState() {
    fetchUsers();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      print("onMessage: $message");
      showMessage("Notification", "$message");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: $message");
      RemoteNotification? notification = message.notification;
      print("onMessage: $message");
      showMessage("Notification", "$message");
    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message)
    {
      print("onBackgroundMessage: $message");
      RemoteNotification? notification = message.notification;
      print("onMessage: $message");
      showMessage("Notification", "$message");
    });

    // firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     showMessage("Notification", "$message");
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     showMessage("Notification", "$message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     showMessage("Notification", "$message");
    //   },
    // );

    // if (Platform.isIOS) {
    //   firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(
    //         sound: true, badge: true, alert: true, provisional: false),
    //   );
    // }

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:const Text(
          "Home",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon:const Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((a) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: Container(
        child: users != null
            ? ListView.builder(
          itemBuilder: (ctx, index) {
            return Container(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(users[index]['email']
                      .toString()
                      .substring(0, 1)),
                ),
                title: Text(users[index]['email']),
                onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NotificationScreen(to: users[index]),
                                ),
                              );
                },
              ),
            );
          },
          itemCount: users.length,
        )
            : CircularProgressIndicator(),
      ),
    );
      // body: Container(),
      // body: Container(
      //   child: users != null
      //       ? ListView.builder(
      //     itemBuilder: (ctx, index) {
      //       return  Container(
      //         child: ListTile(
      //           leading: CircleAvatar(
      //             child: Text(users[index].data()['email'] ?? ''
      //
      //                 .toString()
      //                 .substring(0, 1)),
      //           ),
      //           title: Text(users[index].data()["email"]??''),
      //           onTap: () {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) =>
      //                     NotificationScreen(to: users[index]),
      //               ),
      //             );
      //           },
      //         ),
      //       );
      //     },
      //     itemCount: users.length,
      //   )
      //       : CircularProgressIndicator(),
      // ),
  }
  showMessage(title, description) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(title),
            content: Text(description),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text("Dismiss"),
              )
            ],
          );
        });
  }

  fetchUsers() async {
    QuerySnapshot snapshot = await db.collection("users").get();
    setState(() {
      users = snapshot.docs;
    });
  }
}
