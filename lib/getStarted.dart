import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mental_health_app/PageRouting.dart';
import 'package:mental_health_app/pages/Authentication/Anon_user.dart';
import 'package:mental_health_app/pages/ExtraFiles/AccountOperations.dart';

import 'main.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  _GetStartedState createState() => _GetStartedState();
}

var pageContent = {
  0: 'mood tracker helps you to analyse your mood swings',
  1: 'find activities to boost your energy',
  2: 'get recommendations on songs based on your mood',
  3: 'keep track of your emotions and improve daily'
};
var images = ['mood','task','songs','diary'];

class _GetStartedState extends State<GetStarted> {
  final controller = PageController(initialPage: 0);

  List<PageViewModel> getPages(){
    return [
      PageViewModel(
        image: Image.asset('assets/introImages/page1.png'),
        title: 'mood tracker',
        body: pageContent[0]
      ),
      PageViewModel(
          image: Image.asset('assets/introImages/page2.png'),
          title: 'fun activities',
          body: pageContent[1]
      ),
      PageViewModel(
          image: Image.asset('assets/introImages/page3.png'),
          title: 'music recommendation',
          body: pageContent[2]
      ),
      PageViewModel(
          image: Image.asset('assets/introImages/page4.png'),
          title: 'journaling',
          body: pageContent[3]
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // SizedBox(height: 100,),
            // Container(
            //   height: 760,
            //   width: 500,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20)
            //   ),
            //   child: PageView(
            //     controller: controller,
            //     children: [
            //       sliderPage(0),
            //       sliderPage(1),
            //       sliderPage(2),
            //       sliderPage(3)
            //     ],
            //   ),
            // ),
            SizedBox(height: 200,),
            SizedBox(
              height: 400,
              width: 500,
              child: IntroductionScreen(
                done: Text(''),
                next: Text(''),
                onDone: (){},
                pages: getPages(),
                globalBackgroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
                height: 80,
                width: 400,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurpleAccent,
                    shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 95),
                    child: Row(
                      children: [
                        Text(
                          'Get Started',
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.white
                          ),
                        ),
                        SizedBox(width: 15,),
                        Icon(Icons.arrow_forward, size: 25, color: Colors.white,),
                      ],
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder:(context) => MyApp()
                    ));
                  },
                ),
              ),
            ),
            SizedBox(height: 10,),
            // ElevatedButton(
            //     onPressed: ()async{
            //       await AuthService().getOrCreateUser();
            //       createAccount();
            //
            //       Navigator.of(context).pushAndRemoveUntil(
            //           new MaterialPageRoute(
            //               builder: (context) => new PageRouting(pageIndex: 0)),
            //               (Route<dynamic> route) => false);
            //     },
            //     child: Text('proceed without login')
            // )
            // GestureDetector(
            //   onTap: ()async{
            //     await AuthService().getOrCreateUser();
            //     createAccount();
            //
            //     Navigator.of(context).pushAndRemoveUntil(
            //         new MaterialPageRoute(
            //             builder: (context) => new PageRouting(pageIndex: 0)),
            //             (Route<dynamic> route) => false);
            //   },
            //   child: Text(
            //     'proceed without Login',
            //     style: TextStyle(
            //       fontSize: 20,
            //       fontWeight: FontWeight.w500
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

Widget sliderPage(int page) {
  return Container(
    height: 200,
    width: 400,
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/introImages/${images[page]}.png'),
            fit: BoxFit.cover
        )
    ),
    // color: Colors.grey,
    child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 50),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 2),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [Colors.white60, Colors.white30]
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(width: 2, color: Colors.white30)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 60, top: 200),
                  child: Text(
                    '${pageContent[page]}',
                    style: TextStyle(
                        letterSpacing: 5,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800]
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 150),
                  child: Row(
                    children: [
                      Icon(
                        page == 0 ? Icons.circle_rounded : Icons.circle_outlined,
                        size: 10,
                        color: Colors.grey[400],
                      ),
                      Icon(page == 1 ? Icons.circle_rounded : Icons.circle_outlined, size: 10, color: Colors.grey[400]),
                      Icon(page == 2 ? Icons.circle_rounded : Icons.circle_outlined, size: 10, color: Colors.grey[400]),
                      Icon(page == 3 ? Icons.circle_rounded : Icons.circle_outlined, size: 10, color: Colors.grey[400]),
                    ],
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
