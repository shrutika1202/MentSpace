
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'SongOperations.dart';

import '../ExtraFiles/AccountOperations.dart';

class SongPlayPage extends StatefulWidget {
  // const SongPlayPage({Key? key}) : super(key: key);

  var id;
  var name;
  var singer;
  var image;
  var favSongsList;
  var url;
  var Songarray;
  SongPlayPage({
    required this.id,
    required this.name,
    required this.singer,
    required this.image,
    required this.favSongsList,
    required this.url,
    required this.Songarray
});
  @override
  _SongPlayPageState createState() => _SongPlayPageState();
}

final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;

class _SongPlayPageState extends State<SongPlayPage> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isFav = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // add song to recently played list
  void addRecentSongs(songList) {
    print('----------- value : ${songList}');
    db.collection('users').get().then((value){
      value.docs.forEach((element) {
        try{
          if(element['email'] == user?.email){
            var recentSongs = [];
            try{
              recentSongs = element['recentSongs'];

              for(int i =0; i<recentSongs.length; i++){
                print('song id in try : ${recentSongs[i]['song']['id']}');
                if(songList['id'] == recentSongs[i]['song']['id']){
                  recentSongs.removeWhere((item) => item['song']['id'] == songList['id']);
                }
              }

              recentSongs.insert(0, {'song': songList, 'time': Timestamp.now()});
            }catch(e){
              print('inside catch');
              recentSongs.insert(0, {'song': songList, 'time': Timestamp.now()});
            }
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.favSongsList.indexOf(widget.id) != -1){
      isFav = true;
    }

    setAudio();

    if(user?.isAnonymous == false){
      addRecentSongs(widget.Songarray);
    }

    //  listen to states : playing, paused, stopped
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    //  listen to audi duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      print('------------------- inside duration chnaged');
      setState(() {
        duration = newDuration;
      });
    });

    //  listen to audio position
    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      print('------------------- inside position chnaged');
      setState(() {
        position = newPosition;
      });
    });
  }

  String formatTime(Duration duration){
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  Future setAudio() async{
    //  repeat song when completed
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);

    print('--------- path from firebase storage : ${widget.url}');
    audioPlayer.setUrl(widget.url);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool fav = isFav;
    print('-------------------${widget.name}');
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.grey[300],
        title: Padding(
          padding: EdgeInsets.only(right: 30),
          child: Center(
            child: Text(
              '${widget.name}',
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: Colors.grey[700]
              ),
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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 450,
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage('${widget.image}'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: widget.name.length > 20 ? widget.name.substring(0, 22)+'...' : widget.name,
                    // text: widget.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        // overflow: TextOverflow.clip,
                        fontSize: 27,
                        color: Colors.grey[700]
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '\n${widget.singer}',
                        style: TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.grey[500]
                        ),
                      ),
                    ],
                  ),
                ),
                user?.isAnonymous == false ?
                GestureDetector(
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.redAccent : Colors.grey[500],
                    size: 30,
                  ),
                  onTap: (){
                    db.collection('songs').doc(widget.id).update({
                      'isFav': !fav,
                    });
                    // add song to fav list
                    addFavSongs('favSongs', widget.id, widget.Songarray, !fav);
                    print('value from songPlay : ${!fav}');
                    setState(() {
                      fav = !fav;
                      isFav = fav;
                    });
                  },
                ) :
                    SizedBox(width: 5,),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Slider(
            activeColor: Colors.white,
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (value) async{
              final position = Duration(seconds: value.toInt());
              await audioPlayer.seek(position);

              //  optionally: play audio if was paused
              await audioPlayer.resume();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(position)),
                Text(formatTime(duration)),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.deepPurple,
            radius: 35,
            child: IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              iconSize: 50,
              onPressed: () async{
                if(isPlaying){
                  await audioPlayer.pause();
                  print('listen time : ${formatTime(position).split(':')[0]}');

                  if(user?.isAnonymous == false){
                    //update diary status on profile
                    updateStatus('listen_count', formatTime(position).split(':')[0]);
                  }
                }else{
                  audioPlayer.resume();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
