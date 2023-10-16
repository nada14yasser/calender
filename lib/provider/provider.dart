import 'package:flutter/cupertino.dart';

class Prov extends ChangeNotifier{
  String currentLang ="en";
  void changeLang(String language){
    currentLang= language;
    notifyListeners();
  }
}
