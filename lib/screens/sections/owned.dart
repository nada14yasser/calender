import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Custom_Widget/custom_drawer.dart';
import '../../Custom_Widget/notifications.dart';
class Owned extends StatefulWidget {
  const Owned({Key? key, required this.email, required this.userName}) : super(key: key);

  final String email;
  final String userName;

  @override
  State<Owned> createState() => _OwnedState();
}

class _OwnedState extends State<Owned> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
          bottom: TabBar(
            labelColor: Color.fromRGBO(215, 190, 105, 1),
            unselectedLabelColor: Colors.black,
            indicatorWeight:3,
            tabs: [
              Tab(text: AppLocalizations.of(context).properties),
              Tab(text: AppLocalizations.of(context).investments),
              Tab(text: AppLocalizations.of(context).bankaccount),
              Tab(text: AppLocalizations.of(context).debitscredits),
            ],
          ),
        ),
        drawer: CustomDrawer(userName: widget.userName,email: widget.email),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            children: [
              Center(
                child: Text(AppLocalizations.of(context).tapaddproperties,
                  style: TextStyle(fontSize: 30,color: Colors.grey.shade400),),
              ),
              Center(
                child: Text(AppLocalizations.of(context).tapaddinvestments,
                  style: TextStyle(fontSize: 30,color: Colors.grey.shade400),),
              ),
              Center(
                child: Text(AppLocalizations.of(context).tapaddbankaccount,
                  style: TextStyle(fontSize: 30,color: Colors.grey.shade400),),
              ),
              Center(
                child: Text(AppLocalizations.of(context).tapadddebitscredits,
                  style: TextStyle(fontSize: 30,color: Colors.grey.shade400),),
              ),
            ],
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){},
          child: Icon(Icons.add),
          foregroundColor: Color.fromRGBO(250,240,230,1),
        ),
      ),
    );
  }
}
