import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../Custom_Widget/custom_drawer.dart';
import '../../../provider/provider.dart';
class Settings extends StatefulWidget {
  const Settings({Key? key, required this.email, required this.userName}) : super(key: key);

  final String email;
  final String userName;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  String languageChange = 'en';

  @override
  Widget build(BuildContext context) {
    Prov chprov = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: const IconThemeData(color: Color.fromRGBO(215, 190, 105, 1),size: 30),
        elevation: 0,
      ),
      drawer: CustomDrawer(userName: widget.userName,email: widget.email),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Card(
                color: Theme.of(context).backgroundColor,
                child: ListTile(
                  leading: Icon(Icons.translate),
                  title: Text(AppLocalizations.of(context).lang,),
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      items: [
                        DropdownMenuItem<String>(value: 'en',child: Text("english")),
                        DropdownMenuItem<String>(value: 'ar',child: Text("عربي"))
                      ],
                      onChanged: (String? newvalue) {
                        chprov.changeLang(newvalue!);
                        if (kDebugMode) {
                          print(chprov.currentLang);
                        }
                        setState(() {
                          languageChange = newvalue;
                        });
                      },
                      dropdownColor: Theme.of(context).backgroundColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
