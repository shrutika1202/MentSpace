import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/PageRouting.dart';
import 'package:mental_health_app/pages/HomePage/home.dart';
import 'package:mental_health_app/pages/ProfilePages/EditAvatar.dart';
import 'package:mental_health_app/pages/ProfilePages/FeedbackPage.dart';
import 'package:mental_health_app/pages/SettingsPage/SettingsPage.dart';

import 'ShareProgress.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({Key? key}) : super(key: key);

  @override
  _ProfileHomeState createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  var successStatus = [];
  var Uinfo2;

  Future<HashMap<String, dynamic>> getEventsFromFirestore() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    QuerySnapshot eventsQuery = await ref
        .where("email", isEqualTo: user?.email)
        .get();

    HashMap<String, dynamic> eventsHashMap = new HashMap<String, dynamic>();
    eventsQuery.docs.forEach((element) {
      eventsHashMap.addAll({'uname': element['uname'], 'avatar': element['avatar'], 'status': element['status']});
    });

    setState(() {
      Uinfo2 = eventsHashMap;
      successStatus = [
        {'count': Uinfo2['status']['tasks'], 'title': ' Activities \nCompleted', 'icon': 'task'},
        {'count': '${Uinfo2['status']['listen_count']}m', 'title': 'Listen \n Time', 'icon': 'song'},
        {'count': Uinfo2['status']['journal'], 'title': 'Journal \nEntries', 'icon': 'diary'},
        {'count': Uinfo2['status']['check_in'], 'title': 'Checked \n      In', 'icon': 'check-in'},
      ];
    });

    return eventsHashMap;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEventsFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    getEventsFromFirestore();

    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: GestureDetector(
            child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey[500],
                  ),
                )
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
        ),
        // actions: [
        //   Padding(
        //       padding: EdgeInsets.only(right: 26,),
        //       child: CircleAvatar(
        //         backgroundColor: Colors.white,
        //         radius: 25,
        //         child: Icon(
        //           Icons.notifications_none,
        //           color: Colors.grey[700],
        //         ),
        //       )
        //   ),
        // ],
      ),
      body: FutureBuilder(
        future: db.collection('users')
        .where('email', isEqualTo: user?.email)
        .get(),
        builder: (context, snapshot){
          // if(snapshot.connectionState == ConnectionState.waiting){
          //   return Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }

          // Uinfo = ((snapshot.data as QuerySnapshot).docs)[0];



          return Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 30, 10),
            child: Container(
              width: 600,
              // color: Colors.grey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    SizedBox(
                        height: 150,
                        child: GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[500],
                            child: Uinfo2 == null ? CircularProgressIndicator() : Image.asset('assets/avatar/${Uinfo2['avatar']}.png'),
                            radius: 70,
                          ),
                          onTap: (){
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => new EditAvatar(avatar: Uinfo2['avatar'],))
                            );
                          },
                        )
                    ),
                    SizedBox(height: 5,),
                    GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${Uinfo2 == null ? 'user' : Uinfo2['uname']}',
                            style: TextStyle(
                                letterSpacing: 3,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800]
                            ),
                          ),
                          SizedBox(width: 5,),
                          Icon(
                            Icons.edit,
                            color: Colors.grey[800],
                          ),
                        ],
                      ),
                      onTap: (){
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => new ChangeUserName(uname: Uinfo2['uname']))
                        );
                      },
                    ),
                    SizedBox(height: 20,),
                    Wrap(
                      children: [
                        for(int i=0; i< 4; i++)
                          Padding(
                            padding: const EdgeInsets.only(right: 20, bottom: 20),
                            child: SizedBox(
                              height: 230,
                              width: 150,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 0,
                                color: Colors.white54,
                                child: Uinfo2 != null && successStatus != [] ? Column(
                                  children: [
                                    SizedBox(height: 40,),
                                    Text(
                                      '${successStatus == [] ? 0 : successStatus[i]['count']}',
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[800]
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Text(
                                        '${successStatus == [] ? 'activities' : successStatus[i]['title']}'
                                    ),
                                    SizedBox(height: 20,),
                                    successStatus[i]['icon'] == 'task'
                                        ? Icon(Icons.work_outline_outlined, size: 50, color: Colors.grey[500],)
                                        : (successStatus[i]['icon'] == 'song'
                                        ? Icon(Icons.music_note_outlined, size: 50, color: Colors.grey[500],)
                                        : (successStatus[i]['icon'] == 'diary'
                                        ? Icon(Icons.bookmarks_outlined, size: 50, color: Colors.grey[500],)
                                        : Icon(Icons.emoji_emotions_outlined, size: 50, color: Colors.grey[500],))),
                                  ],
                                ) : Center(child: CircularProgressIndicator(),),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(right: 5, left: 5),
                      child: Card(
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 25,),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 20),
                              child: GestureDetector(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.share,
                                      size: 18,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15, right: 180),
                                      child: Text(
                                        'share',
                                        style: TextStyle(
                                            fontSize: 16
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    ),
                                  ],
                                ),
                                onTap: (){
                                  Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) => new ShareProgress()
                                  ));
                                },
                              ),
                            ),
                            SizedBox(height: 15,),
                            Divider(
                              height: 5,
                              thickness: 2,
                              indent: 48,
                              endIndent: 5,
                            ),
                            SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 20),
                              child: GestureDetector(
                                child: Row(
                                  children: [
                                    Icon(Icons.message_outlined, size: 18,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 100),
                                      child: Text('give us feedback',
                                        style: TextStyle(
                                            fontSize: 16
                                        ),),
                                    ),
                                    Icon(Icons.arrow_forward_ios, size: 18,),
                                  ],
                                ),
                                onTap: (){
                                  Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) => new FeedbackPage()
                                  ));
                                },
                              ),
                            ),
                            SizedBox(height: 15,),
                            Divider(
                              height: 5,
                              thickness: 2,
                              indent: 48,
                              endIndent: 5,
                            ),
                            SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 20),
                              child: GestureDetector(
                                child: Row(
                                  children: [
                                    Icon(Icons.punch_clock_sharp, size: 18,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 160),
                                      child: Text('check-in',
                                        style: TextStyle(
                                            fontSize: 16
                                        ),),
                                    ),
                                    Icon(Icons.arrow_forward_ios, size: 18,),
                                  ],
                                ),
                                onTap: (){
                                  Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) => new PageRouting(pageIndex: 0))
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 15,),
                            Divider(
                              height: 5,
                              thickness: 2,
                              indent: 48,
                              endIndent: 5,
                            ),
                            SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 20),
                              child: GestureDetector(
                                child: Row(
                                  children: [
                                    Icon(Icons.settings, size: 18,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 160),
                                      child: Text('settings',
                                        style: TextStyle(
                                            fontSize: 16
                                        ),),
                                    ),
                                    Icon(Icons.arrow_forward_ios, size: 18,),
                                  ],
                                ),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => new SettingsPage()
                                  ));
                                },
                              ),
                            ),
                            SizedBox(height: 15,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


