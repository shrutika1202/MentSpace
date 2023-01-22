import 'package:flutter/material.dart';
import 'package:mental_health_app/pages/QuizPages/quiz.dart';

import '../../main.dart';

class QuizStart extends StatefulWidget {
  // const QuizStart({Key? key}) : super(key: key);

  String mood ='ok';
  var Uid;
  QuizStart({
    required this.mood,
    this.Uid
  });

  @override
  _QuizStartState createState() => _QuizStartState();
}

class _QuizStartState extends State<QuizStart> {

  final response = [
    {'great': 'So glad to hear you\'r feeling great!'},
    {'good': 'Nice to hear you\'r feeling good'},
    {'ok': 'Glad things are okay.'},
    {'bad': 'Sorry to hear you\'r feeling bad.'},
    {'awful': 'Sorry to hear you\'r feeling awful'}
  ];
  String respText = '';

  @override
  void initState() {
    super.initState();
    response.forEach((element) {
      element.forEach((key, value){
        if(key == widget.mood){
          respText = value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
          child: Container(
            width: 500,
            color: Colors.grey[300],
          ),
        ),
        Container(
          height: 550,
          child: AppBar(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
            ),
            title: Padding(
              padding: EdgeInsets.only(left: 90),
                child: Text(
                    'Check In',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.grey[200]
                  ),
                )
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(30, 150, 30, 10),
          child: Container(
            // color: Colors.grey,
            width: 600,
            child: Column(
              children: <Widget>[
                Container(
                  child: SizedBox(
                    height: 400,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      color: Colors.deepPurple,
                      elevation: 0,
                      child: Column(
                        children: [
                          ListTile(
                            title: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                '${respText}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 3
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30,),
                          Image.asset(
                            'assets/images/jimin.jpg',
                            height: 200,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 30,),
                          Text(
                            textAlign: TextAlign.center,
                            'would you like to disscuss more about you\'r day today ?',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[300],
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(15),
                      overlayColor: MaterialStateProperty.all(Colors.purple[800]),
                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.white)
                          )
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context)=> QuizPage(Uid: widget.Uid,)
                        ),
                      );
                    },
                    child: Padding(
                        padding: EdgeInsets.only(top: 10,bottom: 10,right: 20, left: 20),
                        child: Text(
                          'Let\'s start',
                          style: TextStyle(
                              letterSpacing: 2,
                              fontSize: 17,
                              fontWeight: FontWeight.w500
                          ),
                        )
                    )
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(15),
                      overlayColor: MaterialStateProperty.all(Colors.purple[800]),
                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.white)
                          )
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context)=> MyApp(pageIndex: 0, Uid: widget.Uid,)
                        ),
                      );
                    },
                    child: Padding(
                        padding: EdgeInsets.only(top: 10,bottom: 10,right: 20, left: 20),
                        child: Text(
                          'No, thanks!',
                          style: TextStyle(
                              letterSpacing: 2,
                              fontSize: 17,
                              fontWeight: FontWeight.w500
                          ),
                        )
                    )
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
























