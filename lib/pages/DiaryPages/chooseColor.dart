import 'package:flutter/material.dart';

import 'createEntry.dart';

class ChooseColor extends StatefulWidget {
  // const ChooseColor({Key? key}) : super(key: key);

  var title;
  var content;
  var url;
  ChooseColor({
    this.title,
    this.url,
    this.content
  });
  @override
  _ChooseColorState createState() => _ChooseColorState();
}

final colors = [
  [0xFF2F5CFF, 0xFFDBF4FF],
  [0xFFFF9A9E, 0xFFFECFEF],
  [0xFF00B4DB, 0xFF0083B0],
  [0xFF4B6CB7, 0xFF182848],
  [0xFFACB6E5, 0xFF86FDE8],
  [0xFF06BEB6, 0xFF48B1BF],
  [0xFF9796F0, 0xFFFBC7D4],
  [0xFFA18CD1, 0xFFFBC2EB],
  [0xFFFFCDA5, 0xFFEE4D5F],
  [0xFFECFDFF, 0xFF41F0D1],
  [0xFF64E8DE, 0xFF8A64EB],
  [0xFFFFCDA5, 0xFFEE4D5F],
  [0xFF342E2A, 0xFF425C76]
];
final selected = [100];

class _ChooseColorState extends State<ChooseColor> {
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
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 30, top: 50),
            child: Text(
              'select a color for your diary entry',
              style: TextStyle(
                  letterSpacing: 3,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 20),
            child: Container(
              height: 500,
              width: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                // color: Colors.grey[400],
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: SingleChildScrollView(
                  child: Wrap(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for(int i=0; i<colors.length-1; i++)
                        Padding(
                          padding: EdgeInsets.only(left: 20, top: 15),
                          child: GestureDetector(
                            child: selected[0] == i ? CircleAvatar(
                              radius: 40,
                              backgroundColor: Color(colors[i][0]),
                              child: Icon(
                                Icons.check,
                                color: Colors.black45,
                                size: 35,

                              ),
                            ) : CircleAvatar(
                              radius: 40,
                              backgroundColor: Color(colors[i][0]),
                            ),
                            onTap: (){
                              setState(() {
                                selected[0] = i;
                              });
                              print('--------- isSelected : ${selected[0]}');
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF8A64EB),
              minimumSize: Size(350, 80),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
              ),
            ),
            child: Text(
                'continue',
              style: TextStyle(
                letterSpacing: 3,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            onPressed: selected[0] == 100
            ? null
            : (){
              print('----- color from choose color : ${colors[selected[0]][0].runtimeType}');
              print('-------- title from color : ${widget.title != null ? widget.title : null}');
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => new CreateEntry(
                    bg1: Color(colors[selected[0]][0]),
                    bg2: Color(colors[selected[0]][1]),
                    title: widget.title != null ? widget.title : null,
                    content: widget.content != null ? widget.content : null,
                    url: widget.url != null ? widget.url : null,
                  ))
              );
            },
          ),
        ],
      ),
    );
  }
}


// CircleAvatar(
// child: Icon(Icons.favorite),
// ),