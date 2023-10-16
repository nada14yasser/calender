import 'package:flutter/material.dart';
class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  List notifications =[
    'aaaaaaaaaaaaaa',
    'bbbbbbbbbb',
    'cccccccc',
    'ddddddddd',
    'eeeeeeeeee',
    'fffffffffff',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: const IconThemeData(color: Color.fromRGBO(215, 190, 105, 1),size: 30),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.89,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (BuildContext ctx,int i){
                      return Card(
                        color: Theme.of(context).backgroundColor,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                notifications[i],
                                style: TextStyle(fontSize: 20),
                              ),
                              trailing: IconButton(
                                onPressed: (){},
                                icon: Icon(Icons.more_horiz),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
