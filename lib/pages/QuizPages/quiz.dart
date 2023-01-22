import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/main.dart';
import 'package:mental_health_app/pages/QuizPages/quizEnd.dart';

class QuizPage extends StatefulWidget {
  // const QuizPage({Key? key}) : super(key: key);

  var Uid;
  QuizPage({
    this.Uid
  });
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final questions = const [
    {
      'questionText': 'How are you feelin ?',
      'answers' : [
        {'text': 'Good', 'score': 10, 'selected': false},
        {'text': 'better', 'score': 15, 'selected': false},
        {'text': 'best', 'score': 20, 'selected': false},
        {'text': 'awful', 'score': 5, 'selected': false}
      ],
    },
    {
      'questionText': 'how many people did you meet ?',
      'answers' : [
        {'text': 'a lot', 'score': 10, 'selected': false},
        {'text': 'few', 'score': 15, 'selected': false},
        {'text': 'family', 'score': 20, 'selected': false},
        {'text': 'friend', 'score': 5, 'selected': false}
      ],
    },
    {
      'questionText': 'was you able to complete todays tasks ?',
      'answers' : [
        {'text': 'yepp !!', 'score': 10, 'selected': false},
        {'text': 'half done', 'score': 15, 'selected': false},
        {'text': 'only few', 'score': 20, 'selected': false},
        {'text': 'i wasted time', 'score': 5, 'selected': false}
      ],
    },
    {
      'questionText': 'loosing hope ?',
      'answers' : [
        {'text': 'nope', 'score': 10, 'selected': false},
        {'text': 'trying really hard', 'score': 15, 'selected': false},
        {'text': 'yes little', 'score': 20, 'selected': false},
        {'text': 'already lost it', 'score': 5, 'selected': false}
      ],
    },
  ];

  List _isSelected=[6];
  int _questionIndex = 0;
  var _totalScore = 0;
  bool _selected = false;
  List<String> text = [];
  List<int> score = [];
  dynamic _ans;
  int queIndex=0;

  void _answerQuestion(){
    setState(() {
      _ans = questions[_questionIndex]['answers'];
      _ans.forEach((s){
        text.add(s['text']);
        score.add(s['score']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _answerQuestion();
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
          height: 300,
          child: AppBar(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 30, top: 20),
                child: TextButton(
                  onPressed: () {
                    if(_questionIndex == 3){
                      print('reached limit');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context)=> QuizEnd(Uid: widget.Uid,)
                        ),
                      );
                    } else{
                        setState(() {
                          _totalScore += score[queIndex];
                          _questionIndex += _questionIndex==4 ? 0 : 1;
                          _answerQuestion();
                        });
                        _isSelected[0]=6;
                    }
                  },
                  child: Text(
                      'SKIP',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(30, 200, 30, 10),
          child: Container(
            width: 600,
            // color: Colors.grey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: SizedBox(
                    height: 150,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.white,
                      elevation: 8,
                      child: ListTile(
                        title: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${questions[_questionIndex]['questionText'].toString()}',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40,),
                Expanded(
                  child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index){
                      return GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(),
                              ),
                              color: _isSelected[0]==index ? Colors.lightGreenAccent : Colors.white,
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.blueGrey, width: 3),
                                  ),
                                ),
                                child: ListTile(
                                  title: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '${_ans[index]['text']}',
                                    ),
                                  ),
                                ),
                              )
                          ),
                        ),
                        onTap: () {
                          queIndex=index;
                          setState((){
                            _isSelected[0]=index;
                          });
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.only(bottom: 80,right: 20),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(15),
                          overlayColor: MaterialStateProperty.all(Colors.purple[800]),
                          backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(color: Colors.white)
                              )
                          ),
                        ),
                        onPressed: () {
                          if(_questionIndex == 3){
                            print('reached limit');
                            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                            //   return MyApp(pageIndex: 1);
                            // }), (r){
                            //   return false;
                            // });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context)=> QuizEnd(Uid: widget.Uid,)
                              ),
                            );
                          } else{
                            if(_isSelected[0]!=6){
                              setState(() {
                                _totalScore += score[queIndex];
                                _questionIndex += _questionIndex==4 ? 0 : 1;
                                _answerQuestion();
                              });
                              _isSelected[0]=6;
                            } else{
                              final snackBar = SnackBar(
                                content: const Text('Hi, I am a SnackBar!'),
                                backgroundColor: (Colors.black),
                                action: SnackBarAction(
                                  label: 'dismiss',
                                  onPressed: () {
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 20, left: 20),
                            child: Text(
                              'next',
                              style: TextStyle(
                                letterSpacing: 2,
                                fontSize: 17,
                                fontWeight: FontWeight.w400
                              ),
                            )
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
