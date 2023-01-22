
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SongPlayPage extends StatefulWidget {
  // const SongPlayPage({Key? key}) : super(key: key);

  var id;
  var name;
  var singer;
  var image;
  bool isFav;
  SongPlayPage({
    required this.id,
    required this.name,
    required this.singer,
    required this.image,
    required this.isFav
});
  @override
  _SongPlayPageState createState() => _SongPlayPageState();
}

final db = FirebaseFirestore.instance;

class _SongPlayPageState extends State<SongPlayPage> {
  @override
  Widget build(BuildContext context) {
    bool fav = widget.isFav;
    print('-------------------${widget.name}');
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.teal,
        title: Padding(
          padding: EdgeInsets.only(right: 30),
          child: Center(
            child: Text(
              '${widget.name}',
              overflow: TextOverflow.clip,
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
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
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
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: widget.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 27,
                        color: Colors.white
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '\n${widget.singer}',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400]
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    widget.isFav ? Icons.favorite : Icons.favorite_border,
                    color: widget.isFav ? Colors.redAccent : Colors.white,
                    size: 30,
                  ),
                  onTap: (){
                    db.collection('songs').doc(widget.id).update({
                      'isFav': !fav,
                    });
                    setState(() {
                      fav = !fav;
                      widget.isFav = fav;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 30,),
        ],
      ),
    );
  }
}
