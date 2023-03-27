
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/PageRouting.dart';
import 'package:mental_health_app/pages/DiaryPages/chooseImage.dart';
import 'package:mental_health_app/pages/DiaryPages/diary.dart';

import '../../main.dart';

class viewEntry extends StatefulWidget {
  // const viewEntry({Key? key}) : super(key: key);

  var id;
  var title;
  var content;
  var creationTime;
  var bg1;
  var bg2;
  var url;
  var mood;
  viewEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.creationTime,
    required this.bg1,
    required this.bg2,
    required this.url,
    required this.mood
});
  @override
  _viewEntryState createState() => _viewEntryState();
}

class _viewEntryState extends State<viewEntry> {
  // checking whether textfield is on focus to change height of appbar
  bool onFocus = false;
  late String initialText;
  bool _isEditingText = false;
  late TextEditingController textController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialText = widget.content;
    bool onFocus = false;
    textController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Widget _editTitleTextField() {
    if (_isEditingText)
      return Center(
        child: TextField(
          onSubmitted: (newValue){
            setState(() {
              initialText = newValue;
              _isEditingText =false;
            });
          },
          keyboardType: TextInputType.multiline,
          maxLines: 9,
          cursorColor: Colors.white,
          autofocus: true,
          controller: textController,
        ),
      );
    return InkWell(
      onTap: (){
        setState(() {
          _isEditingText = true;
        });
      },
      child: Text(
        initialText,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18
        ),
      ),
    );
  }

  Future<T?> pushPage<T>(BuildContext context, Widget page) {
    return Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(
            builder: (context) => new DiaryPage()),
            (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    bool isEntryAdded = false;

    print('---------- build height : ${onFocus}');
    // return WillPopScope(
    //   onWillPop: () async{
    //     return false;
    //   },
      return GestureDetector(
        onTap: (){
          // when clicked anywhere on screen textfield went off focus
          FocusScope.of(context).unfocus();
          new TextEditingController().clear();
        },
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            leading: Padding(
              padding: EdgeInsets.only(left: 10),
              child: GestureDetector(
                child: Icon(
                  Icons.arrow_back_ios,
                  // color: Colors.transparent,
                ),
                onTap: (){
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(
                          builder: (context) => new PageRouting(pageIndex: 3)),
                          (Route<dynamic> route) => false);
                },
              ),
            ),
            toolbarHeight: onFocus ? 50 : 300,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            flexibleSpace: GestureDetector(
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => new ChooseImage(
                      docId: widget.id,
                      url: widget.url,
                      isForUpdate: true,
                      title: widget.title,
                      content: textController.text,
                      mood: widget.mood,
                      bg1: Color(0xFF2F5CFF),
                      bg2: Color(0xFF2F5CFF),
                    ))
                );
              },
              child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(70)),
                      // image: DecorationImage(
                      //   image: NetworkImage(
                      //     widget.url,
                      //   ),
                      //   fit: BoxFit.cover,
                      //
                      // )
                    ),
                child: Image.network(
                  '${widget.url}',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress){
                    if(loadingProgress == null){
                      return child;
                    }else{
                      return Center(
                        child: Text(
                          'Loading....',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.grey[500],
                              letterSpacing: 2
                          ),
                        ),
                      );
                    }
                  },
                  // errorBuilder: (context, error, stackTrace){
                  //   Text('ERROR');
                  // },
                ),
                  ),
            ),
          ),
          body: SingleChildScrollView(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50,),
                  Wrap(
                    alignment: WrapAlignment.start,
                    direction: Axis.horizontal,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 35),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3,
                            color: Colors.grey[800],
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 38, left: 30),
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            'assets/images/${widget.mood}.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                      // color: Colors.blueGrey,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                              colors: [Colors.red, Colors.pink],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter
                          )
                      ),
                      width: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            Focus(
                              child: _editTitleTextField(),
                              onFocusChange: (hasFocus){
                                setState(() {
                                  onFocus = !onFocus;
                                });
                                print('---------- onFocus height : ${onFocus}');
                                print('---------- Contet after modification : ${textController.text}');
                              },
                            ),
                            SizedBox(height: 20,),
                            Align(
                              alignment: Alignment.bottomRight,
                                child: Text('${widget.creationTime.substring(0,12)}\n\t\t\t\t\t\t\t${widget.creationTime.substring(12)}')
                            ),
                          ],
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  SizedBox(
                    height: 50,
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                          )
                      ),
                      child: Text(
                        'save',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.grey[700],
                        ),
                      ),
                      onPressed: textController.text == widget.content ?
                      null :
                          () {
                            if(!isEntryAdded){
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              );
                            }
                        print('----------- button pressed');
                            var datetime = DateTime.now();
                            var creation_date = DateFormat("dd MMM,yyyy").format(DateTime.now())+' '+(datetime.hour).toString()+':'+(datetime.minute).toString();
                        FirebaseFirestore.instance.collection('DiaryEntries').doc(widget.id).update({
                          'content': textController.text,
                          'creationTime': creation_date,
                        }).then((value){
                          setState(() {
                            isEntryAdded = true;
                          });
                          Navigator.of(context).pushAndRemoveUntil(
                              new MaterialPageRoute(
                                  builder: (context) => new PageRouting(pageIndex: 3,isSuccess: true, successMsg: '   entry updated !',)),
                                  (Route<dynamic> route) => false);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    // );
  }
}

