
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'AccountOperations.dart';

final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;
var Uinfo;

// get user data
Future<HashMap<String, dynamic>> getEventsFromFirestore() async {
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  QuerySnapshot eventsQuery = await ref
      .where("email", isEqualTo: user?.email)
      .get();

  HashMap<String, dynamic> eventsHashMap = new HashMap<String, dynamic>();
  eventsQuery.docs.forEach((element) {
    eventsHashMap.addAll({'uname': element['uname'], 'avatar': element['avatar']});
  });

  Uinfo = eventsHashMap;

  return eventsHashMap;
}

// add mood, recommend songs, recommend tasks
void rec_user(var id, String mood, var email) async{
  // key -> emotions shown to user , value -> emotions used to recommend
  var mood_list = {'great': 'happy','good': 'anxiety','ok': 'sad','bad': 'angry','tired': 'tired'};
  mood_list.forEach((key, value){
    if(key == mood){
      mood = value;
      return;
    }
  });

  List tasks_list = await recommend_tasks(mood);
  List songs_list = await recommend_songs(mood);

  //add mood,tasks to new user doc
  if(user?.isAnonymous == true){
    // for user with anonymous login
    print('inside if');
    db.collection('users').get().then((value){
      value.docs.forEach((element) {
        print(' uid is : ${user?.uid}');
        try{
          if(element['anon_uid'] == user?.uid){
            db.collection('users').doc(element.id).update({
              'mood': mood,
              'songs': songs_list,
              'tasks': tasks_list
            });
          }
        }catch(e){

        }
      });
    });
    return;
  }else{
    print('mood from check in : ${mood}');
    // if user logged in
    if(EmailValidator.validate(email.trim())){
      db.collection('users').get().then((value){
        value.docs.forEach((element) {
          try{
            if(element['email'] == user?.email){
              db.collection('users').doc(element.id).update({
                'mood': mood,
                'songs': songs_list,
                'tasks': tasks_list
              });
            }
          }catch(e){}
        });
      });
    }


    // on check-in empty the recent songs list
    db.collection('users').get().then((value){
      value.docs.forEach((element) {
        try{
          if(element['email'] == user?.email){
            var recentSongs = [];
            var key = 'recentSongs';
            var val = recentSongs;
            db.collection('users').doc(element.id).update({
              key: val,
            });
          }
        }catch(e){}
      });
    });
  }
}

// recommend tasks
Future<List> recommend_tasks(String mood) async{
  CollectionReference t = db.collection('taskList');

  List tasks_list = [
    {'title': 'myTitle'}
  ];

  final result = await t
      .where('mood', isEqualTo: mood)
      .get();
  tasks_list = result.docs.map((e) => e.data()).toList();

  print("----------------------- List of rec tasks: $tasks_list");

  // List<String> tasks_list = ['tasks'];
  return tasks_list;
}

fetchData(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}


Future<void> downloadURLExample(track_name) async {
  var url;
  print('inside download Url');
  var downloadURL = await FirebaseStorage.instance
      .ref()
      .child("songPlaylist/${track_name}.mp3")
      .getDownloadURL();
  url = downloadURL;
  print('>>>>>>>>> url link : ${url}');
  return url;
}

// recommend songs
Future recommend_songs(String mood) async{
  var url = '';
  var data = '';
  var output;

  print('---------- mood from check in ${mood.toString()}');

  url = 'https://shruti1208.pythonanywhere.com/?mood=' + mood.toString();
  data = await fetchData(url);
  var decoded = jsonDecode(data);
  output = decoded['tracks'];

  print('---------------- Songs : '+output[0]['track_name']);

  // for(int i=0; i<5; i++){
  //   var cover_url = output[i]['cover_url'];
  //   output[i].forEach((key, value) async {
  //     downloadURLExample('track_name');
  //     var song_url = downloadURLExample(output[i]['track_name']+'-'+output[i]['artist_name']);
  //     print('----------- title mp3 : '+output[i]['track_name']+'-'+output[i]['artist_name']);
  //     var li = [cover_url, song_url];
  //     print('------------ list here : ${li}');
  //     output[i]['cover_url'] = li;
  //   });
  // }

  print("----------------------- List of rec songs: ${output}");

  return output;
}














Future getId() async {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference u = db.collection('users');
  List userId = [];

  final result = await u
      .where('email', isEqualTo: user?.email)
      .get();
  userId = result.docs.map((e) => e.data()).toList();

  // db.collection('users').get().then((value){
  //   value.docs.forEach((element) {
  //     if(element['email'] == user?.email){
  //       id = element.id;
  //       print('--------- id from check-in after googleSignIn - ${id}');
  //     }
  //   });
  // });
  print('--------- id from check-in after googleSignIn - ${userId}');
  print('----------- user email : ${user?.email}');
  return userId;
}



