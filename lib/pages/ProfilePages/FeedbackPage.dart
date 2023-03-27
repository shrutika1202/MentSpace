import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

final user = FirebaseAuth.instance.currentUser;

class _FeedbackPageState extends State<FeedbackPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: '${user?.email}');
  final subjController = TextEditingController();
  final contentController = TextEditingController();
  final nameController = TextEditingController();
  var email;
  var subj;
  var cont;
  var name;

  Future sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  })async{
    final serviceId = 'service_24hcpwb';
    final templateId = 'template_r3ti15h';
    final userId = 'RkIpaFYrSf_bq1Mid';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'user_subject': subject,
          'user_message': message,
        }
      })
    );

    print(response.body);
  }

  void sendFeedback() async{
    final isValid = formKey.currentState!.validate();
    if(!isValid) return;

    try{
      sendEmail(name: 'buddy', email: email, subject: subj, message: cont).then((value){
        Fluttertoast.showToast(
            msg: "Feedback send",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.of(context).pop();
      });
    } catch(e) {
      print(e);
    //  snackbar for error
    }

  //  show dialog box and navigator pop

  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    subjController.dispose();
    contentController.dispose();
    nameController.dispose();
    super.dispose();
  }

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
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                      'Contact us',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey[800],
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                TextFormField(
                  controller: emailController,
                  cursorColor: Colors.grey[700],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white54,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white30
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Email',
                  ),
                  onChanged: (value){
                    setState(() {
                      email = value;
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                  email != null && !EmailValidator.validate(email.trim())
                      ? 'Enter valid email'
                      : null,
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: nameController,
                  cursorColor: Colors.grey[700],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white54,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white30
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'name'
                  ),
                  onChanged: (value){
                    setState(() {
                      name = value;
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (uname) =>
                  uname != null && uname.length < 3
                      ? 'Name at least greater than 3'
                      : null,
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: subjController,
                  cursorColor: Colors.grey[700],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white54,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white30
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'subject'
                  ),
                  onChanged: (value){
                    setState(() {
                      subj = value;
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (uname) =>
                  uname != null && uname.length < 4
                      ? 'Subject is too small'
                      : null,
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: contentController,
                  cursorColor: Colors.grey[700],
                  textInputAction: TextInputAction.next,
                  maxLines: 9,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white54,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white30
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'details'
                  ),
                  onChanged: (value){
                    cont = value;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (uname) =>
                  uname != null && uname.length < 5
                      ? 'Plaease provide more details'
                      : null,
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
                      'Submit',
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.white
                      ),
                    ),
                    onPressed: sendFeedback,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
