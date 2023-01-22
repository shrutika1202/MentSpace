import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/pages/SongPages/album.dart';

import 'SongPlay.dart';

// page with recently played music Row and all the albums container

class SongAlbum extends StatefulWidget {
  const SongAlbum({Key? key}) : super(key: key);

  @override
  _SongAlbumState createState() => _SongAlbumState();
}
final db = FirebaseFirestore.instance;

class _SongAlbumState extends State<SongAlbum> {
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
            stream: db.collection('songs').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Container(
                height: 160,
                // color: Colors.deepPurple,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  // shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, int index){
                    DocumentSnapshot song = snapshot.data.docs[index];
                    return Padding(
                      padding: EdgeInsets.only(left: 15, ),
                      child: GestureDetector(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(song['image']),
                                    fit: BoxFit.cover
                                ),
                              ),
                            ),
                            SizedBox(height: 12,),
                            Padding(
                              padding: EdgeInsets.only(right: 25),
                              child: RichText(
                                text: TextSpan(
                                  text: song['name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Colors.grey[800]
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '\n${song['singer']}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500]
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: (){
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => new SongPlayPage(
                                id: song.id,
                                name: song['name'],
                                singer: song['singer'],
                                image: song['image'],
                                isFav: song['isFav'],
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
          SizedBox(height: 10,),
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
                // To add playlist using link
                // IconButton(
                //   icon: Icon(
                //     Icons.add,
                //     color: Colors.grey[800],
                //     size: 30,
                //   ),
                //   onPressed: (){},
                // ),
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
                                  image: NetworkImage(album['image']),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.grey.withOpacity(1), BlendMode.modulate,)
                              ),
                            ),
                          ),
                          onTap: (){
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => new AlbumPage(
                                  name: album['name'],
                                  image: album['image'],
                                  desp: album['desp'],
                                  songList: album['songs'],
                                ))
                            );
                          },
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
          // SizedBox(height: 30,)
        ],
      ),
    );
  }
}
