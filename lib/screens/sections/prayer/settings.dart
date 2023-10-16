import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Custom_Widget/Buttons.dart';
import '../../../Custom_Widget/custom_drawer.dart';
import '../../../Custom_Widget/notifications.dart';
import '../../../Custom_Widget/prayer_methods.dart';
import '../../../provider/prayer_settings.dart';
class PraySettings extends StatefulWidget {
  const PraySettings({Key? key, required this.email, required this.userName}) : super(key: key);

  final String email;
  final String userName;

  @override
  State<PraySettings> createState() => _PraySettingsState();
}

class _PraySettingsState extends State<PraySettings> {

  late PrayerTimes prayerTimes;
  late DateTime date;
  late Coordinates coordinates;
  late CalculationParameters params;
  late Madhab selectedMadhab = Madhab.shafi;
  late CalculationMethod selectedCalculationMethod = Provider.of<PrayerSettings>(context, listen: false).calculationMethod;

  void initState() {
    super.initState();
    coordinates = Coordinates (0.0,0.0);
    date = DateTime.now();
    params = selectedCalculationMethod.getParameters();
    params.madhab = selectedMadhab;
  }
  // Convert a DateTime to DateComponents
  DateComponents convertToComponents(DateTime dateTime) {
    return DateComponents(dateTime.year, dateTime.month, dateTime.day);
  }

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
        ],
      ),
      drawer: CustomDrawer(userName: widget.userName,email: widget.email),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StatefulBuilder(
          builder: (context,state) {
            return Column(
              children: [
                SelectedCalculationMethod(
                    selectedCalculationMethod: selectedCalculationMethod,
                    onChange:(CalculationMethod? newValue){
                      state(() {
                        selectedCalculationMethod = newValue!;
                        final params = selectedCalculationMethod.getParameters();
                        final updatedPrayerTime = PrayerTimes(coordinates, convertToComponents(date), params);
                        prayerTimes = updatedPrayerTime;
                      });
                    }
                ),
                ButtonAsText(
                  onPressed: () {
                    final settings = Provider.of<PrayerSettings>(context, listen: false);
                    settings.setCalculationMethod(selectedCalculationMethod);
                    print(selectedCalculationMethod.name);
                    Navigator.pop(context);
                  },
                  text:'Save',
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}

