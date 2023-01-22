

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

final dbTasks = FirebaseFirestore.instance.collection('Tasks');
final dbTaskList = FirebaseFirestore.instance.collection('taskList');

void fetchTasks(int TotalScore){
  print('>>>>>>>>>>> inside method');
  StreamBuilder(
    stream: dbTasks.snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
      if(snapshot.hasData){
        snapshot.data?.docs.map((task){
          print('>>>>>>>>>>> title : ${task['title']}');
          dbTaskList.add({
            'title': task['title'],
            'desp': task['desp'],
            'rem': task['rem'],
            'isFav': task['isFav'],
            'isCompleted': false,
          });
        });
      }
      else{
        print('>>>>>>>>>>> Method failed');
      }
      return Container();
    },
  );
}

