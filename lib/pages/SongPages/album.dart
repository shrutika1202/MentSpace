import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../ExtraFiles/search.dart';
import 'SongPlay.dart';

// page for single album with its songs

class AlbumPage extends StatefulWidget {
  // const AlbumPage({Key? key}) : super(key: key);

  var name;
  var desp;
  final image;
  final songList;
  AlbumPage({
    required this.image,
    required this.name,
    required this.desp,
    required this.songList,
});

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

final db = FirebaseFirestore.instance;

// check song is in db
bool songCheck(songName, songList){
  print(songList);
  for(int i = 0; i<songList.length; i ++){
    if(songName == songList[i]){
      return true;
    }
  }
  return false;
}

class _AlbumPageState extends State<AlbumPage> {
  var isPlaying;
  // bool var that checks whether song is in SongList of album
  bool isInAlbum = false;
  bool isFav = false;
  // for search icon list of songs and artists
  var songList = {};
  var songs = [];
  // fetch song url from user to add new song
  String song_url = '';
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
      body: Column(
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
                    image: NetworkImage(widget.image),
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
                        '${widget.songList.length} songs',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 17,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 17),
                child: GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    radius: 25,
                    child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey[500],
                      size: 30,
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      isFav = !isFav;
                      print('---------------- isFav ? ${isFav}');
                    });
                  },
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(5),
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
            child: Text(
                'add song',
              style: TextStyle(
                fontSize: 13,
                letterSpacing: 2,
                color: Colors.deepPurpleAccent
              ),
            ),
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      title: Text('add new song'),
                      content: TextField(
                        onChanged: (String value) {
                          song_url = value;
                        },
                      ),
                      actions: [
                        TextButton(
                          child: Text('add'),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  }
              );
            },
          ),
          SizedBox(height: 14,),
          StreamBuilder(
            stream: db.collection('songs').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, int index){
                  DocumentSnapshot song = snapshot.data.docs[index];
                  isInAlbum = songCheck(song['name'], widget.songList);
                  print(isInAlbum);
                  // create list of songs and singers
                  if(isInAlbum){
                    songList['${song['name']}'] = {
                      'id': song.id,
                      'singer': '${song['singer']}',
                      'image': '${song['url']}',
                      'isFav': song['isFav'],
                    };
                    songs.add('${song['name']}');
                  }

                  return isInAlbum ? Padding(
                    padding: EdgeInsets.only(left: 17, right: 17),
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          color: song.id == isPlaying ? Colors.grey[500] : Colors.grey[300],
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
                                      image: NetworkImage('${song['image']}'),
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              SizedBox(width: 20,),
                              RichText(
                                text: TextSpan(
                                  text: song['name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 26,
                                      color: Colors.blueGrey
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '\n${song['singer']}',
                                      style: TextStyle(
                                          fontSize: 15,
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
                          isPlaying = song.id;
                        });
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => new SongPlayPage(
                              id: song.id,
                              name: song['name'],
                              singer: song['singer'],
                              image: song['image'],
                              isFav: song['isFav'],
                            ))
                        );
                        isPlaying = 0;
                      },
                    ),
                  ) : SizedBox(height: 0,);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
