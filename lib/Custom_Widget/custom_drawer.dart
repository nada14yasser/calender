import 'package:calender_project/screens/home.dart';
import 'package:calender_project/screens/sections/notes.dart';
import 'package:calender_project/screens/sections/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:calender_project/screens/sections/habits.dart';
import 'package:calender_project/screens/sections/azkar/azkar_menu.dart';
import 'package:calender_project/screens/sections/owned.dart';
import 'package:calender_project/screens/sections/prayer/prayers.dart';
import 'package:calender_project/screens/sections/tasks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Auth/Login.dart';
import '../screens/sections/moods.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key, required this.email, required this.userName}) : super(key: key);

  final String email;
  final String userName;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).backgroundColor,
      child: StatefulBuilder(
          builder: (context,state) {
            return ListView(
              children: [
                UserAccountsDrawerHeader(
                    accountName: Text('${widget.userName}'),
                    accountEmail: Text('${widget.email}'),
                    currentAccountPicture:CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).backgroundColor,
                      child: const Center(
                        child: Icon(Icons.person_outline,size: 40,),
                      ),
                    )
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_view_month),
                  title: Text(AppLocalizations.of(context).calendar),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home(email: widget.email, userName: widget.userName)),
                    );
                  },
                ),
                // ListTile(
                //   leading: const Icon(Icons.calendar_view_month),
                //   title: const Text('Month View'),
                //   onTap: (){
                //     state(() {
                //       calendarView = CalendarView.month;
                //       calendarController.view = calendarView;
                //     });
                //     Navigator.of(context).pop();
                //   },
                // ),
                // ListTile(
                //   leading: const Icon(Icons.calendar_view_week),
                //   title: const Text('Week View'),
                //   onTap: (){
                //     state(() {
                //       calendarView = CalendarView.week;
                //       calendarController.view = calendarView;
                //     });
                //     Navigator.of(context).pop();
                //   },
                // ),
                // ListTile(
                //   leading: const Icon(Icons.calendar_view_day),
                //   title: const Text('Day View'),
                //   onTap: (){
                //     state(() {
                //       calendarView = CalendarView.day;
                //       calendarController.view = calendarView;
                //     });
                //     Navigator.of(context).pop();
                //   },
                // ),
                ListTile(
                  leading: const Icon(Icons.task_alt),
                  title: Text(AppLocalizations.of(context).tasks),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Tasks(email: widget.email, userName: widget.userName)),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.note_alt_outlined),
                  title: Text(AppLocalizations.of(context).note),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Notes(email: widget.email, userName: widget.userName)),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.repeat),
                  title: Text(AppLocalizations.of(context).habits),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Habits(email: widget.email, userName: widget.userName)),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.mood),
                  title: Text(AppLocalizations.of(context).moods),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Moods(email: widget.email, userName: widget.userName)),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.monetization_on_outlined),
                  title: Text(AppLocalizations.of(context).budget),
                  onTap: (){
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => Moods()),
                    // );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.mosque_outlined),
                  title: Text(AppLocalizations.of(context).praytime),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Prayers(email: widget.email, userName: widget.userName)),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.handshake_outlined),
                  title: Text(AppLocalizations.of(context).athkar),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AzkarMenu(email: widget.email, userName: widget.userName)),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.money),
                  title: Text(AppLocalizations.of(context).zakat),
                  onTap: (){
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => Prayers()),
                    // );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.home_work_outlined),
                  title: Text(AppLocalizations.of(context).owned),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Owned(email: widget.email, userName: widget.userName)),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.family_restroom),
                  title: Text(AppLocalizations.of(context).familymemb),
                  onTap: (){
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => Prayers()),
                    // );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.health_and_safety_outlined),
                  title: Text(AppLocalizations.of(context).healthrecords),
                  onTap: (){
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => Prayers()),
                    // );
                  },
                ),
                Divider(),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: Text(AppLocalizations.of(context).settings),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Settings(email: widget.email, userName: widget.userName)),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(AppLocalizations.of(context).aboutus),
                  onTap: (){},
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(AppLocalizations.of(context).logout),
                  onTap: ()async{
                    FirebaseAuth.instance.signOut().then((value) {
                      print("Signed Out");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Login()),
                      );
                    });
                    await GoogleSignIn ().disconnect().then((value) {
                      print("Signed Out from google account");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Login()),
                      );
                    });
                  },
                )
              ],
            );
          }
      ),
    );
  }
}
