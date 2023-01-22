import 'package:flutter/material.dart';
import 'package:mental_health_app/pages/QuizPages/fetchTasks.dart';

import '../../main.dart';

class QuizEnd extends StatefulWidget {
  // const QuizEnd({Key? key}) : super(key: key);

  var Uid;
  QuizEnd({this.Uid});
  @override
  _QuizEndState createState() => _QuizEndState();
}

class _QuizEndState extends State<QuizEnd> {
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
          color: Colors.deepPurple,
          height: 600,
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.deepPurple,
                elevation: 0,
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
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: CircleAvatar(
                    radius: 100,
                    child: Icon(Icons.card_giftcard)
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 400, 0, 10),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                )
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 30, right: 20, left: 20),
                  child: SizedBox(
                    height: 200,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      color: Colors.deepPurple,
                      elevation: 10,
                      child: Column(
                        children: [
                          ListTile(
                            title: Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Text(
                                  'Nice talking to you!',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 3
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30,),
                          Padding(
                            padding: EdgeInsets.only(right: 60, left: 60),
                            child: Text(
                              textAlign: TextAlign.center,
                              'now boost your mood with some activities',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[300],
                                letterSpacing: 1,
                              ),
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
                      overlayColor: MaterialStateProperty.all(Colors.grey[300]),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.white)
                          )
                      ),
                    ),
                    onPressed: () {
                      print('>>>>>>>>>>> Method will call');
                      fetchTasks(120);
                      print('>>>>>>>>>>> Method called');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context)=> MyApp(pageIndex: 1, Uid: widget.Uid,)
                        ),
                      );
                    },
                    child: Padding(
                        padding: EdgeInsets.only(top: 10,bottom: 10,right: 20, left: 20),
                        child: Text(
                          'Let\'s start',
                          style: TextStyle(
                            color: Colors.deepPurple,
                              letterSpacing: 2,
                              fontSize: 17,
                              fontWeight: FontWeight.w500
                          ),
                        )
                    )
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
