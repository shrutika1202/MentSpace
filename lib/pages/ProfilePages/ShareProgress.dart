import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareProgress extends StatefulWidget {
  const ShareProgress({Key? key}) : super(key: key);

  @override
  _ShareProgressState createState() => _ShareProgressState();
}


class _ShareProgressState extends State<ShareProgress> {
  final user = FirebaseAuth.instance.currentUser;
  var Uinfo;
  var successStatus = [];
  int cardNum = 0;

  Future<HashMap<String, dynamic>> getEventsFromFirestore() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    QuerySnapshot eventsQuery = await ref
        .where("email", isEqualTo: user?.email)
        .get();

    HashMap<String, dynamic> eventsHashMap = new HashMap<String, dynamic>();
    eventsQuery.docs.forEach((element) {
      eventsHashMap.addAll({'status': element['status']});
    });

    setState(() {
      Uinfo = eventsHashMap;
      successStatus = [
        {'count': Uinfo['status']['tasks'], 'title': ' Activities \nCompleted', 'icon': 'task'},
        {'count': '${Uinfo['status']['listen_count']}m', 'title': 'Listen \n Time', 'icon': 'song'},
        {'count': Uinfo['status']['journal'], 'title': 'Journal \nEntries', 'icon': 'diary'},
        {'count': Uinfo['status']['check_in'], 'title': 'Checked \n      In', 'icon': 'check-in'},
      ];
    });

    return eventsHashMap;
  }

  Future saveAndShare(Uint8List bytes) async{
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/status.png');
    image.writeAsBytesSync(bytes);

    final text = 'sharing my progress from MentSpace';
    await Share.shareFiles([image.path], text: text);
  }

  // display in app
  Widget carousalCard(int i, bool isForScreenShot) {
    DateTime now = new DateTime.now();
    String result2 = Jiffy(now).format('MMM do yyyy');
    return Container(
      height: 400,
      width: 500,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://tse4.mm.bing.net/th?id=OIP.jpVWEzVPu2npxBIg-Vi2VQHaJB&pid=Api&P=0'),
          fit: BoxFit.cover
        )
      ),
      child: Column(
        children: [
          i == cardNum && isForScreenShot == false ? Align(
            alignment: Alignment.topRight,
            child: Padding(
                padding: EdgeInsets.only(right: 10, top: 10),
                child: Icon(Icons.check_circle, color: Colors.lightGreenAccent, size: 30,)
            ),
          ): SizedBox(height: 25,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 45, bottom: 40, left: 45, top: 10),
              child: SizedBox(
                height: 180,
                width: 400,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 2,
                  color: Colors.grey[300],
                  child: Uinfo != null && successStatus != [] ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${result2}', style: TextStyle(color: Colors.grey[600]),),
                            // SizedBox(width: 70,),
                            successStatus[i]['icon'] == 'task'
                                ? Icon(Icons.work_outline_outlined, size: 30, color: Colors.deepPurple,)
                                : (successStatus[i]['icon'] == 'song'
                                ? Icon(Icons.music_note_outlined, size: 30, color: Colors.deepPurple,)
                                : (successStatus[i]['icon'] == 'diary'
                                ? Icon(Icons.bookmarks_outlined, size: 30, color: Colors.deepPurple,)
                                : Icon(Icons.emoji_emotions_outlined, size: 30, color: Colors.deepPurple,))),
                          ],
                        ),
                      ),
                      SizedBox(height: 90,),
                      successStatus[i]['icon'] == 'task'
                          ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text('I have completed ${successStatus == [] ? 0 : successStatus[i]['count']} activities, \nto boost my mood', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                          )
                          : (successStatus[i]['icon'] == 'song'
                          ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text('I had spent  ${successStatus == [] ? 0 : successStatus[i]['count']} time, \nlistening to music', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
                          )
                          : (successStatus[i]['icon'] == 'diary'
                          ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text('I have completed my ${successStatus == [] ? 0 : successStatus[i]['count']} journal entries today', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
                          )
                          : Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text('I have tracked my mental health ${successStatus == [] ? 0 : successStatus[i]['count']} times, \n till now', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
                          ))),

                    ],
                  ) : Center(child: CircularProgressIndicator(),),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

  // widget to be shared
  Widget carousalShareCard(int i, bool isForScreenShot) {
    return Container(
        height: 400,
        width: 400,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage('https://tse4.mm.bing.net/th?id=OIP.jpVWEzVPu2npxBIg-Vi2VQHaJB&pid=Api&P=0'),
              fit: BoxFit.cover
            )
        ),
        child: Column(
          children: [
            i == cardNum && isForScreenShot == false ? Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: EdgeInsets.only(right: 10, top: 10),
                  child: Icon(Icons.check_circle, color: Colors.lightGreenAccent, size: 30,)
              ),
            ): SizedBox(height: 25,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 45, bottom: 40, left: 45, top: 10),
                child: SizedBox(
                  height: 180,
                  width: 230,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 2,
                    color: Colors.grey[300],
                    child: Uinfo != null && successStatus != [] ? Column(
                      children: [
                        SizedBox(height: 80,),
                        Text(
                          '${successStatus == [] ? 0 : successStatus[i]['count']}',
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800]
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          '${successStatus == [] ? 'activities' : successStatus[i]['title']}',
                          style: TextStyle(
                              fontSize: 25
                          ),
                        ),
                        SizedBox(height: 20,),
                        successStatus[i]['icon'] == 'task'
                            ? Icon(Icons.work_outline_outlined, size: 50, color: Colors.grey[500],)
                            : (successStatus[i]['icon'] == 'song'
                            ? Icon(Icons.music_note_outlined, size: 50, color: Colors.grey[500],)
                            : (successStatus[i]['icon'] == 'diary'
                            ? Icon(Icons.bookmarks_outlined, size: 50, color: Colors.grey[500],)
                            : Icon(Icons.emoji_emotions_outlined, size: 50, color: Colors.grey[500],))),
                      ],
                    ) : Center(child: CircularProgressIndicator(),),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEventsFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    // getEventsFromFirestore();
    final controller = ScreenshotController();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Share your progress with friends',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey[800],
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 20,),
            ListView(
              shrinkWrap: true,
              children: [
                CarouselSlider(
                  items: [
                    //status cards of Slider
                    for(int i=0; i< 4; i++)
                      GestureDetector(
                          child: carousalCard(i, false),
                        onTap: (){
                            setState(() {
                              cardNum = i;
                            });
                        },
                      )
                      // Screenshot(
                      //   controller: controller,
                      //   child:
                      // ),

                  ],

                  //Slider Container properties
                  options: CarouselOptions(
                    height: 500,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50,),
            SizedBox(
              height: 80,
              width: 400,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurpleAccent,
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)
                    )
                ),
                child: Text(
                  'Share',
                  style: TextStyle(
                      fontSize: 19,
                      color: Colors.white
                  ),
                ),
                onPressed: () async{
                  final image = await controller.captureFromWidget(carousalCard(cardNum, true));
                  saveAndShare(image!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
