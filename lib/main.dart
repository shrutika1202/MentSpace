
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mental_health_app/pages/Authentication/AuthPage.dart';
import 'package:mental_health_app/pages/Authentication/verifyEmail.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'getStarted.dart';
import 'pages/Authentication/googleSignIn.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final isLogin = true;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          // scaffoldMessengerKey: Utils.messengerKey,
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          home: GetStarted(),
        ),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              } else if(snapshot.hasError){
                return Center(child: Text('something went wrong'),);
              } else if(snapshot.hasData){
                return VerifyEmailPage();
              } else{
                return AuthPage();
              }
            }
        )
    );
  }
}

