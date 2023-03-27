import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Authentication/Anon_user.dart';

final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;

String createAccount(){
  final user = FirebaseAuth.instance.currentUser;
  String id = db.collection("users").doc().id;
  var status = {'tasks': 0, 'listen_count': 0, 'journal': 0, 'check_in': 0};

  if(user?.isAnonymous == false){
    db.collection("users").doc(id).set({
      'uid': id, 'email': user!.email, 'avatar': 'owl', 'uname': 'buddy','check-in_time': 'Evening', 'status': status, 'favSongs': [], 'favTasks': [],
    });

    db.collection('FavSong').add({'user': user.email});
  }else if(user?.isAnonymous == true){
    db.collection("users").doc(id).set({
      'uid': id, 'avatar': 'owl', 'uname': 'buddy', 'anon_uid': user?.uid
    });
  }

  print('---------- id from AccountOperation : ${id}');
  return id;
}

void updateAccount(attr, value){
  print('----------- attr : ${attr}, value : ${value}');
  var val = value;
  var key = attr;
  db.collection('users').get().then((value){
    value.docs.forEach((element) {
      try{
        if(element['email'] == user?.email){
          db.collection('users').doc(element.id).update({
            key: val,
          });
        }
      }catch(e){}
    });
  });
}

// We get access to a collection reference, then list the results of the query,
// then create local model objects for the data returned by Firestore,
// and then we return the a list of those model objects.
Future<List> getEventsFromFirestore() async {
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  QuerySnapshot eventsQuery = await ref
      // .where("time", isGreaterThan: new DateTime.now().millisecondsSinceEpoch)
      .where("email", isEqualTo: user?.email)
      .get();

  HashMap<String, dynamic> eventsHashMap = new HashMap<String, dynamic>();
  eventsQuery.docs.forEach((element) {
    eventsHashMap.addAll({'uname': element['uname'], 'avatar': element['avatar']});
  });

  return eventsHashMap.values.toList();
}

// add song,task to fav list
void addFav(listName, id, data, boolValue) {
  print('----------- value : ${data}');
  db.collection('users').get().then((value){
    value.docs.forEach((element) {
      if(element['email'] == user?.email){
        var favList = element['${listName}'];
        print('value from operations : ${listName}, ${id}, ${data}, ${boolValue}');
        // when liked
        if(boolValue == true){
          favList.add(data);
        }else{
          //when unliked
          // id -> song ID or task name
          favList.removeWhere((item) => item['id'] == id);
        }

        var key = listName;
        var val = favList;
        db.collection('users').doc(element.id).update({
          key: val,
        });
      }
    });
  });
}

// update status of diary
void updateStatus(status, count){
  db.collection('users').get().then((value){
    value.docs.forEach((element) {
      try{
        if(element['email'] == user?.email){
          // element['status']['check_in'] = element['status']['check_in'].toInt() + 1;

          //check if count is of type string
          if(count.runtimeType == String){
            count = int.parse(count);
          }

          var statusList = element['status'];
          statusList['${status}'] = statusList['${status}'].toInt() + count;
          print('status : ${element['status']}');
          print('check in status : ${statusList['check_in'] }');
          print('update from ${statusList['${status}']} to ${statusList['${status}'] + count}');
          var key = 'status';
          var val = statusList;
          db.collection('users').doc(element.id).update({
            key: val,
          });
        }
      }catch(e){}
    });
  });
}

