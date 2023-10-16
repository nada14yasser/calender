import 'package:flutter/material.dart';
import 'package:flutter_price_slider/flutter_price_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Custom_Widget/custom_drawer.dart';
import '../../Custom_Widget/notifications.dart';

class Moods extends StatefulWidget {
  const Moods({Key? key, required this.email, required this.userName}) : super(key: key);

  final String email;
  final String userName;

  @override
  State<Moods> createState() => _MoodsState();
}

class _MoodsState extends State<Moods> {

  int _selectedIconIndex = -1; // Initially no icon is selected

  void selectedEmojy(int index) {
    setState(() {
      _selectedIconIndex = index;
    });
  }
  List emojy =[
    Text('😭',style: TextStyle(fontSize: 30),),
    Text('😥',style: TextStyle(fontSize: 30),),
    Text('😑',style: TextStyle(fontSize: 30),),
    Text('🙂',style: TextStyle(fontSize: 30),),
    Text('😃',style: TextStyle(fontSize: 30),),
  ];
  double percentage = 0.5;

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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(AppLocalizations.of(context).howmindset,style: TextStyle(color: Color.fromRGBO(215, 190, 105, 1),fontWeight: FontWeight.bold,fontSize:20),),
                  ],
                ),
                SizedBox(height:20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context).negative,style: TextStyle(fontSize: percentage==0.0||percentage==0.25?20:15),),
                    SizedBox(width: 25,),
                    FlutterPriceSlider(
                      width: 120,
                      selectedBoxColor: Color.fromRGBO(215, 190, 105, 1),
                      unselectedBoxColor: Color(0xFFf9f9f9),
                      selectedTextColor: Color(0xFF000000),
                      unselectedTextColor: Color(0XFF7d8896),
                      onSelected: (proportion) {
                        setState(() {
                          percentage = proportion;
                        });
                        print("onSelected: $percentage");
                      },
                    ),
                    SizedBox(width: 25,),
                    Text(AppLocalizations.of(context).positive,style: TextStyle(fontSize: percentage==0.75||percentage==1.0?20:15)),
                  ],
                ),
                SizedBox(height:20,),
                Divider(),
                SizedBox(height:20,),
                Row(
                  children: [
                    Text(AppLocalizations.of(context).moodtracker,style: TextStyle(color: Color.fromRGBO(215, 190, 105, 1),fontWeight: FontWeight.bold,fontSize:20),),
                  ],
                ),
                SizedBox(height:10,),
                Row(
                  children: [
                    Text(AppLocalizations.of(context).selectcurrentmood,),
                  ],
                ),
                SizedBox(height:20,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 5; i++)
                      GestureDetector(
                        onTap: () => selectedEmojy(i),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: _selectedIconIndex == i ? Colors.grey.shade400 : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                              ),
                              child:emojy[i],
                            ),
                            SizedBox(width: 5,)
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
