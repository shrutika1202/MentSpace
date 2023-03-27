import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/pages/DiaryPages/chooseColor.dart';
import 'package:mental_health_app/pages/DiaryPages/viewEntry.dart';
import 'createDiaryEntry.dart';

class DiaryPage extends StatefulWidget {
  // const DiaryPage({Key? key}) : super(key: key);

  bool isSuccess;
  var successMsg;
  DiaryPage({
    this.isSuccess = false,
    this.successMsg
});
  @override
  _DiaryPageState createState() => _DiaryPageState();
}

var url;
Future<void> downloadURLExample(String creationTime) async {
  var downloadURL = await FirebaseStorage.instance
      .ref()
      .child("DiaryImages/${creationTime}.jpg")
      .getDownloadURL();
  url = downloadURL;
  print('>>>>>>>>> url : ${url}');
}

final user = FirebaseAuth.instance.currentUser;

class _DiaryPageState extends State<DiaryPage> {
  bool onFocus = false;
  var entryList = [];
  var selectedEntries;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bool onFocus = false;

    void func(){
      if(widget.isSuccess == true && widget.successMsg != null){
        Future.delayed(const Duration(seconds: 1), () {
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  backgroundColor: Colors.grey[300],
                  title: CircleAvatar(
                    radius: 40,
                    child: Image.asset('assets/images/tick.png'),
                  ),
                  content: Text(
                    '${widget.successMsg}',
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),),
                );
              });
        });
      }
    }

    func();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){
          widget.isSuccess = false;
        },
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.grey[300],
              toolbarHeight: 60,
              expandedHeight: 240.0,
              floating: false,
              snap: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'diary',
                  style: TextStyle(
                      letterSpacing: 3,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]
                  ),
                ),
                background: Opacity(
                  opacity: 1,
                  child: Image.asset(
                      'assets/images/diary.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('DiaryEntries')
                      .where('user', isEqualTo: user?.email)
                      .snapshots(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                    if(!snapshot.hasData){
                      return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 300),
                            child: CircularProgressIndicator(),
                          )
                      );
                    }

                    try{
                      entryList = (snapshot.data as QuerySnapshot).docs.isEmpty ? [] : ((snapshot.data as QuerySnapshot).docs);
                    }catch(e){
                      entryList = [];
                    }

                    return entryList.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.only(top: 300),
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              'No entries available',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[800]
                              ),
                            ),
                            Text(
                              ' Start journaling now !!',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey
                              ),
                            ),
                            SizedBox(height: 10,),
                          ],
                        ),
                      ),
                    )
                        : ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((document){
                        return GestureDetector(
                          child: Container(
                            height: 130,
                            width: 100,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 8,
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [Colors.deepPurpleAccent, Colors.deepPurple],
                                      stops: [0.1, 1]
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  // leading: Padding(
                                  //   padding: const EdgeInsets.only(top: 30),
                                  //   child: Checkbox(
                                  //
                                  //   ),
                                  // ),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${document['title']}'[0].toUpperCase()+'${document['title']}'.substring(1).toLowerCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 2,),
                                      // Text(
                                      // document['creationTime'].split(' ')[0] + ' ' + document['creationTime'].split(' ')[1],
                                      //   style: TextStyle(
                                      //     color: Colors.grey[400],
                                      //   ),
                                      // ),
                                      SizedBox(
                                        height: 30,
                                        width: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5)
                                              )
                                          ),
                                          child: Icon(
                                            Icons.delete,
                                            size: 19,
                                            color: Colors.grey[700],
                                          ),
                                          onPressed: (){
                                            showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return AlertDialog(
                                                    backgroundColor: Colors.grey[300],
                                                    title: Text('Are you sure ?'),
                                                    actions: [
                                                      TextButton(
                                                        child: Text('yes'),
                                                        onPressed: (){
                                                          FirebaseFirestore.instance.collection('DiaryEntries').doc(document.id).delete();
                                                          Navigator.of(context).pop();
                                                          showDialog(
                                                              context: context,
                                                              builder: (ctx) {
                                                                return AlertDialog(
                                                                  backgroundColor: Colors.grey[300],
                                                                  title: CircleAvatar(
                                                                    radius: 40,
                                                                    child: Image.asset('assets/images/tick.png'),
                                                                  ),
                                                                  content: Text(
                                                                    '    entry deleted !',
                                                                    style: TextStyle(
                                                                      letterSpacing: 1,
                                                                      fontSize: 25,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Colors.deepPurple,
                                                                    ),),
                                                                );
                                                              });
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text('no'),
                                                        onPressed: (){
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 40,)
                                    ],
                                  ),
                                  subtitle: Text(
                                    document['content'],
                                    style: TextStyle(
                                        color: Colors.grey[300]
                                    ),
                                    maxLines: 2,
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          onTap: ()async {
                            await downloadURLExample(document['creationTime']);
                            //  on selecting an entry
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => new viewEntry(
                                    mood: document['mood'],
                                    id: document.id,
                                    title: document['title'],
                                    content: document['content'],
                                    creationTime: document['creationTime'],
                                    bg1: document['bg1'],
                                    bg2: document['bg2'],
                                    url: url
                                ))
                            );
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new ChooseColor())
          );
        },
        backgroundColor: Colors.deepPurpleAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
