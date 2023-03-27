import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/main.dart';
import 'package:mental_health_app/pages/Authentication/AuthPage.dart';
import 'package:mental_health_app/pages/DiaryPages/diary.dart';
import 'package:mental_health_app/pages/ExtraFiles/Check_in.dart';
import 'package:mental_health_app/pages/HomePage/home.dart';
import 'package:mental_health_app/pages/SongPages/songHome.dart';
import 'package:mental_health_app/pages/TaskPages/task.dart';

class PageRouting extends StatefulWidget {
  // const PageRouting({Key? key}) : super(key: key);

  int pageIndex=0;
  var Uid;
  // for diary page
  bool isSuccess;
  var successMsg;
  PageRouting({
    required this.pageIndex,
    this.Uid,
    this.isSuccess = false,
    this.successMsg
  });

  @override
  _PageRoutingState createState() => _PageRoutingState();
}

class _PageRoutingState extends State<PageRouting> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser;
  var id;
  List Uinfo = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = widget.Uid;
    // widget.Uid == null ? FirebaseFirestore.instance.collection("anonymous_users").doc().id : widget.Uid;
    // widget.Uid = id;
    getIdMain();
  }

  Future<void> getIdMain() async {
    // if(widget.Uid == null)
    Uinfo = await getId();
  }

  @override
  Widget build(BuildContext context) {
    print('--------------- id from main.dart (init) : ${Uinfo}');
    // int pageIndex = 2;
    print('--------------- id from main.dart : ${widget.Uid}');
    print('--------------- successmsg : ${widget.successMsg}');
    print('--------------- issuccess : ${widget.isSuccess}');
    final pages = [HomePage(Uid: widget.Uid,), TaskPage(Uid: widget.Uid,), SongHomePage(Uid: widget.Uid,), DiaryPage(isSuccess: widget.isSuccess, successMsg: widget.successMsg,)];

    return Scaffold(
      key: _scaffoldKey,
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
      body: widget.pageIndex == 3 && user?.isAnonymous == true?
      Padding(
        padding: const EdgeInsets.only(top: 300),
        child: Center(
          child: Column(
            children: [
              Text(
                'Login first to get fetures\nthat save your progress... ',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey[800]
                ),
              ),
              SizedBox(height: 20,),
              Center(
                child: SizedBox(
                  height: 40,
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurpleAccent,
                        shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                        )
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder:(context) => AuthPage()
                      ));
                    },
                  ),
                ),
              ),
              SizedBox(height: 7,),
              Center(
                child: SizedBox(
                  height: 40,
                  width: 100,
                  child: TextButton(
                    child: Text(
                      'Later',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    onPressed: (){
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) => new PageRouting(pageIndex: 0))
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ):
      pages[widget.pageIndex],
    );
  }
}
