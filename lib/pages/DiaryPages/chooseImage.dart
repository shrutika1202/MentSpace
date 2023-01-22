import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/main.dart';
import 'package:mental_health_app/pages/DiaryPages/diary.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:mental_health_app/pages/DiaryPages/viewEntry.dart';

class ChooseImage extends StatefulWidget {
  // const ChooseImage({Key? key}) : super(key: key);

  final title;
  final content;
  final mood;
  Color bg1;
  Color bg2;
  bool isForUpdate;
  var url;
  var docId;
  ChooseImage({
    required this.title,
    required this.content,
    required this.mood,
    required this.bg1,
    required this.bg2,
    this.isForUpdate = false,
    this.url,
    this.docId
});
  @override
  _ChooseImageState createState() => _ChooseImageState();
}

bool isEntryAdded = false;
bool isImageUpdated = false;

var url;
Future<void> downloadURLExample(String creationTime) async {
  var downloadURL = await FirebaseStorage.instance
      .ref()
      .child("DiaryImages/${creationTime}.jpg")
      .getDownloadURL();
  url = downloadURL;
  print('>>>>>>>>> url : ${url}');
}

class _ChooseImageState extends State<ChooseImage> {
  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    print('----------- url from chooseImage : ${widget.url}');
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
          SizedBox(height: 20,),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 30, top: 20),
              child: Text(
                'Choose an image',
                style: TextStyle(
                  letterSpacing: 3,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
          SizedBox(height: 50,),
          Container(
            height: 300,
            width: 350,
            color: Colors.white,
            // child: widget.isForUpdate && imageFile == null ?
            child: widget.url != null && imageFile == null ?
                Image.network(widget.url, fit: BoxFit.cover,)
            :(imageFile != null ?
            Image(image: XFileImage(imageFile!),fit: BoxFit.cover,) :
                Icon(Icons.image)),
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 60),
                  child: GestureDetector(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 70,
                      color: Colors.grey[600],
                    ),
                    onTap: ()async{
                      var picture = await ImagePicker().pickImage(source: ImageSource.camera);
                      setState(() {
                        imageFile = picture;
                      });
                    },
                  )
              ),
              Text(
                'OR',
                style: TextStyle(
                  letterSpacing: 2,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 60),
                  child: GestureDetector(
                    child: Icon(
                      Icons.image_outlined,
                      size: 70,
                      color: Colors.grey[600],
                    ),
                    onTap: ()async{
                      var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
                      setState(() {
                        imageFile = picture;
                      });
                    },
                  )
              ),
            ],
          ),
          SizedBox(height: 90,),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF8A64EB),
                minimumSize: Size(350, 80),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
              child: Text(
                widget.isForUpdate ? 'save' :'continue',
                style: TextStyle(
                  letterSpacing: 3,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: widget.isForUpdate ?
              ()async{
                if(!isImageUpdated){
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                var datetime = DateTime.now();
                var creation_date = DateFormat("dd MMM,yyyy").format(DateTime.now())+' '+(datetime.hour).toString()+':'+(datetime.minute).toString();
                FirebaseStorage storage = FirebaseStorage.instance;
                Reference ref = storage.ref().child('DiaryImages/${creation_date}.jpg');
                UploadTask uploadTask = ref.putFile(File(imageFile!.path));
                final TaskSnapshot downloadUrl = (await uploadTask);

                if(downloadUrl != null){
                  await downloadURLExample(creation_date);
                  FirebaseFirestore.instance.collection('DiaryEntries').doc(widget.docId).update({
                    'creationTime': creation_date,
                  });
                }

                setState(() {
                  isImageUpdated = true;
                });

                print('--------- url after update : ${url}');
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(
                        builder: (context) => new viewEntry(
                          url: url,
                          id: widget.docId,
                          title: widget.title,
                          content: widget.content,
                          creationTime: creation_date,
                          mood: widget.mood,
                          bg1: widget.bg1,
                          bg2: widget.bg2,
                        )),
                        (Route<dynamic> route) => false);
              } :
                  ()async{
                if(!isEntryAdded){
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                var datetime = DateTime.now();
                var creation_date = DateFormat("dd MMM,yyyy").format(DateTime.now())+' '+(datetime.hour).toString()+':'+(datetime.minute).toString();
                FirebaseStorage storage = FirebaseStorage.instance;
                Reference ref = storage.ref().child('DiaryImages/${creation_date}.jpg');
                UploadTask uploadTask = ref.putFile(File(imageFile!.path));
                final TaskSnapshot downloadUrl = (await uploadTask);

                if(downloadUrl != null){
                  print('-------- title from choose image : ${widget.title}');
                  FirebaseFirestore.instance.collection('DiaryEntries').add({
                    'bg1': widget.bg1.value,
                    'bg2': widget.bg2.value,
                    'content': widget.content,
                    'creationTime': creation_date,
                    'title': widget.title,
                    'mood': widget.mood
                  });
                }

                setState(() {
                  isEntryAdded = true;
                });

                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(
                        builder: (context) => new MyApp(pageIndex: 3,isSuccess: true, successMsg: 'new entry added !',)),
                        (Route<dynamic> route) => false);
              },
            ),
          ),
        ],
      ),
    );
  }
}

