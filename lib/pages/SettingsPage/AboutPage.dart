import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        title: Text(
          'About',
          style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w500
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
        children: [
          SizedBox(height: 40,),
          SizedBox(
            height: 130,
            width: 130,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset('assets/logo/MentSpace.png',),
            ),
          ),
          SizedBox(height: 5,),
          Text('peacifier', style: TextStyle(letterSpacing: 1,),),
          SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
            child: Text('       Analyse your mood and improve it with our recommende tasks.\n'
                '       Everyone knows, music is the best therapy. We help you to find '
                'perfect match to your mood. \n       Analysing and writting things down helps a lot to make clear conclusions.\n'
                '       Build a habit of journaling with us and be in peace with your life',
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 2
            ),),
          ),
          SizedBox(height: 15,),
          Divider(
            height: 5,
            thickness: 2,
            indent: 17,
            endIndent: 17,
          ),
          SizedBox(height: 20,),
          Text('Follow us'),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset('assets/images/facebook.png'),
                  ),
                ),
                onTap: (){
                  launch('');
                },
              ),
              SizedBox(width: 15,),
              InkWell(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset('assets/images/instagram.png'),
                  ),
                ),
                onTap: (){
                  launch('');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ServiceTerms extends StatefulWidget {
  const ServiceTerms({Key? key}) : super(key: key);

  @override
  _ServiceTermsState createState() => _ServiceTermsState();
}

class _ServiceTermsState extends State<ServiceTerms> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

