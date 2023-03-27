import 'package:flutter/material.dart';
import 'package:mental_health_app/pages/ExtraFiles/AccountOperations.dart';

class EditAvatar extends StatefulWidget {
  // const EditAvatar({Key? key}) : super(key: key);

  var avatar;
  EditAvatar({
    required this.avatar
  });
  @override
  _EditAvatarState createState() => _EditAvatarState();
}

final avatar = ['fox', 'frog', 'bear', 'hippo', 'owl', 'rabbit'];
final selected = [100];

class _EditAvatarState extends State<EditAvatar> {
  @override
  Widget build(BuildContext context) {
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
        title: Text(
            'select an avatar',
          style: TextStyle(
            letterSpacing: 1,
            color: Colors.grey[700]
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/avatar/${selected[0] == 100 ? widget.avatar : avatar[selected[0]]}.png'),
              backgroundColor: Colors.white,
              radius: 60,
            ),
          ),
          SizedBox(height: 20,),
          Divider(
            height: 5,
            thickness: 2,
            indent: 90,
            endIndent: 90,
          ),
          // SizedBox(height: 20,),
          Padding(
            padding: EdgeInsets.only(left: 25, right: 35,),
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
                      for(int i=0; i<avatar.length-1; i++)
                        Padding(
                          padding: EdgeInsets.only(left: 30, top: 30),
                          child: GestureDetector(
                            child: selected[0] == i ? CircleAvatar(
                              radius: 42,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: AssetImage('assets/avatar/${avatar[i]}.png'),
                                // child: Icon(
                                //   Icons.check,
                                //   color: Colors.white,
                                //   size: 35,
                                // ),
                              ),
                            ) : CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage('assets/avatar/${avatar[i]}.png'),
                            ),
                            onTap: (){
                              setState(() {
                                selected[0] = i;
                                widget.avatar = selected[0];
                              });
                              print('--------- isSelected : ${selected[0]}');
                              updateAccount('avatar', avatar[i]);
                            },
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
    );
  }
}
