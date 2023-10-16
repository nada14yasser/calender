import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectedCalculationMethod extends StatelessWidget {
  const SelectedCalculationMethod({Key? key, this.onChange, required this.selectedCalculationMethod}) : super(key: key);

  final dynamic onChange;
  final CalculationMethod selectedCalculationMethod;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: Row(
        children: [
          Column(
            children: [
            Row(
          children: const [
          Text('select Calculation Method',style: TextStyle(fontSize: 20),),
          ],
        ),
            DropdownButtonHideUnderline(
        child: DropdownButton<CalculationMethod>(
          value: selectedCalculationMethod,
          dropdownColor: Theme.of(context).backgroundColor,
          onChanged: onChange,
          items: [
            DropdownMenuItem<CalculationMethod>(value: CalculationMethod.egyptian,child: Text("egyptian")),
            DropdownMenuItem<CalculationMethod>(value: CalculationMethod.dubai,child: Text("dubai")),
            DropdownMenuItem<CalculationMethod>(value: CalculationMethod.umm_al_qura,child: Text("umm_al_qura")),
            DropdownMenuItem<CalculationMethod>(value: CalculationMethod.karachi,child: Text("karachi")),
            DropdownMenuItem<CalculationMethod>(value: CalculationMethod.kuwait,child: Text("kuwait")),
            DropdownMenuItem<CalculationMethod>(value: CalculationMethod.moon_sighting_committee,child: Text("moon_sighting_committee")),
            DropdownMenuItem<CalculationMethod>(value: CalculationMethod.north_america,child: Text("north_america")),
            DropdownMenuItem<CalculationMethod>(value: CalculationMethod.muslim_world_league,child: Text("muslim_world_league")),
            DropdownMenuItem<CalculationMethod>(value: CalculationMethod.qatar,child: Text("qatar")),
            DropdownMenuItem<CalculationMethod>(value: CalculationMethod.singapore,child: Text("singapore")),
            DropdownMenuItem<CalculationMethod>(value: CalculationMethod.tehran,child: Text("tehran")),
            DropdownMenuItem<CalculationMethod>(value: CalculationMethod.turkey,child: Text("turkey")),
            DropdownMenuItem<CalculationMethod>(value: CalculationMethod.other,child: Text("other")),
          ],
        ),
      ),
          ]
          )
        ]
      )
    );
  }
}

class SelectedMadhab extends StatelessWidget {
  const SelectedMadhab({Key? key, this.onChange, required this.selectedMadhab}) : super(key: key);

  final dynamic onChange;
  final Madhab selectedMadhab;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: Row(
        children: [
          Expanded(
              child: Text(AppLocalizations.of(context).selectmadhab,style: const TextStyle(fontSize: 20),)
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<Madhab>(
              value: selectedMadhab,
              dropdownColor: Theme.of(context).backgroundColor,
              items: <Madhab>[Madhab.shafi,Madhab.hanafi]
                  .map<DropdownMenuItem<Madhab>>((Madhab value) {
                return DropdownMenuItem<Madhab>(
                  value: value,
                  child: Text(value.toString(), style: const TextStyle(fontSize: 20),),
                );
              }).toList(),
              onChanged: onChange,
            ),
          ),
        ],
      ),
    );
  }
}