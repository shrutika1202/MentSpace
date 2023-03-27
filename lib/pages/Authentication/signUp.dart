import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mental_health_app/pages/Authentication/utils.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'googleSignIn.dart';

class SignUp extends StatefulWidget {
  final Function() onClickSignIn;

  const SignUp({Key? key, required this.onClickSignIn}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwdController = TextEditingController();
  final unameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwdController.dispose();
    super.dispose();
  }

  void signUp() async{
    final isValid = formKey.currentState!.validate();
    if(!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>  Center(child: CircularProgressIndicator(),)
    );

    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwdController.text.trim(),
      );
    } on FirebaseAuthException catch(e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => GoogleSignInProvider(),
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: 100,),
                  Text(
                    'Welcome to app',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(height: 65,),
                  TextFormField(
                    controller: unameController,
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
                        hintText: 'username'
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (uname) =>
                    uname != null && uname.length < 2
                        ? 'Enter username'
                        : null,
                  ),
                  SizedBox(height: 20,),
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
                        hintText: 'Email'
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                       email != null && !EmailValidator.validate(email.trim())
                         ? 'Enter valid email'
                         : null,
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: passwdController,
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
                        hintText: 'Password'
                    ),
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value != null && value.length < 6
                      ? 'Enter min. 6 characters'
                      : null,
                  ),
                  SizedBox(height: 30,),
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
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.white
                        ),
                      ),
                      onPressed: signUp,
                    ),
                  ),
                  SizedBox(height: 70,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          color: Colors.grey[400],
                          height: 2,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey[800], fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey[400],
                          height: 3,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  GestureDetector(
                    child: Container(
                      height: 70,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 3, color: Colors.white70),
                        color: Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                              border: Border.all(width: 3, color: Colors.white),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.network(
                                'https://tse3.mm.bing.net/th?id=OIP.Kg2FF2wpIK_HLyo8Q56ycAHaFj&pid=Api&P=0',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Text(
                              'Sign Up with Google',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[800]
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                      provider.googleLogin();
                    },
                  ),
                  SizedBox(height: 70,),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //       minimumSize: Size.fromHeight(50)
                  //   ),
                  //   child: Text(
                  //     'Sign Up with Google',
                  //     style: TextStyle(fontSize: 24),
                  //   ),
                  //   onPressed: (){
                  //     final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                  //     provider.googleLogin();
                  //   },
                  // ),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.grey[800], fontSize: 15),
                        text: 'Already have account? ',
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickSignIn,
                            text: 'Sign In',
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                          ),
                        ]
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
}
