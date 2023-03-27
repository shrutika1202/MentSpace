import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mental_health_app/getStarted.dart';
import 'package:mental_health_app/main.dart';
import 'package:mental_health_app/pages/ExtraFiles/AccountOperations.dart';
import 'package:mental_health_app/pages/SettingsPage/CheckInTime.dart';
import 'package:share_plus/share_plus.dart';

import '../Authentication/forgotPassword.dart';
import 'AboutPage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  var Uinfo;

  Future<HashMap<String, dynamic>> getEventsFromFirestore() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    QuerySnapshot eventsQuery = await ref
        .where("email", isEqualTo: user?.email)
        .get();

    HashMap<String, dynamic> eventsHashMap = new HashMap<String, dynamic>();
    eventsQuery.docs.forEach((element) {
      eventsHashMap.addAll({'uname': element['uname'], 'check-in_time': element['check-in_time']});
    });

    setState(() {
      Uinfo = eventsHashMap;
    });

    return eventsHashMap;
  }

  @override
  Widget build(BuildContext context) {
    getEventsFromFirestore();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
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

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40,),
                Text(
                  'Settings',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey[800],
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  'Customize your account',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      letterSpacing: 2,
                      fontWeight: FontWeight.w400
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 2, right: 2),
                      child: ListTile(
                        title: Text('Change check-in time'),
                        trailing: Uinfo != null
                            ? Text(
                          Uinfo['check-in_time'],
                          style: TextStyle(
                              color: Colors.deepPurpleAccent
                          ),
                        )
                            : CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => new CheckInTime(checkIn_time: Uinfo['check-in_time'],)
                    ));
                  },
                ),
                SizedBox(height: 20,),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: Padding(
                            padding: EdgeInsets.only(top: 18, bottom: 18, left: 15),
                            child: Text(
                              'About the app',
                              style: TextStyle(
                                  fontSize: 15
                              ),
                            )
                        ),
                        onTap: (){
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => new AboutUs()
                          ));
                        },
                      ),
                      Divider(
                        height: 5,
                        thickness: 2,
                        indent: 17,
                        endIndent: 17,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 18, bottom: 18, left: 15),
                          child: GestureDetector(
                            child: Text(
                              'Reset data',
                              style: TextStyle(
                                  fontSize: 15
                              ),
                            ),
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      backgroundColor: Colors.grey[300],
                                      title: Text('Are you sure ?'),
                                      actions: [
                                        TextButton(
                                          child: Text('yes'),
                                          onPressed: (){
                                            db.collection('users').get().then((value){
                                              value.docs.forEach((element) {
                                                if(element['email'] == user?.email){
                                                  var status = {'tasks': 0, 'listen_count': 0, 'journal': 0, 'check_in': 0};
                                                  db.collection('users').doc(element.id).update({
                                                    'uid': element.id, 'email': user!.email, 'avatar': 'owl', 'uname': 'buddy','check-in_time': 'Evening', 'status': status, 'favSongs': [], 'favTasks': [], 'songs': [], 'tasks': []
                                                  });
                                                }
                                              });
                                            });
                                            db.collection('FavSong').get().then((value){
                                              value.docs.forEach((element) {
                                                if(element['user'] == user?.email){
                                                  db.collection('FavSong').doc(element.id).delete();
                                                }
                                              });
                                            });

                                            Navigator.of(context).pop();

                                            Fluttertoast.showToast(
                                                msg: "data reset successfully",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.black26,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                            );
                                          },
                                        ),
                                        TextButton(
                                          child: Text('no'),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                          )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 18, bottom: 18, left: 15),
                          child: GestureDetector(
                            child: Text(
                              'What should we call you?',
                              style: TextStyle(
                                  fontSize: 15
                              ),
                            ),
                            onTap: (){
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => ChangeUserName(uname: Uinfo['uname'],)
                              ));
                            },
                          )
                      ),
                      Divider(
                        height: 5,
                        thickness: 2,
                        indent: 17,
                        endIndent: 17,
                      ),
                      // not found
                      // Padding(
                      //     padding: EdgeInsets.only(top: 18, bottom: 18, left: 15),
                      //     child: Text(
                      //       'Update email',
                      //       style: TextStyle(
                      //           fontSize: 15
                      //       ),
                      //     )
                      // ),
                      // Divider(
                      //   height: 5,
                      //   thickness: 2,
                      //   indent: 17,
                      //   endIndent: 17,
                      // ),
                      Padding(
                          padding: EdgeInsets.only(top: 18, bottom: 18, left: 15),
                          child: GestureDetector(
                            child: Text(
                              'Reset Password',
                              style: TextStyle(
                                  fontSize: 15
                              ),
                            ),
                            onTap: (){
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => ForegotPasswordPage(isFromSettings: true,)
                              ));
                            },
                          )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 18, bottom: 18, left: 15),
                          child: GestureDetector(
                            child: Text(
                              'Log out',
                              style: TextStyle(
                                  fontSize: 15
                              ),
                            ),
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      backgroundColor: Colors.grey[300],
                                      title: Text('Are you sure ?'),
                                      actions: [
                                        TextButton(
                                          child: Text('yes'),
                                          onPressed: (){
                                            FirebaseAuth.instance.signOut().then((value){
                                              Fluttertoast.showToast(
                                                  msg: "Logged out",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0
                                              );
                                              Navigator.of(context).pushAndRemoveUntil(
                                                  new MaterialPageRoute(
                                                      builder: (context) => GetStarted()),
                                                      (Route<dynamic> route) => false);
                                            });
                                          },
                                        ),
                                        TextButton(
                                          child: Text('no'),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                          )
                      ),
                      Divider(
                        height: 5,
                        thickness: 2,
                        indent: 17,
                        endIndent: 17,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 18, bottom: 18, left: 15),
                          child: GestureDetector(
                            child: Text(
                              'Delete account',
                              style: TextStyle(
                                  fontSize: 15
                              ),
                            ),
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      backgroundColor: Colors.grey[300],
                                      title: Text('Are you sure ?'),
                                      actions: [
                                        TextButton(
                                          child: Text('yes'),
                                          onPressed: (){
                                            // delete user from authentication db
                                            user?.delete().then((value){
                                              //delete user from db
                                              db.collection('users').get().then((value){
                                                value.docs.forEach((element) {
                                                  try{
                                                    if(element['email'] == user?.email){
                                                      db.collection('users').doc(element.id).delete();
                                                    }
                                                  }catch(e){}
                                                });
                                              });

                                              Fluttertoast.showToast(
                                                  msg: "Account deleted successfully",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0
                                              );

                                              Navigator.of(context).pushAndRemoveUntil(
                                                  new MaterialPageRoute(
                                                      builder: (context) => new MyApp()),
                                                      (Route<dynamic> route) => false);

                                            });
                                          },
                                        ),
                                        TextButton(
                                          child: Text('no'),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class ChangeUserName extends StatefulWidget {
  // const ChangeUserName({Key? key}) : super(key: key);

  var uname;
  ChangeUserName({
    required this.uname,
  });
  @override
  _ChangeUserNameState createState() => _ChangeUserNameState();
}

class _ChangeUserNameState extends State<ChangeUserName> {
  late TextEditingController textController = TextEditingController(text: '${widget.uname}');
  var uname;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
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
      ),
      body: Column(
        children: [
          SizedBox(height: 40,),
          Text(
              'What should we call you?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: textController,
              cursorColor: Colors.black26,
              decoration: InputDecoration(
                floatingLabelStyle: TextStyle(color: Colors.white12),
                filled: false,
                labelText: 'First Name',
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white12)
                )
              ),
              onChanged: (value){
                setState(() {
                  uname = value;
                });
              },
            ),
          ),
          SizedBox(height: 100,),
          SizedBox(
            height: 50,
            width: 390,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent,
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  )
              ),
              onPressed: (){
                // update uname to db
                print('------- from settings uname : ${uname}');
                updateAccount('uname', uname);
                Fluttertoast.showToast(
                    msg: "Username updated successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                Navigator.of(context).pop();
              },
              child: Text(
                  'Save',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  letterSpacing: 1
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
