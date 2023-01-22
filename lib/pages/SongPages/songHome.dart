import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mental_health_app/pages/SongPages/SongPlay.dart';
import 'package:mental_health_app/pages/SongPages/songAlbums.dart';

import '../../main.dart';
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
var isPlaying;

class _SongHomePageState extends State<SongHomePage> {
  var name = 'user';
  var songList = {};
  var songsArray = [];
  var songs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white30,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 110.0,
        backgroundColor: Colors.white30,
        title: RichText(
          text: TextSpan(
            text: 'Welcome',
            style: TextStyle(
                fontSize: 15,
                color: Colors.deepPurpleAccent[100]
            ),
            children: <TextSpan>[
              TextSpan(
                text: widget.Uid == null ? widget.Uid.toUpperCase() : '\n${name.toUpperCase()}',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.deepPurpleAccent[100],
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(30),
            child: CircleAvatar(
                radius: 35,
                child: Icon(Icons.person)
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: db.collection('anonymous_users')
            .where('uid', isEqualTo: widget.Uid)
            .get(),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          songsArray = snapshot.hasData ? ((snapshot.data as QuerySnapshot).docs)[0]["songs"] : [];
          print('------- songsArray from songHome : ${songsArray}');

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
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
                                    Navigator.push(context, new MaterialPageRoute(
                                        builder: (context) => new SongAlbum())
                                    );
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
                SizedBox(height: 50,),
                songsArray.length > 0 ?
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: songsArray.length,
                  itemBuilder: (context, int index){
                    var song = songsArray[index];
                    songs.add('${song['track_name']}');
                    songList[song['track_name']]= {'id': song['id'], 'singer': song['artist_name'], 'image': 'https://tse3.mm.bing.net/th?id=OIP.y2tfm0aeBmZmiIqgBPT4OgHaI4&pid=Api&P=0', 'isFav': false};
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
                                        image: NetworkImage('https://tse3.mm.bing.net/th?id=OIP.y2tfm0aeBmZmiIqgBPT4OgHaI4&pid=Api&P=0'),
                                        // image: NetworkImage(song['cover_image'] ? song['cover_image'] : 'https://tse3.mm.bing.net/th?id=OIP.y2tfm0aeBmZmiIqgBPT4OgHaI4&pid=Api&P=0'),
                                        fit: BoxFit.cover
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20,),
                                RichText(
                                  text: TextSpan(
                                    text: song['track_name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                        color: Colors.grey[800]
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
                              ],
                            ),
                          ),
                        ),
                        onTap: (){
                          setState(() {
                            print('---------- song id : ${song['id']}');
                            isPlaying = song['id'];
                          });
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => new SongPlayPage(
                                id: song['id'],
                                name: song['track_name'],
                                singer: song['artist_name'],
                                image: 'https://tse3.mm.bing.net/th?id=OIP.y2tfm0aeBmZmiIqgBPT4OgHaI4&pid=Api&P=0',
                                // image: song['cover_image'] ? song['cover_image'] : 'https://tse3.mm.bing.net/th?id=OIP.y2tfm0aeBmZmiIqgBPT4OgHaI4&pid=Api&P=0',
                                isFav: false,
                              ))
                          );
                          isPlaying = 0;
                        },
                      ),
                    );
                  },
                )
                : Column(
                  children: <Widget>[
                    Image.network(
                      'https://tse1.mm.bing.net/th?id=OIP.w8YMeMXz_tZ3LUh06MB5UQHaHa&pid=Api&P=0',
                      height: 100,
                      width: 100,
                    ),
                    Text(
                      'Check in first to get recommendations',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w200
                      ),
                    ),
                    SizedBox(height: 5,),
                    ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(15),
                          overlayColor: MaterialStateProperty.all(Colors.grey[200]),
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(color: Colors.white)
                              )
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context)=> MyApp(pageIndex: 0 ,Uid: widget.Uid,)
                            ),
                          );
                        },
                        child: Padding(
                            padding: EdgeInsets.only(top: 10,bottom: 10,right: 20, left: 20),
                            child: Text(
                              'Check-in',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.deepPurple
                              ),
                            )
                        )
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}



