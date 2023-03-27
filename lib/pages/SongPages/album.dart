import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../ExtraFiles/search.dart';
import 'SongPlay.dart';

// page for single album with its songs

class AlbumPage extends StatefulWidget {
  // const AlbumPage({Key? key}) : super(key: key);

  var name;
  var desp;
  var mood;
  AlbumPage({
    required this.mood,
    required this.name,
    required this.desp,
});

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

final db = FirebaseFirestore.instance;
var urlList = {};

class _AlbumPageState extends State<AlbumPage> {
  var isPlaying;
  // for search icon list of songs and artists
  var songList = {};
  var songsArray = [];
  var songArrays = [];
  var songs = [];
  var songId = [];
  // fetch song url from user to add new song
  String song_url = '';
  var song = {};

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
        title: Padding(
          padding: EdgeInsets.only(left: 60),
          child: Text(
            '${widget.name}',
            overflow: TextOverflow.clip,
            style: TextStyle(
                fontSize: 20,
                letterSpacing: 2,
                color: Colors.grey[800]
            ),
          ),
        ),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: (){
                showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(searchTermsList: songs, dict: songList)
                );
              },
              icon: Icon(
                Icons.search,
                color: Colors.grey[700],
                size: 40,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: db.collection('FavSong')
            .get(),
        builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          try{
            songsArray = snapshot.hasData ? ((snapshot.data as QuerySnapshot).docs)[0]["FavSong"] : [];
          }catch(e){
            songsArray = [];
          }
          print('------- songsArray from ${widget.name} : ${songsArray}');
          for(int i=0; i<songsArray.length; i++){
            if(songsArray[i]['mood'] == widget.mood && songId.indexOf(songsArray[i]['id']) == -1){
              songId.add(songsArray[i]['id']);
              songArrays.add(songsArray[i]);
            }
          }


          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 17, right: 17, top: 20),
                  child: Container(
                    height: 250,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 25, right: 20),
                        child: RichText(
                          text: TextSpan(
                            text: '',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 35,
                                color: Colors.white
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                // optional might remove it
                                text: '\n${widget.desp}',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[200]
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
                          image: AssetImage('assets/albums/${widget.name}.png'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.grey.withOpacity(1), BlendMode.modulate,)
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        // display listen time
                        children: <Widget>[
                          Icon(
                            Icons.music_note,
                            color: Colors.grey[500],
                            size: 30,
                          ),
                          Text(
                            '${songArrays.length} songs',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 17,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                songArrays.isEmpty
                ? Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          'album is empty',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[800]
                          ),
                        ),
                        Text(
                          'No songs are available in this album',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: songArrays.length,
                  itemBuilder: (context, int index){

                    if(true){
                      // create list of songs and singers
                      song = songArrays[index];
                      print('song from album : ${song}');

                      downloadURLExample(song['id'], song['track_name']+'-'+song['artist_name']);
                      songId.add(song['id']);
                      songs.add('${song['track_name']}');
                      songList[song['track_name']]= {'id': song['id'], 'singer': song['artist_name'], 'image': song['cover_url'], 'isFav': false, 'url': urlList[song['id']], 'array': song};
                    }else{}

                    print('songsarray : ${songsArray}');
                    print('song for mood : ${song}');

                    return song != {} ? Padding(
                      padding: EdgeInsets.only(left: 17, right: 17),
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: song['id'] == isPlaying ? Colors.grey[500] : Colors.grey[300],
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
                                        image: NetworkImage('${song['cover_url'] == 'NA' ? 'https://tse4.mm.bing.net/th?id=OIP.lzbr0l9wXKFJj0-OaygsoAHaI4&pid=Api&P=0' : song['cover_url']}'),
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
                                        fontSize: 20,
                                        color: Colors.blueGrey,

                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '\n${song['artist_name']}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueGrey[400]
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
                            isPlaying = song['id'];
                          });
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => new SongPlayPage(
                                id: song['id'],
                                name: song['track_name'],
                                singer: song['artist_name'],
                                image: song['cover_url'],
                                favSongsList: songId,
                                url: urlList[song['id']],
                                Songarray: song,
                              ))
                          );
                          isPlaying = 0;
                        },
                      ),
                    ) : SizedBox(height: 5,);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



class FavSongAlbum extends StatefulWidget {
  // const FavSongAlbum({Key? key}) : super(key: key);

  var name;
  var desp;
  FavSongAlbum({
    required this.name,
    required this.desp
  });
  @override
  _FavSongAlbumState createState() => _FavSongAlbumState();
}

class _FavSongAlbumState extends State<FavSongAlbum> {
  var urlList = {};
  var isPlaying;
  // for search icon list of songs and artists
  var songList = {};
  var songsArray = [];
  var songs = [];
  var songId = [];
  // fetch song url from user to add new song
  String song_url = '';

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
        title: Padding(
          padding: EdgeInsets.only(left: 60),
          child: Text(
            '${widget.name}',
            overflow: TextOverflow.clip,
            style: TextStyle(
                fontSize: 20,
                letterSpacing: 2,
                color: Colors.grey[800]
            ),
          ),
        ),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: (){
                showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(searchTermsList: songs, dict: songList)
                );
              },
              icon: Icon(
                Icons.search,
                color: Colors.grey[700],
                size: 40,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: db.collection('FavSong')
            .where('user', isEqualTo: user?.email)
            .get(),
        builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          try{
            songsArray = snapshot.hasData ? ((snapshot.data as QuerySnapshot).docs)[0]["FavSong"] : [];
          }catch(e){
            songsArray = [];
          }
          print('------- songsArray from songHome : ${songsArray}');


          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 17, right: 17, top: 20),
                  child: Container(
                    height: 250,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 25, right: 20),
                        child: RichText(
                          text: TextSpan(
                            text: '',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 35,
                                color: Colors.white
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                // optional might remove it
                                text: '\n${widget.desp}',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[200]
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
                          image: AssetImage('assets/albums/${widget.name}.png'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.grey.withOpacity(1), BlendMode.modulate,)
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        // display listen time
                        children: <Widget>[
                          Icon(
                            Icons.music_note,
                            color: Colors.grey[500],
                            size: 30,
                          ),
                          Text(
                            '${songsArray.length} songs',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 17,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // ElevatedButton(
                //   style: ButtonStyle(
                //     elevation: MaterialStateProperty.all(5),
                //     overlayColor: MaterialStateProperty.all(Colors.grey[200]),
                //     backgroundColor: MaterialStateProperty.all(Colors.white),
                //     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                //         RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(20),
                //             side: BorderSide(color: Colors.white)
                //         )
                //     ),
                //   ),
                //   child: Text(
                //     'add song',
                //     style: TextStyle(
                //         fontSize: 13,
                //         letterSpacing: 2,
                //         color: Colors.deepPurpleAccent
                //     ),
                //   ),
                //   onPressed: (){
                //     showDialog(
                //         context: context,
                //         builder: (BuildContext context){
                //           return AlertDialog(
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(8),
                //             ),
                //             title: Text('add new song'),
                //             content: TextField(
                //               onChanged: (String value) {
                //                 song_url = value;
                //               },
                //             ),
                //             actions: [
                //               TextButton(
                //                 child: Text('add'),
                //                 onPressed: (){
                //                   Navigator.of(context).pop();
                //                 },
                //               )
                //             ],
                //           );
                //         }
                //     );
                //   },
                // ),
                SizedBox(height: 14,),
                songsArray.isEmpty
                ? Padding(
                  padding: const EdgeInsets.only(top: 300),
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          'album is empty',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[800]
                          ),
                        ),
                        Text(
                          'no songs available in this album',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey
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

                    // create list of songs and singers
                    var song = songsArray[index];
                    print('song from album : ${song}');

                    downloadURLExample(song['id'], song['track_name']+'-'+song['artist_name']);
                    songId.add(song['id']);
                    songs.add('${song['track_name']}');
                    songList[song['track_name']]= {'id': song['id'], 'singer': song['artist_name'], 'image': song['cover_url'], 'isFav': false, 'url': urlList[song['id']], 'array': song};

                    return true ? Padding(
                      padding: EdgeInsets.only(left: 17, right: 17),
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: song['id'] == isPlaying ? Colors.grey[500] : Colors.grey[300],
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
                                        image: NetworkImage('${song['cover_url']}'),
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
                                        fontSize: 20,
                                        color: Colors.blueGrey
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '\n${song['artist_name']}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueGrey[400]
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
                            isPlaying = song['id'];
                          });
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => new SongPlayPage(
                                id: song['id'],
                                name: song['track_name'],
                                singer: song['artist_name'],
                                image: song['cover_url'],
                                favSongsList: songId,
                                url: urlList[song['id']],
                                Songarray: song,
                              ))
                          );
                          isPlaying = 0;
                        },
                      ),
                    ) : SizedBox(height: 0,);
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

