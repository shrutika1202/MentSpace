import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/pages/TaskPages/taskOperations.dart';
import 'package:url_launcher/url_launcher.dart';

final db = FirebaseFirestore.instance;

class TaskDespPage extends StatefulWidget {
  // const TaskDespPage({Key? key}) : super(key: key);

  var Uid;
  String title;
  String desp;
  bool isCompleted;
  var rem;
  bool isFav;
  var url;
  var ref;
  int index;
  TaskDespPage({
    required this.Uid,
    required this.title,
    required this.desp,
    required this.isCompleted,
    required this.url,
    required this.rem,
    required this.isFav,
    required this.ref,
    required this.index
  });

  @override
  _TaskDespPageState createState() => _TaskDespPageState();
}

class _TaskDespPageState extends State<TaskDespPage> {
  @override
  Widget build(BuildContext context) {
    print('----- ref : ${widget.ref}');
    bool fav = widget.isFav;

    return Scaffold(
      backgroundColor: Colors.deepPurple,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 150,
              expandedHeight: 240.0,
              floating: true,
              snap: true,
              pinned: true,
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      child: Image.network(
                        '${widget.url}',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress){
                          if(loadingProgress == null){
                            return child;
                          }else{
                            return Center(
                              child: Text(
                                  'Loading....',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.grey[500],
                                  letterSpacing: 2
                                ),
                              ),
                            );
                          }
                        },
                        // errorBuilder: (context, error, stackTrace){
                        //   Text('ERROR');
                        // },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 15, top: 25),
                              child: Text(
                                '${widget.title}',
                                softWrap: false,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  letterSpacing: 3,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 60,),
                        user?.isAnonymous == false
                            ? Padding(
                          padding: EdgeInsets.only(top: 25, right: 20),
                          child: GestureDetector(
                            child: Icon(
                              widget.isFav ? Icons.favorite : Icons.favorite_border,
                              color: widget.isFav ? Colors.redAccent : Colors.white,
                              size: 30,
                            ),
                            onTap: () async{
                              if(widget.index != -1)
                                await updateTask(widget.title, widget.index, !fav, 'isFav');
                              setState(() {
                                fav = !fav;
                                widget.isFav = fav;
                              });
                            },
                          ),
                        ) : SizedBox(width: 10,),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              color: Colors.grey[400],
                            ),
                            SizedBox(width: 5,),
                            Text(
                              'duration : ${widget.rem} min',
                              style: TextStyle(
                                letterSpacing: 3,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        )
                      ),
                    ),
                    SizedBox(height: 30,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          '${widget.desp}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: [
                            Icon(
                                Icons.attach_file_rounded,
                              color: Colors.grey[400],
                            ),
                            SizedBox(width: 5,),
                            Text(
                              'Reference links',
                              style: TextStyle(
                                letterSpacing: 3,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: 10,),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: (widget.ref).length,
                      itemBuilder: (context, index){
                        var refItem = (widget.ref)[index];
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding: EdgeInsets.only(left: 25, right: 20),
                              child: new InkWell(
                                child: Text(
                                  '\n${refItem}',
                                  style: TextStyle(
                                      color: Colors.lightBlue,
                                      decoration: TextDecoration.underline
                                  ),
                                ),
                                onTap: (){
                                  launch(refItem);
                                },
                              )
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 50,),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}



