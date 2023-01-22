
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final db = FirebaseFirestore.instance;

// add mood, recommend songs, recommend tasks
void rec_user(var id, String mood, var email) async{
  // key -> emotions shown to user , value -> emotions used to recommend
  var mood_list = {'great': 'happy','good': 'anxiety','ok': 'sad','bad': 'angry','awful': 'disgust'};
  mood_list.forEach((key, value){
    if(key == mood){
      mood = value;
      return;
    }
  });

  List tasks_list = await recommend_tasks(mood);
  List songs_list = await recommend_songs(mood);

  //add mood,tasks to new user doc
  if(email == null){
    db.collection("anonymous_users").doc(id).set({'mood': mood, 'tasks': tasks_list, 'songs': songs_list, 'uid': id});
  }else{
    // if user logged in
    if(EmailValidator.validate(email.trim())){
      db.collection('anonymous_users').get().then((value){
        value.docs.forEach((element) {
          if(element['email'] == email){
            db.collection('anonymous_users').doc(element.id).update({
              'mood': mood,
              'songs': songs_list,
              'tasks': tasks_list,
              'email': email,
              'uid': element.id
            });
          }
        });
      });
    }
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

  print("----------------------- List of rec songs: ${output}");

  return output;
}


