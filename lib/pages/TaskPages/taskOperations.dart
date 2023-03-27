
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ExtraFiles/AccountOperations.dart';

final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;

Future<void> updateTask(String task_name, int index, bool exp, field) async{
  var taskList;
  print('------------ field : ${field}');
  print('----------- value : ${exp}');

  await db.collection('users')
      .where("${user?.isAnonymous == true ? 'anon_uid' : 'email'}", isEqualTo: user?.isAnonymous == true ? user?.uid : user?.email)
      .get()
      .then((value){
    value.docs.forEach((element){
      print('--------- element value : ${element['tasks'][0]['isFav']}');
      taskList = element['tasks'];
      taskList[index]['${field}'] = exp;
      print('----------- taskList : ${taskList}');
      db.collection('users').doc(element.id).update({
        'tasks': taskList,
      });
    });
  });

  if(field == 'isFav'){
    // add song ID in favTasks field of user collection
    db.collection('users').get().then((value){
      value.docs.forEach((element) {
        try{
          if(element['email'] == user?.email){
            var favList = element['favTasks'];
            print('fav task list : ${favList}');
            print(favList.indexOf(task_name));

            // when liked
            if(exp == true){
              print('favList from operation user : ${favList.length}');
              if(favList.indexOf(task_name) == -1){
                favList.add(task_name);
              }
            }else{
              //when unliked
              // id -> task name
              favList.removeWhere((item) => item == task_name);
            }

            var key = 'favTasks';
            var val = favList;
            db.collection('users').doc(element.id).update({
              key: val,
            });
          }
        }catch(e){}
      });
    });
  }

  if(field == 'isCompleted' && user?.isAnonymous == false){
    //update task status on profile
    if(exp == true){
      updateStatus('tasks', 1);
    }
    if(exp == false){
      updateStatus('tasks', -1);
    }
  }

}

Future<bool> deleteTask(Uid,int index) async{
  var taskList;
  var isDeleted = false;

  print('inside delete task');
  await db.collection('users')
      .where("${user?.isAnonymous == true ? 'anon_uid' : 'email'}", isEqualTo: user?.isAnonymous == true ? user?.uid : user?.email)
      .get()
      .then((value){
    value.docs.forEach((element){
      print('--------- element value : ${element['tasks'][0]['isFav']}');
      taskList = element['tasks'];

      if(taskList[index]['isCompleted']){
        // taskList[index]['isCompleted'];
        taskList.removeAt(index);
        db.collection('users').doc(element.id).update({
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

