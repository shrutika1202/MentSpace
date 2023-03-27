import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/pages/QuizPages/quizStart.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../main.dart';
import '../Authentication/AuthPage.dart';
import '../ProfilePages/ProfileHome.dart';
import '../ExtraFiles/Check_in.dart';
import '../ExtraFiles/AccountOperations.dart';
import '../TaskPages/taskDesp.dart';

class HomePage extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);

  var Uid;
  HomePage({this.Uid});
  @override
  _HomePageState createState() => _HomePageState();
}
var urlList = {};
class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  var Uinfo;
  final slider = SleekCircularSlider(
    // appearance: CircularSliderAppearance(),
    //   onChange: (double value) {
    //     print(value);
    //   }
      );
  double val = 0;
  List<String> mood = ['great','good','ok','bad','tired'];
  String moodi = '';


  Future<void> downloadURLExample(img) async {
    var downloadURL = await FirebaseStorage.instance
        .ref()
        .child("TasksImages/${img}.png")
        .getDownloadURL();
    urlList['${img}'] = downloadURL;
  }

  // firebase storage images
  // Future getImageUrl() async{
  //   final storageRef = FirebaseStorage.instance.ref();
  //   final islandRef = storageRef.child('TaskImages/jimin.png');
  //   final file = File('C:/Users/shrut/Documents/TYBsc/Final Project/apps for practice/mental_health_app/assets/images/jimin.png');
  //   final downloadTask = islandRef.writeToFile(file);
  // }

  Future<HashMap<String, dynamic>> getEventsFromFirestore() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    QuerySnapshot eventsQuery = await ref
        .where("${user?.isAnonymous == true ? 'anon_uid' : 'email'}", isEqualTo: user?.isAnonymous == true ? user?.uid : user?.email)
        .get();

    HashMap<String, dynamic> eventsHashMap = new HashMap<String, dynamic>();
    eventsQuery.docs.forEach((element) {
      eventsHashMap.addAll({'uname': element['uname'], 'avatar': element['avatar']});
    });

    setState(() {
      Uinfo = eventsHashMap;
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
    // print('------------- urlList : ${urlList}');
    // getEventsFromFirestore();
    // print('----------- Uinfo : ${Uinfo}');

    return Scaffold(
        key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/homeImage.png'),
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                  fit: BoxFit.cover
              )
          ),
        ),
        toolbarHeight: 180.0,
        backgroundColor: Colors.deepPurple[700],
        title: RichText(
          text: TextSpan(
            text: 'Welcome ${Uinfo == null ? 'user' : Uinfo['uname']} !!',
            style: TextStyle(
                fontSize: 28,
                color: Colors.white
            ),
            children: <TextSpan>[
              TextSpan(text: '\n'),
              TextSpan(
                text: '\nwe make you feel special....',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.deepPurpleAccent[100]
                ),
              ),
              TextSpan(
                text: '\ncause everyone is SPECIAL.',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.deepPurpleAccent[100]
                ),
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircleAvatar(
                  radius: 40,
                  child: Uinfo == null ? CircularProgressIndicator() : Image.asset('assets/avatar/${Uinfo['avatar']}.png')
              ),
            ),
            onTap: (){
              if(user?.isAnonymous == true){
                showDialog(
                  context: _scaffoldKey.currentContext!,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: Column(
                      children: [
                        Center(
                            child: Text(
                              'Login first to get fetures\nthat save your progress... ',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey[800]
                              ),
                            )
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
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }else if(user?.isAnonymous == false){
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => new ProfileHome())
                );
              }

            },
          ),
        ],
      ),
      body: Container(
      decoration: BoxDecoration(
        color: Colors.white60,
        // borderRadius: BorderRadius.only(topRight: Radius.circular(150))
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20,),
          Center(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 60,
              foregroundImage: AssetImage('assets/images/${mood[val.toInt()]}.png'),
            ),
          ),
          Slider(
            value: val,
            onChanged: (value){
              setState(() {
                val = value;
                print(value);
              });
            },
            min: 0,
            max: 4,
            activeColor: Colors.blueGrey[500],
            inactiveColor: Colors.white,
          ),
          SizedBox(height: 15,),
          ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(15),
              overlayColor: MaterialStateProperty.all(Colors.grey[200]),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.white)
                  )
              ),
            ),
            onPressed: () async{
              // create id if new anonymous user checked in
              String id = widget.Uid == null ? db.collection("anonymous_users").doc().id : widget.Uid;
              rec_user(id, mood[val.toInt()], user?.isAnonymous == true ? user?.uid : user?.email);

              if(user?.isAnonymous == false){
                //update check-in status on profile
                updateStatus('check_in', 1);
              }

              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => new QuizStart(mood: mood[val.toInt()], Uid: id,))
              );
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 15),
              child: RichText(
                text: TextSpan(
                  text: 'im feeling ${mood[val.toInt()]}. ',
                  style: TextStyle(
                      color: Colors.deepPurple
                  ),
                  children: [
                    TextSpan(
                        text: ' Submit',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.deepPurple
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 40,),
          Divider(
            indent: 16,
            endIndent: 16,
            height: 5,
            color: Colors.blueGrey,
          ),
          SizedBox(height: 25,),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                'General tasks',
                style: TextStyle(
                  letterSpacing: 3,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                'Choose task to level up your mood',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey
                ),
              ),
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('taskList').where('mood', isEqualTo: 'happy').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData){
                return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 300),
                      child: CircularProgressIndicator(),
                    )
                );
              }

              return Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  // shrinkWrap: true,
                  children: snapshot.data!.docs.map((document){
                    downloadURLExample(document['title']);
                    return Padding(
                      padding: EdgeInsets.fromLTRB(25, 30, 20, 30),
                      child: GestureDetector(
                        child: Container(
                          height: 200,
                          width: 160,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/homeTasks/${document['title']}.png'),
                                colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.6), BlendMode.modulate,),
                                fit: BoxFit.cover,
                                // repeat: ImageRepeat.noRepeat,
                            ),
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(right: 50,bottom: 15, left: 10),
                              child: Text(
                                '${document['title']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => new TaskDespPage(
                                Uid: widget.Uid,
                                index: -1,
                                title: document['title'],
                                desp: document['desp'],
                                isCompleted: document['isCompleted'],
                                rem: document['rem'],
                                isFav: document['isFav'],
                                ref: document['ref'],
                                url: urlList[document['title']],
                              ))
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    )
    );
  }
}



























