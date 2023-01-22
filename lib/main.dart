// import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/pages/DiaryPages/diary.dart';
import 'package:mental_health_app/pages/HomePage/home.dart';
import 'package:mental_health_app/pages/SongPages/songHome.dart';
import 'package:mental_health_app/pages/TaskPages/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: MyApp(pageIndex: 0,),
  ));
}

class MyApp extends StatefulWidget {
  // const MyApp({Key? key}) : super(key: key);

  int pageIndex=0;
  var Uid;
  // for diary page
  bool isSuccess;
  var successMsg;
  MyApp({
    required this.pageIndex,
    this.Uid,
    this.isSuccess = false,
    this.successMsg
   });
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String id = widget.Uid == null ? FirebaseFirestore.instance.collection("anonymous_users").doc().id : widget.Uid;
    widget.Uid = id;
    print('--------------- id from main.dart (init) : ${id}');
  }

  @override
  Widget build(BuildContext context) {
    // int pageIndex = 2;
    print('--------------- id from main.dart : ${widget.Uid}');
    print('--------------- successmsg : ${widget.successMsg}');
    print('--------------- issuccess : ${widget.isSuccess}');
    final pages = [HomePage(Uid: widget.Uid,), TaskPage(Uid: widget.Uid,), SongHomePage(Uid: widget.Uid,), DiaryPage(isSuccess: widget.isSuccess, successMsg: widget.successMsg,)];

    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton(
              onPressed: () {
                setState(() {
                  widget.pageIndex = 0;
                });
              },
              child: widget.pageIndex == 0 ?
              Icon(
                Icons.home_filled,
                color: Colors.white,
                size: 30,
              )
              : Icon(
                Icons.home_outlined,
                color: Colors.white30,
                size: 30,
              ),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  widget.pageIndex = 1;
                });
              },
              child: widget.pageIndex == 1 ?
              Icon(
                Icons.work_rounded,
                color: Colors.white,
                size: 30,
              )
                  : Icon(
                Icons.work_outline_outlined,
                color: Colors.white30,
                size: 30,
              ),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  widget.pageIndex = 2;
                });
              },
              child: widget.pageIndex == 2 ?
              Icon(
                Icons.music_note_rounded,
                color: Colors.white,
                size: 30,
              )
                  : Icon(
                Icons.music_note_outlined,
                color: Colors.white30,
                size: 30,
              ),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  widget.pageIndex = 3;
                });
              },
              child: widget.pageIndex == 3 ?
              Icon(
                Icons.sticky_note_2_rounded,
                color: Colors.white,
                size: 30,
              )
                  : Icon(
                Icons.sticky_note_2_outlined,
                color: Colors.white30,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      body: pages[widget.pageIndex],
    );
  }
}
