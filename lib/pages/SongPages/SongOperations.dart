
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;
var mood;

// get user data
Future<HashMap<String, dynamic>> getEventsFromFirestore() async {
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  QuerySnapshot eventsQuery = await ref
      .where("${user?.isAnonymous == true ? 'anon_uid' : 'email'}", isEqualTo: user?.isAnonymous == true ? user?.uid : user?.email)
      .get();

  HashMap<String, dynamic> eventsHashMap = new HashMap<String, dynamic>();
  eventsQuery.docs.forEach((element) {
    eventsHashMap.addAll({'mood': element['mood']});
  });

  mood = eventsHashMap['mood'];

  return eventsHashMap;
}


// add fav songs to FavSongs album
void addFavSongs(listName, id, data, boolValue) {
  getEventsFromFirestore();
  print('----------- value : ${data}');
  db.collection('FavSong').get().then((value){
    value.docs.forEach((element) {
      try{
        if(element['user'] == user?.email){
          var favList;
          try{
            favList = element['FavSong'];
          }catch(e){
            favList = [];
          }
          print('value from operations : ${listName}, ${id}, ${data}, ${boolValue}');
          // when liked
          if(boolValue == true){
            data['mood'] = mood;
            for(int i = 0; i<favList.length; i++){
              if(favList[i]['id'] == data['id']){
                return;
              }
            }
            favList.add(data);
          }else{
            //when unliked
            // id -> song ID
            favList.removeWhere((item) => item['id'] == id);
          }

          var key = 'FavSong';
          var val = favList;
          db.collection('FavSong').doc(element.id).update({
            key: val,
          });

          // add song ID in favSongs field of user collection
          db.collection('users').get().then((value){
            value.docs.forEach((element) {
              try{
                if(element['email'] == user?.email){
                  var favList = element['favSongs'];
                  print('value from operations  user: ${listName}, ${id}, ${data}, ${boolValue}');
                  // when liked
                  if(boolValue == true){
                    print('favList from operation user : ${favList.length}');
                    favList.add(data['id']);
                  }else{
                    //when unliked
                    // id -> song ID or task name
                    favList.removeWhere((item) => item == data['id']);
                  }

                  var key = listName;
                  var val = favList;
                  db.collection('users').doc(element.id).update({
                    key: val,
                  });
                }
              }catch(e){}
            });
          });


        }
      }catch(e){}
    });
  });
}

