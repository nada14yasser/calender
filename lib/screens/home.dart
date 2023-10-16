import 'package:calender_project/Custom_Widget/calendar.dart';
import 'package:calender_project/Custom_Widget/notifications.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../Custom_Widget/custom_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.email, required this.userName}) : super(key: key);

  final String email;
  final String userName;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  CalendarView calendarView = CalendarView.month;
  CalendarController calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                      Text(AppLocalizations.of(context).settings,),
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
          bottom: TabBar(
            labelColor: Color.fromRGBO(215, 190, 105, 1),
            unselectedLabelColor: Colors.black,
            indicatorWeight:3,
            isScrollable: true,
            tabs: [
              Tab(text: AppLocalizations.of(context).month,),
              Tab(text: AppLocalizations.of(context).week,),
              Tab(text: AppLocalizations.of(context).day,),
            ],
          ),
        ),
        drawer: CustomDrawer(userName: widget.userName,email: widget.email),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: TabBarView(
                children: [
                  CalendarViewTab(view: calendarView),
                  CalendarViewTab(view: CalendarView.week),
                  CalendarViewTab(view: CalendarView.day),
                ]
            ),
          ),
        ),
      ),
    );
  }
}



