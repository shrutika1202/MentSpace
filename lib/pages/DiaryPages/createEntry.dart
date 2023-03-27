import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/pages/DiaryPages/chooseImage.dart';

class CreateEntry extends StatefulWidget {
  // const CreateEntry({Key? key}) : super(key: key);

  Color bg1;
  Color bg2;
  var title;
  var content;
  var url;
  CreateEntry({
    required this.bg1,
    required this.bg2,
    this.title,
    this.content,
    this.url
  });

  @override
  _CreateEntryState createState() => _CreateEntryState();
}

class _CreateEntryState extends State<CreateEntry> {
  TextEditingController textarea = TextEditingController();
  TextEditingController textTitle = TextEditingController();
  List<String> mood = ['great','good','ok','bad','tired'];
  String selectedMood = '';
  final emojiSelected = [100];

  @override
  Widget build(BuildContext context) {
    print('------- color : ${widget.bg1}');
    print('------- color : ${widget.bg2}');
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.grey[300],
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30, top: 20),
                child: Text(
                  'How are you feeling?',
                  style: TextStyle(
                    letterSpacing: 3,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 30),
                child: Row(
                  children: [
                    for(int i=0; i<mood.length; i++)
                      Padding(
                        padding: EdgeInsets.only(left: 4, top: 20,),
                        child: GestureDetector(
                          child: Card(
                            color: emojiSelected[0] == i ? Color(widget.bg1.value) : Color(widget.bg2.value),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                                  child: CircleAvatar(
                                    radius: 20,
                                    foregroundImage: AssetImage('assets/images/${mood[i]}.png'),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10, bottom: 20),
                                    child: Text(
                                      '${mood[i]}',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              emojiSelected[0] = i;
                              selectedMood = mood[i];
                              print(';;;;;;;;;;;;;;;;;; bg1 : ${widget.bg1.value.runtimeType}');
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30, top: 20),
                child: Text(
                  widget.content == null ? 'Describe your state of mind' : 'How this activity affected you?',
                  style: TextStyle(
                    // letterSpacing: 3,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.only(left: 30, top: 20, right: 30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [widget.bg1, widget.bg2],
                    stops: [0.6, 1]
                  ),
                ),
                child: TextField(
                  controller: textTitle,
                  style: TextStyle(color: Colors.black45),
                  decoration: InputDecoration(
                    hintText: widget.title == null ? 'title' : widget.title,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 3, color: Colors.white)
                    )
                  ),
                  onChanged: (value){
                    setState(() {});
                  },
                ),
              ),
            ),
            // SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.only(left: 30, top: 20, right: 30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [widget.bg1, widget.bg2],
                      stops: [0.5, 1]
                  ),
                ),
                child: TextField(
                  style: TextStyle(color: Colors.black45),
                  controller: textarea,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  decoration: InputDecoration(
                      hintText: widget.content == null ? "comment" : widget.content,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 3, color: Colors.white)
                      )
                  ),
                  onChanged: (value){
                    setState(() {});
                  },
                ),
              ),
            ),
            SizedBox(height: 70,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF8A64EB),
                minimumSize: Size(350, 80),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
              child: Text(
                'continue',
                style: TextStyle(
                  letterSpacing: 3,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: (emojiSelected[0] == 100 || textTitle.text.length < 2 || textarea.text.length < 2)
                  ? null
                  : (){
                print('------- title from create entry : ${textTitle.text.length == 0 ? widget.title : textTitle.text}');
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => new ChooseImage(
                      title: textTitle.text.length == 0 ? widget.title : textTitle.text,
                      content: textarea.text,
                      mood: selectedMood,
                      bg1: widget.bg1,
                      bg2: widget.bg2,
                      url: widget.url != null ? widget.url : null,
                    ))
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
