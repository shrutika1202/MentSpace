import 'package:flutter/material.dart';
import 'package:mental_health_app/pages/ExtraFiles/AccountOperations.dart';

class CheckInTime extends StatefulWidget {
  // const CheckInTime({Key? key}) : super(key: key);

  var checkIn_time;
  CheckInTime({
    required this.checkIn_time
  });
  @override
  _CheckInTimeState createState() => _CheckInTimeState();
}

class _CheckInTimeState extends State<CheckInTime> {
  var checkInDetails = [
    {'title': 'Morning', 'time': '6:00AM - 10:00AM'},
    {'title': 'Day', 'time': '10:00AM - 5:00PM'},
    {'title': 'Evening', 'time': '5:00PM - 8:00PM'},
    {'title': 'Night', 'time': '8:00PM - 11:00PM'},
  ];
  late var selected = widget.checkIn_time;

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
      ),
      body: Column(
        children: [
          SizedBox(height: 40,),
          Center(
            child: Text(
              'Choose a Check-in time',
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
          SizedBox(height: 25,),
          for(int i=0; i<checkInDetails.length; i++)
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: GestureDetector(
                child: Card(
                  color: selected == checkInDetails[i]['title'] ? Colors.grey[300] : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.grey[500],
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 15,
                          child: checkInDetails[i]['title'] == 'Morning'
                              ? Icon(Icons.cloud, size: 20)
                              : (checkInDetails[i]['title'] == 'Day'
                              ? Icon(Icons.wb_sunny, size: 20)
                              : (checkInDetails[i]['title'] == 'Evening'
                              ? Icon(Icons.nights_stay, size: 20)
                              : Icon(Icons.nightlight_round, size: 20,))),
                        ),
                      ),
                      title: Text(
                        '${checkInDetails[i]['title']}',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1
                        ),
                      ),
                      subtitle: Text('${checkInDetails[i]['time']}'),
                    ),
                  ),
                ),
                onTap: (){
                  setState(() {
                    selected = checkInDetails[i]['title']!;
                  });
                //  update selcted checkin time in db
                  print('-------- selected time : ${selected}');
                  updateAccount('check-in_time', '${selected}');
                },
              ),
            ),
        ],
      ),
    );
  }
}
