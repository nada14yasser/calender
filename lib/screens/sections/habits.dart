import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Custom_Widget/Buttons.dart';
import '../../Custom_Widget/custom_drawer.dart';
import '../../Custom_Widget/notifications.dart';
import '../../Custom_Widget/text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../database/cubit.dart';
import '../../database/states.dart';
import '../../provider/provider.dart';

class Habits extends StatefulWidget {
  const Habits({Key? key, required this.email, required this.userName}) : super(key: key);

  final String email;
  final String userName;

  @override
  State<Habits> createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {

  List days =[
    'F',
    'S',
    'S',
    'M',
    'T',
    'W',
    'T',
  ];
  int _defaultValue = 0;
  TimeOfDay selectedTime = TimeOfDay.now();
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  TextEditingController habitNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController repeatController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  List habitNamesList=[];
  List descriptionsList=[];
  List repeatsList=[];
  List reminderTimeList=[];
  List<bool> clickDoneList =[];
  List<bool> dayColorList =[];
  String habitName='';
  String description='';
  String repeat='';

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  static List<Widget> _pages = <Widget>[
    Center(
      child: Text('Tap on add Button \n             and \nAdd your New Habit',
        style: TextStyle(fontSize: 30,color: Colors.grey.shade400),),
    ),
    Center(
      child: Text('Tap on add Button \n             and \nAdd your New Habit',
        style: TextStyle(fontSize: 30,color: Colors.grey.shade400),),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Prov chprov = Provider.of(context);
    final ex = ['Do homework', 'Reading', 'Ride a bike', 'Study', 'Pray'];
    final exCells = ex.map((name) => Padding(
      padding: const EdgeInsets.only(left: 8,right: 8),
      child: FittedBox(
        child: Container(
            width: 200,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.grey.shade200
            ),
            child: Center(child: Text(name,style: const TextStyle(fontSize: 30),))),
      ),
    )).toList();

    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatebase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: ( context , state){
          if(state is AppInsertDateBaseState){}
        },
        builder: (BuildContext context, state){
          return DefaultTabController(
            length: 2,
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
                            Text(AppLocalizations.of(context).settings),
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
                    Tab(text: AppLocalizations.of(context).healthandhyginehabits),
                    Tab(text: AppLocalizations.of(context).charityhabits),
                  ],
                ),
              ),
              drawer: CustomDrawer(userName: widget.userName,email: widget.email),
              body: ConditionalBuilder(
                condition:  state is! AppGetDateBaseLoadinState,
                fallback: (contaxt)=>const Center(child: CircularProgressIndicator(),),
                builder:(context) => FutureBuilder(
                future: AppCubit.get(context).allHabits(),
                builder: (context,snapshot) {
                  if(snapshot.hasData){
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: TabBarView(
                          children:[
                            snapshot.data!.isEmpty?
                              Center(
                                child: Text(AppLocalizations.of(context).tapandaddyournewtask,
                                  style: TextStyle(fontSize: 30,color: Colors.grey.shade400),),
                              ):
                              SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height*0.8,
                              child: ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (BuildContext ctx,int i){
                                    return Dismissible(
                                      key: UniqueKey(),
                                      direction : DismissDirection.endToStart,
                                      onDismissed: (a)async{
                                        await AppCubit.get(context).deleteHabitDate(id: snapshot.data![i]['id']);
                                        print('${i + 1} Deleted');
                                        // print('habit length = ${habitNamesList.length}');
                                      },
                                      background: Container(
                                        alignment: AlignmentDirectional.centerEnd,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            Color(0xFF8A2387),
                                            Color(0xFFE94057),
                                            Color(0xFFF27121),
                                          ]),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(20, 0.0,20, 0.0),
                                          child: Icon(Icons.delete,
                                            color: Theme.of(context).backgroundColor,
                                          ),
                                        ),
                                      ),
                                      child: Card(
                                        color: Theme.of(context).backgroundColor,
                                        child: ListTile(
                                          title: Row(
                                            children: [
                                              InkWell(
                                                // onTap: (){
                                                //   setState(() {
                                                //     clickDoneList[i]=!clickDoneList[i];
                                                //   });
                                                // },
                                                child: CircleAvatar(
                                                  radius: 13,
                                                  backgroundColor: Colors.grey.shade300,
                                                  child: Center(
                                                    child:const Icon(Icons.done,color: Color.fromRGBO(215, 190, 105, 1),size: 20,),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10,),
                                              Text("${snapshot.data![i]['habitname']}",style: const TextStyle(fontSize: 25),),
                                            ],
                                          ),
                                          subtitle: Padding(
                                              padding: const EdgeInsets.only(top: 20),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(AppLocalizations.of(context).everyday),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  Row(
                                                    children: [
                                                      chprov.currentLang=='en'?
                                                      Text('Repeat ${snapshot.data![i]['repeat']} time per day'):
                                                      Text('تكرار ${snapshot.data![i]['repeat']} مرة في اليوم')
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.notifications_none),
                                                      Text('${snapshot.data![i]['time']}')
                                                    ],
                                                  ),
                                                  // const SizedBox(height: 10,),
                                                  // Row(
                                                  //   children: [
                                                  //     for(int j=0;j<days.length;j++)...[
                                                  //       SizedBox(
                                                  //         width: 35,
                                                  //         height: 35,
                                                  //         child: FloatingActionButton(
                                                  //           onPressed: (){
                                                  //             setState(() {
                                                  //               dayColorList[i]=!dayColorList[i];
                                                  //             });
                                                  //           },
                                                  //           backgroundColor:dayColorList[i]?Color.fromRGBO(215, 190, 105, 1):Colors.grey.shade300,
                                                  //           child: Center(child: Text(days[j].toString(),style: const TextStyle(fontSize: 12),)),
                                                  //         ),
                                                  //       ),
                                                  //       const SizedBox(width:10,)
                                                  //     ]
                                                  //   ],
                                                  // ),
                                                ],
                                              )
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              ),
                                ),
                            Center(
                              child: Text(AppLocalizations.of(context).tapandaddyournewcharityhabit,
                                style: TextStyle(fontSize: 30,color: Colors.grey.shade400),),
                            ),
                          ]
                        ),
                      );
                  }
                  return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,));}
                )
        ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                foregroundColor: Color.fromRGBO(250,240,230,1),
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext ctx)=>
                          StatefulBuilder(
                              builder: (cttx,state) {
                                return AlertDialog(
                                  title: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(AppLocalizations.of(context).addnewhabit,
                                            style: TextStyle(
                                              fontSize: 22
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      Text(AppLocalizations.of(context).howdoevaluateprogress,
                                        style: TextStyle(
                                            fontSize: 20
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            width: 250,
                                            child: ButtonAsText(
                                                text:AppLocalizations.of(context).withyesorno,
                                                onPressed:(){
                                                  showDialog(context: context,
                                                      builder: (BuildContext ctx)=>
                                                          StatefulBuilder(
                                                              builder: (ctxx,state) {
                                                                return AlertDialog(
                                                                  title: Center(child: Text(AppLocalizations.of(context).addnewhabit,style: TextStyle(fontSize: 22),)),
                                                                  content: SingleChildScrollView(
                                                                    child: Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          width: 100.w,
                                                                          child: TextInput(
                                                                            controller: habitNameController,
                                                                            label: AppLocalizations.of(context).habitname,
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 10,),
                                                                        SizedBox(
                                                                          width: 100.w,
                                                                          child: TextInput(
                                                                            controller: descriptionController,
                                                                            label: AppLocalizations.of(context).discription,
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 20,),
                                                                        Row(
                                                                          children: [
                                                                            Text(AppLocalizations.of(context).frequency,style: TextStyle(fontSize: 20),),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: <Widget>[
                                                                            RadioListTile(
                                                                              value: 0,
                                                                              groupValue: _defaultValue,
                                                                              title: Text(AppLocalizations.of(context).everyday),
                                                                              onChanged: ( newValue) =>
                                                                                  state(() => _defaultValue = newValue as int),
                                                                            ),
                                                                            RadioListTile(
                                                                              value: 1,
                                                                              groupValue: _defaultValue,
                                                                              title: Text(AppLocalizations.of(context).weekly),
                                                                              onChanged: (newValue) =>
                                                                                  state(() => _defaultValue = newValue as int),
                                                                            ),
                                                                            RadioListTile(
                                                                              value: 2,
                                                                              groupValue: _defaultValue,
                                                                              title: Text(AppLocalizations.of(context).never),
                                                                              onChanged: (newValue) =>
                                                                                  state(() => _defaultValue = newValue as int),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(AppLocalizations.of(context).repeat,style: TextStyle(fontSize: 20)),
                                                                            const SizedBox(width: 30,),
                                                                            SizedBox(
                                                                              width:100,
                                                                              height: 30,
                                                                              child: TextInput(
                                                                                controller: repeatController,
                                                                                keyboardType: TextInputType.number,
                                                                                label: '',
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: 10,),
                                                                        Row(
                                                                          children: [
                                                                            Text(AppLocalizations.of(context).reminder,style: TextStyle(fontSize: 20)),
                                                                            const SizedBox(width: 10,),
                                                                            SizedBox(
                                                                              width: 100,
                                                                              height: 30,
                                                                              child: TextInput(
                                                                                controller: timeController,
                                                                                label: '',
                                                                                onTap: ()async{
                                                                                  TimeOfDay? pickedTime = await showTimePicker(
                                                                                    context: context,
                                                                                    initialTime: TimeOfDay.now(),
                                                                                  ); //end of showTimePicker
                                                                                  if(pickedTime != null ){
                                                                                    print(pickedTime.format(context));
                                                                                    timeController.text = pickedTime.format(context); // to here
                                                                                  }else{
                                                                                    print("Time is not selected");
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(height: 10,),
                                                                        Row(
                                                                          children: [
                                                                            Text(AppLocalizations.of(context).examples,style: TextStyle(fontSize: 20)),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(
                                                                                width: 200,
                                                                                height:200,
                                                                                child: GridView.count(
                                                                                    crossAxisCount: 2,
                                                                                    children: exCells
                                                                                )
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      child: Text(AppLocalizations.of(context).save,style: TextStyle(fontSize: 17)),
                                                                      onPressed: () async{
                                                                        await AppCubit.get(context).insertHabitToDatebase(
                                                                            habitname: habitNameController.text,
                                                                            content: descriptionController.text,
                                                                            repeat: repeatController.text,
                                                                            time: timeController.text
                                                                        );
                                                                        Navigator.of(context).pop();
                                                                        state((){
                                                                          habitNameController.clear();
                                                                          descriptionController.clear();
                                                                          repeatController.clear();
                                                                          timeController.clear();
                                                                        });
                                                                        // state(() {
                                                                        //   habitName = habitNameController.text;
                                                                        //   description = descriptionController.text;
                                                                        //   repeat = repeatController.text;
                                                                        //   if (habitName.isNotEmpty&&repeat.isNotEmpty) {
                                                                        //     habitNamesList.add(habitName);
                                                                        //     habitNameController.clear();
                                                                        //
                                                                        //     descriptionsList.add(description);
                                                                        //     descriptionController.clear();
                                                                        //
                                                                        //     repeatsList.add(repeat);
                                                                        //     repeatController.clear();
                                                                        //
                                                                        //     reminderTimeList.add('${selectedTime.hour}:${selectedTime.minute}');
                                                                        //     clickDoneList.add(true);
                                                                        //     dayColorList.add(true);
                                                                        //   }
                                                                        // });
                                                                        // print('habit length: ${habitNamesList.length}');
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child: Text(AppLocalizations.of(context).cancel,style: TextStyle(fontSize: 17),),
                                                                      onPressed: () {
                                                                        // habits.removeLast();
                                                                        // print('habit length: ${habitNamesList.length}');
                                                                        Navigator.of(ctxx).pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              }
                                                          )
                                                  );
                                                })
                                        ),
                                        SizedBox(width: 250,child: ButtonAsText(text:AppLocalizations.of(context).withnumericvalue, onPressed:(){
                                          Navigator.of(cttx).pop();
                                        })),
                                        SizedBox(width: 250,child: ButtonAsText(text:AppLocalizations.of(context).withtimer, onPressed:(){
                                          Navigator.of(cttx).pop();
                                        })),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(AppLocalizations.of(context).cancel,style: TextStyle(fontSize: 17),),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              }
                          )
                  );
                },
              )
            ),
          );
        }
      ),
    );
  }
}
