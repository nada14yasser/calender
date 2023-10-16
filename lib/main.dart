import 'package:calender_project/provider/prayer_settings.dart';
import 'package:calender_project/provider/provider.dart';
import 'package:calender_project/screens/sections/prayer/settings.dart';
import 'package:calender_project/screens/sections/settings/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'Auth/Login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Prov()),
            ChangeNotifierProvider(create: (context) => PrayerSettings()),
          ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return  MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: MaterialColor(Color.fromRGBO(215, 190, 105, 1).value, <int, Color>{
              50: Color.fromRGBO(215, 190, 105, 1),
              100: Color.fromRGBO(215, 190, 105, 1),
              200: Color.fromRGBO(215, 190, 105, 1),
              300: Color.fromRGBO(215, 190, 105, 1),
              400: Color.fromRGBO(215, 190, 105, 1),
              500: Color.fromRGBO(215, 190, 105, 1),
              600: Color.fromRGBO(215, 190, 105, 1),
              700: Color.fromRGBO(215, 190, 105, 1),
              800: Color.fromRGBO(215, 190, 105, 1),
              900: Color.fromRGBO(215, 190, 105, 1),
            },),
            backgroundColor: Color.fromRGBO(250,240,230,1),
            scaffoldBackgroundColor: Color.fromRGBO(250,240,230,1),
            textTheme: TextTheme(
                titleLarge: TextStyle(color: Color.fromRGBO(215, 190, 105, 1),fontWeight: FontWeight.bold,fontSize: 35),
                // titleMedium: TextStyle(color: Color.fromRGBO(215, 190, 105, 1),fontWeight: FontWeight.bold,fontSize: 25),
                // titleSmall: TextStyle(color: Colors.black,fontSize: 25),
            ),
            // Color.fromRGBO(215, 190, 105, 1),
          ),
          localizationsDelegates: const[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          locale: Locale(Provider.of<Prov>(context).currentLang),
          home: Login(),
        );
      }
    );
  }
}