import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/pages/SongPages/album.dart';
import 'package:mental_health_app/pages/SongPages/songHome.dart';

import 'SongPlay.dart';

// page with recently played music Row and all the albums container

class SongAlbum extends StatefulWidget {
  const SongAlbum({Key? key}) : super(key: key);

  @override
  _SongAlbumState createState() => _SongAlbumState();
}
final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;

var urlList = {};
class _SongAlbumState extends State<SongAlbum> {
  var songsArray = [];
  var favSongsList;

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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.grey[300],
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: GestureDetector(
            child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey[500],
                  ),
                )
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
        ),
        // title: Padding(
        //   padding: const EdgeInsets.only(left: 80),
        //   child: Text(
        //     'playlist',
        //     style: TextStyle(
        //       letterSpacing: 2,
        //       fontSize: 20,
        //       fontWeight: FontWeight.w600,
        //       color: Colors.deepPurple
        //     ),
        //   ),
        // ),
      ),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 17),
              child: Text(
                'Recently played',
                style: TextStyle(
                    letterSpacing: 3,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          StreamBuilder(
            stream: db.collection('users')
                .where("${user?.isAnonymous == true ? 'anon_uid' : 'email'}", isEqualTo: user?.isAnonymous == true ? user?.uid : user?.email)
                // .orderBy('time', descending: true)
                // .limitToLast(5)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              songsArray = snapshot.hasData ? ((snapshot.data as QuerySnapshot).docs)[0]["recentSongs"] : [];

              return songsArray.isEmpty
              ? Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        ' No songs played Recently',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : Container(
                height: 210,
                // color: Colors.deepPurple,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  // shrinkWrap: true,
                  itemCount: songsArray.length,
                  itemBuilder: (context, int index){

                    // DocumentSnapshot song = snapshot.data.docs[index];
                    var song = songsArray[index]['song'];
                    if(song['track_name'] != null){
                      downloadURLExample(song['id'], song['track_name']+'-'+song['artist_name']);
                    }
                    try{
                      favSongsList = snapshot.hasData && user?.isAnonymous == false ? ((snapshot.data as QuerySnapshot).docs)[0]["favSongs"] : [];
                    }catch(e){
                      favSongsList = [];
                    }
                    // print('songs from recent : ${song['song']}');
                    return Padding(
                      padding: EdgeInsets.only(left: 15, bottom: 10),
                      child: GestureDetector(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage('${song['cover_url'] != 'NA' ? song['cover_url'] :'https://tse3.mm.bing.net/th?id=OIP.y2tfm0aeBmZmiIqgBPT4OgHaI4&pid=Api&P=0'}'),
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              SizedBox(height: 12,),
                              Padding(
                                padding: EdgeInsets.only(right: 25),
                                child: Container(
                                  height: 200,
                                  width: 100,
                                  child: Flexible(
                                    child: RichText(
                                      text: TextSpan(
                                        text: song['track_name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.grey[800],
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '\n${song['artist_name']}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.grey[500]
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: (){
                          print('songs from recent : ${song['song']}');
                          print('---- recent song urls : ${urlList}');
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
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(height: 5,),
          Divider(color: Colors.white12, indent: 15, endIndent: 15,),
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'Albums',
                      style: TextStyle(
                          letterSpacing: 3,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: StreamBuilder(
              stream: db.collection('songAlbum').snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Padding(
                  padding: EdgeInsets.only(left: 20, right: 5),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    shrinkWrap: true,
                    children: List.generate(snapshot.data?.docs.length, (index){
                      DocumentSnapshot album = snapshot.data.docs[index];
                      return Padding(
                        padding: EdgeInsets.only( right: 15,bottom: 5),
                        child: GestureDetector(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10, bottom: 10),
                                child: RichText(
                                  text: TextSpan(
                                    text: album['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.white
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        // optional might remove it
                                        text: '\n',    //'\n${album['desp'][20]}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[500],
                                          overflow: TextOverflow.clip
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  // think abt this
                                  image: AssetImage('assets/albums/${album['name']}.png'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.grey.withOpacity(1), BlendMode.modulate,)
                              ),
                            ),
                          ),
                          onTap: (){
                            if(album['name'] == 'Favourites'){
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => new FavSongAlbum(
                                    name: album['name'],
                                    desp: album['desp'],
                                  ))
                              );
                            }else{
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) => new AlbumPage(
                                    name: album['name'],
                                    mood: album['mood'],
                                    desp: album['desp'],
                                  ))
                              );
                            }
                          },
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }
}
