import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/main.dart';
import 'package:mental_health_app/pages/QuizPages/quizEnd.dart';

class QuizPage extends StatefulWidget {
  // const QuizPage({Key? key}) : super(key: key);

  var Uid;
  var mood;
  QuizPage({
    this.Uid,
    required this.mood
  });
  @override
  _QuizPageState createState() => _QuizPageState();
}

// quiz questions based on mood
final moodBasedQuestions = const {
  'great': [
    {
      'questionText': 'How often have you had enjoyed small things of your daily life ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had spend enough time for yourself ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had thought about good things happened to you so far ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had found yourself helping others ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
  ],
  'good': [
    {
      'questionText': 'How often have you had experienced overthinking about future situations ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had experienced distraction from focusing on what you currently need to do ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had experienced it hard to release the tension ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had end up having negative thoughts and feeling worried ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had practiced positive affirmations ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
  ],
  'ok': [
    {
      'questionText': 'How often have you had lost trust in yourself or in those around you ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had felt overwhelming and trapped all alone in darkness ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had experienced dwelling on negative thoughts ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had experienced lost of control ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
  ],
  'bad': [
    {
      'questionText': 'How often have you had experienced hard to manage your anger ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had responded certain situations in irrational or unhelpful manner ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had reacted impulsively ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had experienced your mind filled with negative and harsh thoughts ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had tried reflecting on situations making you lose tamper ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had felt everything cluttered around you ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
  ],
  'tired': [
    {
      'questionText': 'How often have you had constantly felt low on energy ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had experienced tension strted building up in your muscles ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had played your favourite playlist ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had experienced life getting monotonous and end up in a rut ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had felt tired and lethargic  ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
    {
      'questionText': 'How often have you had spend significant time indoors ?',
      'answers' : [
        {'text': 'Not at all', 'selected': false},
        {'text': 'Several days', 'selected': false},
        {'text': 'More than half the days', 'selected': false},
        {'text': 'Nearly every day', 'selected': false}
      ],
    },
  ]
};

class _QuizPageState extends State<QuizPage> {
  // assign quiz questions for current mood
  late final questions = moodBasedQuestions[widget.mood];
  // final questions = const [
  //   {
  //     'questionText': 'How are you feelin ?',
  //     'answers' : [
  //       {'text': 'Good', 'score': 10, 'selected': false},
  //       {'text': 'better', 'score': 15, 'selected': false},
  //       {'text': 'best', 'score': 20, 'selected': false},
  //       {'text': 'awful', 'score': 5, 'selected': false}
  //     ],
  //   },
  //   {
  //     'questionText': 'how many people did you meet ?',
  //     'answers' : [
  //       {'text': 'a lot', 'score': 10, 'selected': false},
  //       {'text': 'few', 'score': 15, 'selected': false},
  //       {'text': 'family', 'score': 20, 'selected': false},
  //       {'text': 'friend', 'score': 5, 'selected': false}
  //     ],
  //   },
  //   {
  //     'questionText': 'was you able to complete todays tasks ?',
  //     'answers' : [
  //       {'text': 'yepp !!', 'score': 10, 'selected': false},
  //       {'text': 'half done', 'score': 15, 'selected': false},
  //       {'text': 'only few', 'score': 20, 'selected': false},
  //       {'text': 'i wasted time', 'score': 5, 'selected': false}
  //     ],
  //   },
  //   {
  //     'questionText': 'loosing hope ?',
  //     'answers' : [
  //       {'text': 'nope', 'score': 10, 'selected': false},
  //       {'text': 'trying really hard', 'score': 15, 'selected': false},
  //       {'text': 'yes little', 'score': 20, 'selected': false},
  //       {'text': 'already lost it', 'score': 5, 'selected': false}
  //     ],
  //   },
  // ];

  List _isSelected=[6];
  int _questionIndex = 0;
  bool _selected = false;
  List<String> text = [];
  dynamic _ans;
  int queIndex=0;

  void _answerQuestion(){
    setState(() {
      _ans = questions?[_questionIndex]['answers'];
      _ans.forEach((s){
        text.add(s['text']);
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
                    print('question curr index : ${_questionIndex}\n quetion length : ${questions?.length}');
                    if(_questionIndex + 1 == questions?.length){
                      print('reached limit');
                      Navigator.of(context).pushAndRemoveUntil(
                          new MaterialPageRoute(
                              builder: (context) => new QuizEnd(Uid: widget.Uid,)),
                              (Route<dynamic> route) => false);
                    } else{
                        setState(() {
                          _questionIndex += _questionIndex == questions?.length ? 0 : 1;
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
                            '${questions?[_questionIndex]['questionText'].toString()}',
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
