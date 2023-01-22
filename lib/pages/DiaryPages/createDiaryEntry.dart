import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';


class createEntry extends StatefulWidget {
  const createEntry({Key? key}) : super(key: key);

  @override
  _createEntryState createState() => _createEntryState();
}

class _createEntryState extends State<createEntry> {
  TextEditingController textarea = TextEditingController();
  String title='';
  String creation_date='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('New entry'),
        elevation: 4,
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // print(textarea.text);
                      var datetime = DateTime.now();
                      creation_date = DateFormat("dd MMM,yyyy").format(DateTime.now())+' '+(datetime.hour).toString()+':'+(datetime.minute).toString();
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              title: Text('Title'),
                              content: TextField(
                                onChanged: (String value){
                                  title = value;
                                },
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  color: Colors.redAccent,
                                  onPressed: () {
                                    FirebaseFirestore.instance.collection('DiaryEnteries').add({
                                      'title': title,
                                      'content': textarea.text,
                                      'creationTime': creation_date,
                                      'bgColor': '0xFFBCBAB5',
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('done'),
                                )
                              ],
                            );
                          }
                      );

                    },
                    child: Text('save'),
                  ),
                ),
                // Spacer(),
                TextField(
                  controller: textarea,
                  keyboardType: TextInputType.multiline,
                  maxLines: 20,

                  decoration: InputDecoration(
                      hintText: "let your experience have words.....",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.redAccent)
                      )
                  ),
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}
