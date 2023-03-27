import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/PageRouting.dart';
import 'package:mental_health_app/pages/Authentication/utils.dart';
import 'package:mental_health_app/pages/ExtraFiles/AccountOperations.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResentEmail = false;
  var id;
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   //  user needs to create before
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified){
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
            (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(isEmailVerified)
      id = createAccount();

    if(isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async{
    try{
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResentEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResentEmail = true);
    } catch(e){
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? PageRouting(pageIndex: 0, Uid: id,)
      : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: EdgeInsets.only(left: 10),
              child: GestureDetector(
                child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey[800],
                      ),
                    )
                ),
                onTap: (){
                  FirebaseAuth.instance.signOut();
                },
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Text(
                    'Email verification',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    '     Please check your inbox and click \non the received link to verify email',
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    height: 300,
                    width: 400,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/introImages/verifyEmail.png'),
                            fit: BoxFit.fitHeight
                        )
                    ),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    height: 80,
                    width: 400,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurpleAccent,
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)
                          )
                      ),
                      child: Text(
                        'Resent Email',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: canResentEmail ? sendVerificationEmail : null,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      'wait few seconds....',
                      style: TextStyle(color: Colors.grey[800], fontSize: 13),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    width: 400,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                          primary: Colors.white,
                          side: const BorderSide(
                            width: 2,
                            color: Colors.grey,
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.grey[700],
                        ),
                      ),
                      onPressed: () => FirebaseAuth.instance.signOut(),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
}
