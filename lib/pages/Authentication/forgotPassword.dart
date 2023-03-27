import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'AuthPage.dart';

class ForegotPasswordPage extends StatefulWidget {
  // const ForegotPasswordPage({Key? key}) : super(key: key);

  bool isFromSettings;
  ForegotPasswordPage({
    this.isFromSettings = false,
  });

  @override
  _ForegotPasswordPageState createState() => _ForegotPasswordPageState();
}

class _ForegotPasswordPageState extends State<ForegotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                SizedBox(height: 50,),
                Text(
                  'Forgot your password?',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  '     Enter your registered email below \nto receive password reset instructions',
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
                          image: AssetImage('assets/introImages/forgotPassword.png'),
                          fit: BoxFit.fitHeight
                      )
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: emailController,
                  cursorColor: Colors.grey[700],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
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
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Row(
                    children: [
                      Text(
                        'Remember password? ',
                        style: TextStyle(color: Colors.grey[800], fontSize: 13),
                      ),
                      GestureDetector(
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.blue, fontSize: 13),
                        ),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AuthPage(),
                        )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 35,),
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
                      'Reset Password',
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                      ),
                    ),
                    onPressed: resetPassword,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future resetPassword()  async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>  Center(child: CircularProgressIndicator(),)
    );

    try{
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      // Utils.showSnackBar('Password Reset Email Sent');

      // change routing here
      if(widget.isFromSettings){
        Navigator.of(context).pop();
      }else{
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on FirebaseAuthException catch(e) {
      print(e);

      // Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
