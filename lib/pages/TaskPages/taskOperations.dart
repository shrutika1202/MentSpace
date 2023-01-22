
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;

Future<void> updateTask(Uid,int index,bool exp, field) async{
  var taskList;
  print('------------ field : ${field}');
  print('----------- value : ${exp}');

  await db.collection('anonymous_users')
      .where('uid', isEqualTo: Uid)
      .get()
      .then((value){
    value.docs.forEach((element){
      print('--------- element value : ${element['tasks'][0]['isFav']}');
      taskList = element['tasks'];
      taskList[index]['${field}'] = exp;
      print('----------- taskList : ${taskList}');
      db.collection('anonymous_users').doc(Uid).update({
        'tasks': taskList,
      });
    });
  });
}

Future<bool> deleteTask(Uid,int index) async{
  var taskList;
  var isDeleted = false;

  print('inside delete task');
  await db.collection('anonymous_users')
      .where('uid', isEqualTo: Uid)
      .get()
      .then((value){
    value.docs.forEach((element){
      print('--------- element value : ${element['tasks'][0]['isFav']}');
      taskList = element['tasks'];

      if(taskList[index]['isCompleted']){
        // taskList[index]['isCompleted'];
        taskList.removeAt(index);
        print('----------- taskList from deleteTask : ${taskList}');
        db.collection('anonymous_users').doc(Uid).update({
          'tasks': taskList,
        });
        isDeleted = true;
      }

      if(!isDeleted){

      }
    });
  });
  print('--------- isDeleted : ${isDeleted}');
  return isDeleted;
}

