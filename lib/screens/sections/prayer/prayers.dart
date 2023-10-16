import 'package:calender_project/screens/sections/prayer/settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../Custom_Widget/custom_drawer.dart';
import '../../../Custom_Widget/notifications.dart';
import '../../../Custom_Widget/prayer_methods.dart';
import '../../../provider/prayer_settings.dart';
import '../../../provider/provider.dart';
import '../azkar/pray.dart';
import 'package:adhan/adhan.dart';

class Prayers extends StatefulWidget {
  const Prayers({Key? key, required this.email, required this.userName}) : super(key: key);

  final String email;
  final String userName;


  @override
  State<Prayers> createState() => _PrayersState();
}

class _PrayersState extends State<Prayers> {
  List month =['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
  List arMonth =['يناير', 'فبراير', 'مارس', 'ابريل', 'مايو', 'يونيه', 'يوليو', 'اغسطس', 'سبتمير', 'اكتوبر', 'نوفمبر', 'ديسمبر'];
  bool clickDone1 = false;
  bool clickDone2 = false;
  bool clickDone3 = false;
  bool clickDone4 = false;
  bool clickDone5 = false;
  bool clickDone6 = false;
  late PrayerTimes prayerTimes;
  late DateTime date;
  late Coordinates coordinates;
  late CalculationParameters params;
  late Future<void> location;
  late Madhab selectedMadhab = Madhab.shafi;
  late CalculationMethod selectedCalculationMethod = CalculationMethod.egyptian;

  void initState() {
    super.initState();
    coordinates = Coordinates (0.0,0.0);
    date = DateTime.now();
    params = selectedCalculationMethod.getParameters();
    params.madhab = selectedMadhab;
    location=_getCurrentPosition();

  }

  // Convert a DateTime to DateComponents
  DateComponents convertToComponents(DateTime dateTime) {
    return DateComponents(dateTime.year, dateTime.month, dateTime.day);
  }
  String formatTime(int hour, int minute) {
    final time = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute);
    final formattedTime = DateFormat.jm().format(time.toLocal());
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    prayerTimes = PrayerTimes (coordinates, convertToComponents(date), params);
    Prov chprov = Provider.of(context);
    final settings = Provider.of<PrayerSettings>(context);
    final calculationMethod = settings.calculationMethod;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: const IconThemeData(color: Color.fromRGBO(215, 190, 105, 1),size: 30),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Notifications()),);
              },
              icon: const Icon(Icons.notifications_none)),
          PopupMenuButton<int>(
            icon: const Icon(
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
                    Text(AppLocalizations.of(context).settings),
                  ],
                ),
              ),
            ],
            onSelected: (value) async{
              switch (value) {
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PraySettings(email: widget.email, userName: widget.userName)),
                  );
                  break;
              }
            },
          ),
        ],
      ),
      drawer: CustomDrawer(userName: widget.userName,email: widget.email),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          future: location,
          builder: (context,snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            else if (snapshot.hasError || prayerTimes == null) {
              return const Center(child: Text('Error getting location/prayer times.'));
            }
            else{
              return StatefulBuilder(
                builder: (context,state) {
                  state(() {
                    params = Provider.of<PrayerSettings>(context).calculationMethod.getParameters();
                  });
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20,right: 10),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined,size:30,color: Color.fromRGBO(215, 190, 105, 1)),
                                      const SizedBox(width: 10,),
                                      Container(
                                          height: 50,
                                          width: 290,
                                          child: Text(_currentAddress ?? "",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
                                    ],
                                  ),
                                )
                            ),
                            Center(
                              child: Text(settings.calculationMethod.toString()),
                            ),
                            const SizedBox(height: 10,),
                            SelectedMadhab(
                                selectedMadhab: selectedMadhab,
                                onChange: (Madhab? newValue) {
                                  state(() {
                                    selectedMadhab = newValue!;
                                    params.madhab = selectedMadhab; // Update Madhab
                                    final updatedPrayerTime = PrayerTimes(coordinates, convertToComponents(date), params);
                                    prayerTimes = updatedPrayerTime;
                                    print(formatTime(prayerTimes.fajr.toLocal().hour,prayerTimes.fajr.toLocal().minute));
                                    print(formatTime(prayerTimes.isha.toLocal().hour,prayerTimes.isha.toLocal().minute));
                                  });
                                },
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    date= date.add(const Duration (days: -1));
                                    setState (() {});
                                  },
                                  child: const Icon(
                                    Icons.arrow_left,
                                    size: 50,
                                  ), // Icon
                                ),
                                Text (
                                  "${date.day} ${chprov.currentLang=='en'?month[date.month - 1]:arMonth[date.month - 1]} ${date.year}",
                                  style: const TextStyle( fontSize: 20),
                                ), // Text
                                InkWell(
                                  onTap: () {
                                    date= date.add(const Duration (days: 1));
                                    setState (() {});
                                  },
                                  child: const Icon(
                                    Icons.arrow_right,
                                    size: 50,
                                  ), // Icon
                                ),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            const Divider(
                              indent: 5,
                              endIndent: 5,
                              height: 2,
                              thickness:1.2,
                            ),
                            ExpansionPanelList.radio(
                              expandedHeaderPadding: const EdgeInsets.all(0),
                               children: [
                                 ExpansionPanelRadio(
                                   value:0,
                                   backgroundColor:  Theme.of(context).backgroundColor,
                                   headerBuilder: (BuildContext context, bool isExpanded) {
                                     return ListTile(
                                       title: Row(
                                         children: [
                                           Text(formatTime(prayerTimes.fajr.toLocal().hour, prayerTimes.fajr.toLocal().minute),style: const TextStyle(fontSize: 17),),
                                           const SizedBox(width: 20,),
                                           Text(AppLocalizations.of(context).fajr,style: const TextStyle(fontSize: 20),),
                                         ],
                                       ),
                                     );
                                   },
                                   body: Padding(
                                     padding: const EdgeInsets.only(left: 20,bottom: 20,right: 20),
                                     child: Column(
                                       children: [
                                         Row(
                                           children: [
                                             InkWell(
                                               onTap: (){
                                                 setState(() {
                                                   clickDone1=!clickDone1;
                                                 });
                                               },
                                               child: CircleAvatar(
                                                 radius: 13,
                                                 backgroundColor: const Color.fromRGBO(215, 190, 105, 0.2),
                                                 child: Center(
                                                   child:clickDone1?const Icon(Icons.done,color: Color.fromRGBO(215, 190, 105, 1),size: 20,):const SizedBox(),
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(width: 20,),
                                             const Text('Prayed',style: TextStyle(fontSize: 17),),
                                             const SizedBox(width: 50,),
                                             InkWell(
                                               onTap: (){
                                                 // setState(() {
                                                 //   clickDone1=!clickDone1;
                                                 // });
                                               },
                                               child: CircleAvatar(
                                                 radius: 13,
                                                 backgroundColor: const Color.fromRGBO(215, 190, 105, 0.2),
                                                 child: Center(
                                                   child:clickDone1?const Icon(Icons.done,color: Color.fromRGBO(215, 190, 105, 1),size: 20,):const SizedBox(),
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(width: 20,),
                                             const Text('Prayed Sunnah',style: TextStyle(fontSize: 17),),
                                           ],
                                         ),
                                         const SizedBox(height: 10,),
                                         InkWell(
                                           onTap: (){
                                             Navigator.push(context, MaterialPageRoute(builder: (context) => const PrayThiker()),);
                                           },
                                           child: Padding(
                                             padding: const EdgeInsets.only(left: 40,right: 40),
                                             child: Row(
                                               children: const [
                                                 Text('Athkar',style: TextStyle(fontSize: 17),),
                                               ],
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   )
                                 ),
                                 ExpansionPanelRadio(
                                   value:1,
                                   backgroundColor:  Theme.of(context).backgroundColor,
                                   headerBuilder: (BuildContext context, bool isExpanded) {
                                     return ListTile(
                                       title: Row(
                                         children: [
                                           Text(formatTime(prayerTimes.sunrise.toLocal().hour,prayerTimes.sunrise.toLocal().minute),style: const TextStyle(fontSize: 17),),
                                           const SizedBox(width: 20,),
                                           Text(AppLocalizations.of(context).sunrise,style: const TextStyle(fontSize: 20),),
                                         ],
                                       ),
                                     );
                                   },
                                   body: Padding(
                                     padding: const EdgeInsets.only(left: 20,bottom: 20,right: 20),
                                     child: Column(
                                       children: [
                                         Row(
                                           children: [
                                             InkWell(
                                               onTap: (){
                                                 setState(() {
                                                   clickDone2=!clickDone2;
                                                 });
                                               },
                                               child: CircleAvatar(
                                                 radius: 13,
                                                 backgroundColor: const Color.fromRGBO(215, 190, 105, 0.2),
                                                 child: Center(
                                                   child:clickDone2?const Icon(Icons.done,color: Color.fromRGBO(215, 190, 105, 1),size: 20,):const SizedBox(),
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(width: 20,),
                                             const Text('Prayed',style: TextStyle(fontSize: 17),),
                                             const SizedBox(width: 50,),
                                             InkWell(
                                               onTap: (){
                                                 // setState(() {
                                                 //   clickDone2=!clickDone1;
                                                 // });
                                               },
                                               child: CircleAvatar(
                                                 radius: 13,
                                                 backgroundColor: const Color.fromRGBO(215, 190, 105, 0.2),
                                                 child: Center(
                                                   child:clickDone2?const Icon(Icons.done,color: Color.fromRGBO(215, 190, 105, 1),size: 20,):const SizedBox(),
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(width: 20,),
                                             const Text('Prayed Sunnah',style: TextStyle(fontSize: 17),),
                                           ],
                                         ),
                                         const SizedBox(height: 10,),
                                         InkWell(
                                           onTap: (){
                                             Navigator.push(context, MaterialPageRoute(builder: (context) => const PrayThiker()),);
                                           },
                                           child: Padding(
                                             padding: const EdgeInsets.only(left: 40,right: 40),
                                             child: Row(
                                               children: const [
                                                 Text('Athkar',style: TextStyle(fontSize: 17),),
                                               ],
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   )
                                 ),
                                 ExpansionPanelRadio(
                                   value:2,
                                   backgroundColor:  Theme.of(context).backgroundColor,
                                   headerBuilder: (BuildContext context, bool isExpanded) {
                                     return ListTile(
                                       title: Row(
                                         children: [
                                           Text(formatTime(prayerTimes.dhuhr.toLocal().hour, prayerTimes.dhuhr.toLocal().minute),style: const TextStyle(fontSize: 17),),
                                           const SizedBox(width: 20,),
                                           Text(AppLocalizations.of(context).dhuhr,style: const TextStyle(fontSize: 20),),
                                         ],
                                       ),
                                     );
                                   },
                                   body: Padding(
                                     padding: const EdgeInsets.only(left: 20,bottom: 20,right: 20),
                                     child: Column(
                                       children: [
                                         Row(
                                           children: [
                                             InkWell(
                                               onTap: (){
                                                 setState(() {
                                                   clickDone3=!clickDone3;
                                                 });
                                               },
                                               child: CircleAvatar(
                                                 radius: 13,
                                                 backgroundColor: const Color.fromRGBO(215, 190, 105, 0.2),
                                                 child: Center(
                                                   child:clickDone3?const Icon(Icons.done,color: Color.fromRGBO(215, 190, 105, 1),size: 20,):const SizedBox(),
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(width: 20,),
                                             const Text('Prayed',style: TextStyle(fontSize: 17),),
                                             const SizedBox(width: 50,),
                                             InkWell(
                                               onTap: (){
                                                 // setState(() {
                                                 //   clickDone3=!clickDone1;
                                                 // });
                                               },
                                               child: CircleAvatar(
                                                 radius: 13,
                                                 backgroundColor: const Color.fromRGBO(215, 190, 105, 0.2),
                                                 child: Center(
                                                   child:clickDone3?const Icon(Icons.done,color: Color.fromRGBO(215, 190, 105, 1),size: 20,):const SizedBox(),
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(width: 20,),
                                             const Text('Prayed Sunnah',style: TextStyle(fontSize: 17),),
                                           ],
                                         ),
                                         const SizedBox(height: 10,),
                                         InkWell(
                                           onTap: (){
                                             Navigator.push(context, MaterialPageRoute(builder: (context) => const PrayThiker()),);
                                           },
                                           child: Padding(
                                             padding: const EdgeInsets.only(left: 40,right: 40),
                                             child: Row(
                                               children: const [
                                                 Text('Athkar',style: TextStyle(fontSize: 17),),
                                               ],
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   )
                                 ),
                                 ExpansionPanelRadio(
                                   value:3,
                                   backgroundColor:  Theme.of(context).backgroundColor,
                                   headerBuilder: (BuildContext context, bool isExpanded) {
                                     return ListTile(
                                       title: Row(
                                         children: [
                                           Text(formatTime(prayerTimes.asr.toLocal().hour, prayerTimes.asr.toLocal().minute),style: const TextStyle(fontSize: 17),),
                                           const SizedBox(width: 20,),
                                           Text(AppLocalizations.of(context).asr,style: const TextStyle(fontSize: 20),),
                                         ],
                                       ),
                                     );
                                   },
                                   body: Padding(
                                     padding: const EdgeInsets.only(left: 20,bottom: 20,right: 20),
                                     child: Column(
                                       children: [
                                         Row(
                                           children: [
                                             InkWell(
                                               onTap: (){
                                                 setState(() {
                                                   clickDone4=!clickDone4;
                                                 });
                                               },
                                               child: CircleAvatar(
                                                 radius: 13,
                                                 backgroundColor: const Color.fromRGBO(215, 190, 105, 0.2),
                                                 child: Center(
                                                   child:clickDone4?const Icon(Icons.done,color: Color.fromRGBO(215, 190, 105, 1),size: 20,):const SizedBox(),
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(width: 20,),
                                             const Text('Prayed',style: TextStyle(fontSize: 17),),
                                             const SizedBox(width: 50,),
                                             InkWell(
                                               onTap: (){
                                                 // setState(() {
                                                 //   clickDone4=!clickDone1;
                                                 // });
                                               },
                                               child: CircleAvatar(
                                                 radius: 13,
                                                 backgroundColor: const Color.fromRGBO(215, 190, 105, 0.2),
                                                 child: Center(
                                                   child:clickDone4?const Icon(Icons.done,color: Color.fromRGBO(215, 190, 105, 1),size: 20,):const SizedBox(),
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(width: 20,),
                                             const Text('Prayed Sunnah',style: TextStyle(fontSize: 17),),
                                           ],
                                         ),
                                         const SizedBox(height: 10,),
                                         InkWell(
                                           onTap: (){
                                             Navigator.push(context, MaterialPageRoute(builder: (context) => const PrayThiker()),);
                                           },
                                           child: Padding(
                                             padding: const EdgeInsets.only(left: 40,right: 40),
                                             child: Row(
                                               children: const [
                                                 Text('Athkar',style: TextStyle(fontSize: 17),),
                                               ],
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   )
                                 ),
                                 ExpansionPanelRadio(
                                   value:4,
                                   backgroundColor:  Theme.of(context).backgroundColor,
                                   headerBuilder: (BuildContext context, bool isExpanded) {
                                     return ListTile(
                                       title:Row(
                                         children: [
                                           Text(formatTime(prayerTimes.maghrib.toLocal().hour, prayerTimes.maghrib.toLocal().minute),style: const TextStyle(fontSize: 17),),
                                           const SizedBox(width: 20,),
                                           Text(AppLocalizations.of(context).maghrib,style: const TextStyle(fontSize: 20),),
                                         ],
                                       ),
                                     );
                                   },
                                   body: Padding(
                                     padding: const EdgeInsets.only(left: 20,bottom: 20,right: 20),
                                     child: Column(
                                       children: [
                                         Row(
                                           children: [
                                             InkWell(
                                               onTap: (){
                                                 setState(() {
                                                   clickDone5=!clickDone5;
                                                 });
                                               },
                                               child: CircleAvatar(
                                                 radius: 13,
                                                 backgroundColor: const Color.fromRGBO(215, 190, 105, 0.2),
                                                 child: Center(
                                                   child:clickDone5?const Icon(Icons.done,color: Color.fromRGBO(215, 190, 105, 1),size: 20,):const SizedBox(),
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(width: 20,),
                                             const Text('Prayed',style: TextStyle(fontSize: 17),),
                                             const SizedBox(width: 50,),
                                             InkWell(
                                               onTap: (){
                                                 // setState(() {
                                                 //   clickDone5=!clickDone1;
                                                 // });
                                               },
                                               child: CircleAvatar(
                                                 radius: 13,
                                                 backgroundColor: const Color.fromRGBO(215, 190, 105, 0.2),
                                                 child: Center(
                                                   child:clickDone5?const Icon(Icons.done,color: Color.fromRGBO(215, 190, 105, 1),size: 20,):const SizedBox(),
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(width: 20,),
                                             const Text('Prayed Sunnah',style: TextStyle(fontSize: 17),),
                                           ],
                                         ),
                                         const SizedBox(height: 10,),
                                         InkWell(
                                           onTap: (){
                                             Navigator.push(context, MaterialPageRoute(builder: (context) => const PrayThiker()),);
                                           },
                                           child: Padding(
                                             padding: const EdgeInsets.only(left: 40,right: 40),
                                             child: Row(
                                               children: const [
                                                 Text('Athkar',style: TextStyle(fontSize: 17),),
                                               ],
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   )
                                 ),
                                 ExpansionPanelRadio(
                                   value:5,
                                   backgroundColor:  Theme.of(context).backgroundColor,
                                   headerBuilder: (BuildContext context, bool isExpanded) {
                                     return ListTile(
                                       title: Row(
                                         children: [
                                           Text(formatTime(prayerTimes.isha.toLocal().hour, prayerTimes.isha.toLocal().minute),style: const TextStyle(fontSize: 17),),
                                           const SizedBox(width: 20,),
                                           Text(AppLocalizations.of(context).isha,style: const TextStyle(fontSize: 20),),
                                         ],
                                       ),
                                     );
                                   },
                                   body: Padding(
                                     padding: const EdgeInsets.only(left: 20,bottom: 20,right: 20),
                                     child: Column(
                                       children: [
                                         Row(
                                           children: [
                                             InkWell(
                                               onTap: (){
                                                 setState(() {
                                                   clickDone6=!clickDone6;
                                                 });
                                               },
                                               child: CircleAvatar(
                                                 radius: 13,
                                                 backgroundColor: const Color.fromRGBO(215, 190, 105, 0.2),
                                                 child: Center(
                                                   child:clickDone6?const Icon(Icons.done,color: Color.fromRGBO(215, 190, 105, 1),size: 20,):const SizedBox(),
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(width: 20,),
                                             const Text('Prayed',style: TextStyle(fontSize: 17),),
                                             const SizedBox(width: 50,),
                                             InkWell(
                                               onTap: (){
                                                 // setState(() {
                                                 //   clickDone6=!clickDone1;
                                                 // });
                                               },
                                               child: CircleAvatar(
                                                 radius: 13,
                                                 backgroundColor: const Color.fromRGBO(215, 190, 105, 0.2),
                                                 child: Center(
                                                   child:clickDone6?const Icon(Icons.done,color: Color.fromRGBO(215, 190, 105, 1),size: 20,):const SizedBox(),
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(width: 20,),
                                             const Text('Prayed Sunnah',style: TextStyle(fontSize: 17),),
                                           ],
                                         ),
                                         const SizedBox(height: 10,),
                                         InkWell(
                                           onTap: (){
                                             Navigator.push(context, MaterialPageRoute(builder: (context) => const PrayThiker()),);
                                           },
                                           child: Padding(
                                             padding: const EdgeInsets.only(left: 40,right: 40),
                                             child: Row(
                                               children: const [
                                                 Text('Athkar',style: TextStyle(fontSize: 17),),
                                               ],
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   )
                                 ),
                               ],
                            ),
                          ],
                        ),
                      ),
                      Center(child: Icon(Icons.mosque_outlined,size:200.sp,color: const Color.fromRGBO(215, 190, 105, 0.25))),
                    ],
                  );
                }
              );
            }
          }
        )
      ),
    );
  }
  Position? _currentPosition;
  String? _currentAddress;
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
    coordinates = Coordinates (_currentPosition!.latitude, _currentPosition!.longitude);
    date = DateTime.now();
    params = CalculationMethod.egyptian.getParameters();
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.locality},${place.administrativeArea}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
}

