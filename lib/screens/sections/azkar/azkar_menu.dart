import 'package:flutter/material.dart';

import '../../../Custom_Widget/custom_drawer.dart';
import '../../../Custom_Widget/notifications.dart';
import 'morning.dart';
class AzkarMenu extends StatefulWidget {
  const AzkarMenu({Key? key, required this.email, required this.userName}) : super(key: key);

  final String email;
  final String userName;

  @override
  State<AzkarMenu> createState() => _AzkarMenuState();
}

class _AzkarMenuState extends State<AzkarMenu> {

  List menu =[
    'أذكار الصباح',
    'أذكار المساء',
    'أذكار الاستيقاظ',
    'أذكار النوم',
    'أذكار الصلاة',
    'المسبحة',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: const IconThemeData(color: Color.fromRGBO(215, 190, 105, 1),size: 30),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()),);
              },
              icon: Icon(Icons.notifications_none)),
          PopupMenuButton<int>(
            icon: Icon(
              Icons.more_vert,
              color: Color.fromRGBO(215, 190, 105, 1),
            ),
            color: Theme.of(context).backgroundColor,
            position: PopupMenuPosition.under,
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    const Icon(Icons.settings_outlined,size: 20,),
                    const SizedBox(width:10),
                    const Text("Settings"),
                  ],
                ),
              ),
            ],
            onSelected: (value) async{
              switch (value) {
                case 1:
                  break;
              }
            },
          ),
        ],
      ),
      drawer: CustomDrawer(userName: widget.userName,email: widget.email),
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
                    itemCount: menu.length,
                    itemBuilder: (BuildContext ctx,int i){
                      return Card(
                        color: Theme.of(context).backgroundColor,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                menu[i],
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.right,
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MorningThiker()),);
                              },
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
