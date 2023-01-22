import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/pages/QuizPages/quizStart.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../ExtraFiles/Check_in.dart';

class HomePage extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);

  var Uid;
  HomePage({this.Uid});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  final slider = SleekCircularSlider(
    // appearance: CircularSliderAppearance(),
    //   onChange: (double value) {
    //     print(value);
    //   }
      );
  double val = 0;
  List<String> mood = ['great','good','ok','bad','awful'];
  String moodi = '';

  // firebase storage images
  Future getImageUrl() async{
    final storageRef = FirebaseStorage.instance.ref();
    final islandRef = storageRef.child('TaskImages/jimin.png');
    final file = File('C:/Users/shrut/Documents/TYBsc/Final Project/apps for practice/mental_health_app/assets/images/jimin.png');
    final downloadTask = islandRef.writeToFile(file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/jimin.jpg'),
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                  fit: BoxFit.cover
              )
          ),
        ),
        toolbarHeight: 180.0,
        backgroundColor: Colors.deepPurple[700],
        title: RichText(
          text: TextSpan(
            text: 'Welcome user !!',
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
          Padding(
            padding: EdgeInsets.all(30),
            child: CircleAvatar(
                radius: 40,
                child: Icon(Icons.person)
            ),
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
              String id = widget.Uid == null ? db.collection("anonymous_users").doc().id : widget.Uid;

              rec_user(id, mood[val.toInt()], null);
              // db.collection("anonymous_users").doc(id).set({'mood': mood[val.toInt()]});
              print('--------------- doc id home.dart : ${id}');

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
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 30, 20, 30),
                  child: Container(
                    height: 200,
                    width: 160,
                    decoration: BoxDecoration(
                      // image: DecorationImage(
                      //     image: AssetImage('assets/images/${mood[val.toInt()]}.jpg'),
                      //     fit: BoxFit.contain,
                      //     repeat: ImageRepeat.noRepeat
                      // ),
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(right: 50,bottom: 15),
                        child: Text(
                          'Healthy Thinking',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 30, 20, 30),
                  child: Container(
                    height: 200,
                    width: 160,
                    decoration: BoxDecoration(
                      // image: DecorationImage(
                      //     image: AssetImage('assets/images/${mood[val.toInt()]}.jpg'),
                      //     fit: BoxFit.contain,
                      //     repeat: ImageRepeat.noRepeat
                      // ),
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(right: 50,bottom: 15),
                        child: Text(
                          'Healthy Thinking',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 30, 20, 30),
                  child: Container(
                    height: 200,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      // image: DecorationImage(
                      //     image: AssetImage('assets/images/${mood[val.toInt()]}.jpg'),
                      //     fit: BoxFit.contain,
                      //     repeat: ImageRepeat.noRepeat
                      // ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(right: 50,bottom: 15),
                        child: Text(
                          'Healthy Thinking',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    )
    );
  }
}
