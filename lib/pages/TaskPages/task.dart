import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health_app/pages/TaskPages/taskDesp.dart';
import 'package:mental_health_app/pages/TaskPages/taskOperations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../DiaryPages/chooseColor.dart';
import '../HomePage/home.dart';

final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;

class TaskPage extends StatefulWidget {
  // const TaskPage({Key? key}) : super(key: key);

  final int Totalscore=0;
  var Uid;
  TaskPage({
    this.Uid
  });

  @override
  _TaskPageState createState() => _TaskPageState();
}

var urlList = {};

class _TaskPageState extends State<TaskPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> downloadURLExample(img) async {
    var downloadURL = await FirebaseStorage.instance
        .ref()
        .child("TasksImages/${img}.png")
        .getDownloadURL();
    urlList['${img}'] = downloadURL;
  }

  //variables
  bool _value = false;
  bool _setRem = false;
  List _completed = [2];
  bool isDeleted = false;
  var taskList = [];
  var favList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white60,
      body: FutureBuilder(
        future: db.collection('users')
            .where("${user?.isAnonymous == true ? 'anon_uid' : 'email'}", isEqualTo: user?.isAnonymous == true ? user?.uid : user?.email)
            .get(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          try{
            taskList = (snapshot.data as QuerySnapshot).docs.isEmpty ? [] : ((snapshot.data as QuerySnapshot).docs)[0]["tasks"];
          }catch(e){
            taskList = [];
          }

          try{
            favList = (snapshot.data as QuerySnapshot).docs.isEmpty ? [] : ((snapshot.data as QuerySnapshot).docs)[0]["favTasks"];
          }catch(e){
            favList = [];
          }

          print('----------- taskslist from taskhome : ${taskList}');

          return Column(
            children: <Widget>[
              SizedBox(height: 80,),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'Tasks',
                    style: TextStyle(
                        letterSpacing: 3,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'Choose task to level up your mood',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4,),
              taskList.isEmpty
              ? Padding(
                padding: const EdgeInsets.only(top: 300),
                child: Container(
                  child: Column(
                    children: [
                      Text(
                          'No tasks available',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[800]
                        ),
                      ),
                      Text(
                        ' Check-in to get tasks recommended',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey
                        ),
                      ),
                      SizedBox(height: 10,),
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurpleAccent,
                              shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)
                              )
                          ),
                          child: Text(
                            'Check-in',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: (){
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => new HomePage())
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : ListView.builder(
                shrinkWrap: true,
                itemCount: taskList.length,
                itemBuilder: (context, index){
                  var document = taskList[index];
                  downloadURLExample(document['title']);

                  return Card(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    key: ValueKey(document),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.grey[300],
                    elevation: 2,
                    child: GestureDetector(
                      onTap: (){
                        print('liked or not ? ${favList.indexOf(document['Movement'])}');
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => new TaskDespPage(
                              Uid: widget.Uid,
                              index: index,
                              title: document['title'],
                              desp: document['desp'],
                              isCompleted: document['isCompleted'],
                              rem: document['rem'],
                              isFav: favList.indexOf(document['title']) == -1 ? false : true,
                              ref: document['ref'],
                              url: urlList[document['title']],
                            ))
                        );
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(color: false ? Colors.green : Colors.orange, width: 5)
                            )
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            shape: CircleBorder(),
                            splashRadius: 50,
                            value: document['isCompleted'],
                            onChanged: (value) async{
                              // setState(() {
                              _completed[0] = index;
                              _value = value!;
                              if(index == _completed[0]){
                                await updateTask(document['title'], index, _value, 'isCompleted');
                                setState(() {});
                                if(_value && user?.isAnonymous == false){
                                  showDialog(
                                    context: _scaffoldKey.currentContext!,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      title: Column(
                                        children: [
                                          Center(
                                              child: Text(
                                                'Journaling your new experience is best way to keep it going. \ngive it a try... ',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.grey[800]
                                                ),
                                              )
                                          ),
                                          SizedBox(height: 20,),
                                          // Image.asset('assets/images/great.png'),
                                          // SizedBox(height: 10,),
                                          Center(
                                            child: SizedBox(
                                              height: 40,
                                              width: 100,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.deepPurpleAccent,
                                                    shape: new RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(30)
                                                    )
                                                ),
                                                child: Text(
                                                  'Sure!',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                  Navigator.push(context, new MaterialPageRoute(
                                                      builder: (context) => new ChooseColor(
                                                        // Uid: widget.Uid,
                                                        title: document['title'],
                                                        content: 'Describe your experience here',
                                                        url: urlList[document['title']],
                                                      ))
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 7,),
                                          Center(
                                            child: SizedBox(
                                              height: 40,
                                              width: 100,
                                              child: TextButton(
                                                child: Text(
                                                  'Later',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.deepPurpleAccent,
                                                  ),
                                                ),
                                                onPressed: (){
                                                  Fluttertoast.showToast(
                                                      msg: "Task is marked as completed",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.black26,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // actions: [
                                      //
                                      // ],
                                    ),
                                  );
                                }
                              }
                              // });
                            },
                          ),
                          title: Transform.translate(
                            offset: Offset(-14, 0),
                            child: Text(
                              document['title'],
                              style: TextStyle(
                                  decoration: document['isCompleted'] ? TextDecoration.lineThrough : null,
                                  color: document['isCompleted'] ? Colors.grey : null
                              ),
                            ),
                          ),
                          subtitle: !document['isCompleted'] ? Transform.translate(
                            offset: Offset(-14, 0),
                            child: Text(
                              document['desp'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ) : null,
                          trailing: GestureDetector(
                            child: Icon(
                              Icons.delete,
                              color: Colors.grey,
                            ),
                            onTap: (){
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  title: Text('Are you sure ?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                            color: Colors.grey
                                        ),
                                      ),
                                      onPressed: () async{
                                        isDeleted = await deleteTask(widget.Uid, index);
                                        setState((){
                                          print('----------- after deleteion');
                                          // db.collection('taskList').doc(document.id).delete();
                                          _setRem = !_setRem;
                                          Navigator.of(context).pop();
                                        });
                                        print('--------- isDeleted : ${isDeleted}');
                                        if(!isDeleted){
                                          Fluttertoast.showToast(
                                              msg: "Complete the task first",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black26,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        }
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                            color: Colors.grey
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Fluttertoast.showToast(
                                            msg: "task deleted successfully",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black26,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}























