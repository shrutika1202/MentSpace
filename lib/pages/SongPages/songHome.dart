import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mental_health_app/PageRouting.dart';
import 'package:mental_health_app/pages/SongPages/SongPlay.dart';
import 'package:mental_health_app/pages/SongPages/songAlbums.dart';

import '../../main.dart';
import '../Authentication/AuthPage.dart';
import '../ExtraFiles/Check_in.dart';
import '../ExtraFiles/search.dart';
import '../HomePage/home.dart';

// an arrow button which redirects to albums page and list of recommended songs

class SongHomePage extends StatefulWidget {
  // const SongHomePage({Key? key}) : super(key: key);

  var Uid;
  SongHomePage({
    this.Uid
  });

  @override
  _SongHomePageState createState() => _SongHomePageState();
}
final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;
var isPlaying;

var urlList = {};
class _SongHomePageState extends State<SongHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var name = 'user';
  // list of song ID to check for fav songs
  var favSongsList;
  var songList = {};
  var songsArray = [];
  var songs = [];

  Future<void> downloadURLExample(id, track_name) async {
    var downloadURL = await FirebaseStorage.instance
        .ref()
        .child("songPlaylist/${track_name}.mp3")
        .getDownloadURL();
    urlList['${id}'] = downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white30,
      // appBar: AppBar(
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   toolbarHeight: 110.0,
      //   backgroundColor: Colors.white30,
      //   title: RichText(
      //     text: TextSpan(
      //       text: 'Welcome',
      //       style: TextStyle(
      //           fontSize: 15,
      //           color: Colors.deepPurpleAccent[100]
      //       ),
      //       children: <TextSpan>[
      //         TextSpan(
      //           text: '\n${name.toUpperCase()}',
      //           style: TextStyle(
      //               fontSize: 15,
      //               color: Colors.deepPurpleAccent[100],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      //   actions: [
      //     Padding(
      //       padding: EdgeInsets.all(30),
      //       child: CircleAvatar(
      //           radius: 35,
      //           child: Icon(Icons.person)
      //       ),
      //     ),
      //   ],
      // ),
      body: FutureBuilder(
        future: db.collection('users')
            .where("${user?.isAnonymous == true ? 'anon_uid' : 'email'}", isEqualTo: user?.isAnonymous == true ? user?.uid : user?.email)
            .get(),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          try{
            songsArray = snapshot.hasData ? ((snapshot.data as QuerySnapshot).docs)[0]["songs"] : [];
          }catch(e){
            songsArray = [];
          }

          try{
            favSongsList = snapshot.hasData && user?.isAnonymous == false ? ((snapshot.data as QuerySnapshot).docs)[0]["favSongs"] : [];
          }catch(e){
            favSongsList = [];
          }
          print('------- songsArray from songHome : ${songsArray}');

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 60,),
                Padding(
                  padding: EdgeInsets.only(left: 17, right: 17),
                  child: GestureDetector(
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.search,
                              size: 30,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'search for music ...',
                              style: TextStyle(
                                  color: Colors.grey[700]
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(searchTermsList: songs, dict: songList)
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 17, right: 17, top: 20),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://wallpapercave.com/wp/wp2672824.jpg',
                            ),
                            fit: BoxFit.cover
                        )
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 45, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              text: 'Go find your\nfavourite',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 28,
                                  color: Colors.white
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '\nTop songs being discover\naround the world right now',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[400]
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 27,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios),
                                  //redirect to albums page
                                  onPressed: () {
                                    // print('user anon : ${user?.email}');
                                    if(user?.isAnonymous == true){
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
                                                    'Login first to get fetures\nthat save your progress... ',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.grey[800]
                                                    ),
                                                  )
                                              ),
                                              SizedBox(height: 20,),
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
                                                      'Login',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    onPressed: (){
                                                      Navigator.push(context, MaterialPageRoute(
                                                          builder:(context) => AuthPage()
                                                      ));
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
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }else if(user?.isAnonymous == false){
                                      Navigator.push(context, new MaterialPageRoute(
                                          builder: (context) => new SongAlbum())
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 17),
                    child: Text(
                      'Picked for you',
                      style: TextStyle(
                          letterSpacing: 3,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 5,),
                songsArray.isEmpty ?
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          'No songs available',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[800]
                          ),
                        ),
                        Text(
                          ' Check-in to get songs recommended',
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
                  itemCount: songsArray.length,
                  itemBuilder: (context, int index){

                    var song = songsArray[index];
                    downloadURLExample(song['id'], song['track_name']+'-'+song['artist_name']);
                    songs.add('${song['track_name']}');
                    songList[song['track_name']]= {'id': song['id'], 'singer': song['artist_name'], 'image': song['cover_url'], 'isFav': false, 'url': urlList[song['id']], 'array': song, 'favSongs': favSongsList};

                    return Padding(
                      padding: EdgeInsets.only(left: 17, right: 17),
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: song['id'] == isPlaying ? Colors.grey : Colors.white30,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage('${song['cover_url'] != 'NA' ? song['cover_url'] :'https://tse3.mm.bing.net/th?id=OIP.y2tfm0aeBmZmiIqgBPT4OgHaI4&pid=Api&P=0'}'),
                                        // image: NetworkImage(song['cover_image'] ? song['cover_image'] : 'https://tse3.mm.bing.net/th?id=OIP.y2tfm0aeBmZmiIqgBPT4OgHaI4&pid=Api&P=0'),
                                        fit: BoxFit.cover
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      text: song['track_name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                          color: Colors.grey[800],
                                          overflow: TextOverflow.ellipsis
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '\n${song['artist_name']}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[600]
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: (){
                          print('-------- songs links list : ${urlList}');
                          setState(() {
                            print('---------- current song id : ${song['id']}');
                            isPlaying = song['id'];
                          });
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => new SongPlayPage(
                                id: song['id'],
                                name: song['track_name'],
                                singer: song['artist_name'],
                                image: song['cover_url'] != 'NA' ? song['cover_url'] : 'https://tse3.mm.bing.net/th?id=OIP.y2tfm0aeBmZmiIqgBPT4OgHaI4&pid=Api&P=0',
                                favSongsList: favSongsList,
                                url: urlList[song['id']],
                                Songarray: song,
                              ))
                          );
                          isPlaying = 0;
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          );
        }
      ),
    );
  }
}



