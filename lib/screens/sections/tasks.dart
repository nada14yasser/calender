import 'package:calender_project/Custom_Widget/text_field.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../Custom_Widget/custom_drawer.dart';
import '../../Custom_Widget/notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../database/cubit.dart';
import '../../database/states.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key, required this.email, required this.userName}) : super(key: key);

  final String email;
  final String userName;

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {

  List tasks =[
    'Task 1',
    'Task 2',
  ];
  List dates =[
    'Thursday 10:12',
    'Sunday 2:3',
  ];
  List<bool> clickDoneList =[];
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  List taskNamesList=[];
  List descriptionsList=[];
  List datesList=[];
  List reminderTimeList=[];
  List<bool> dayColorList =[];
  String taskName='';
  String description='';
  String date='';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatebase(),
      child: BlocConsumer<AppCubit,AppStates>(
          listener: ( context , state){
            if(state is AppInsertDateBaseState){}
          },
          builder: (BuildContext context, state)
          {
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
            ),
            drawer: CustomDrawer(userName: widget.userName,email: widget.email),
            body: ConditionalBuilder(
                condition:  state is! AppGetDateBaseLoadinState,
                fallback: (contaxt)=>const Center(child: CircularProgressIndicator(),),
                builder:(context) =>  FutureBuilder(
                    future: AppCubit.get(context).allTasks(),
                    builder: (context,snapshot) {
                    if(snapshot.hasData){
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: snapshot.data!.isEmpty?
                        Center(
                          child: Text(AppLocalizations.of(context).tapandaddyournewtask,
                            style: TextStyle(fontSize: 30,color: Colors.grey.shade400),),
                        )
                        :
                        Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext ctx,int i){
                              return Dismissible(
                                key: UniqueKey(),
                                direction : DismissDirection.endToStart,
                                onDismissed: (a)async{
                                  await AppCubit.get(context).deleteTaskDate(id: snapshot.data![i]['id']);
                                  print('${i + 1} Deleted');
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
                                              child:
                                              // clickDoneList[i]?
                                              const Icon(Icons.done,color: Color.fromRGBO(215, 190, 105, 1),size: 20,)
                                                  // :const SizedBox(),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        Text("${snapshot.data![i]['taskname']}",style: const TextStyle(fontSize: 25),),
                                      ],
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10,),
                                        Text("${snapshot.data![i]['date']}",style: const TextStyle(fontSize: 15),),
                                        const SizedBox(height: 10,),
                                        Text("${snapshot.data![i]['time']}",style: const TextStyle(fontSize: 15),),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
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
                              builder: (ctxx,state) {
                                return AlertDialog(
                                  title: Center(child: Text(AppLocalizations.of(context).addnewtask,style: TextStyle(fontSize: 22),)),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 100.w,
                                          child: TextInput(
                                              controller: taskNameController,
                                              label: AppLocalizations.of(context).taskname
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
                                        SizedBox(
                                          width: 100.w,
                                          child: TextInput(
                                            controller: dateController,
                                            label: AppLocalizations.of(context).date,
                                            onTap: ()async{
                                              DateTime? newDate = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1940),
                                                lastDate: DateTime(2040),
                                              );
                                              if (newDate == null )return ;
                                              setState(() {
                                                dateController.text =  DateFormat("yyyy-MM-dd").format(newDate);
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        SizedBox(
                                          width: 100.w,
                                          child: TextInput(
                                            controller: timeController,
                                            label: AppLocalizations.of(context).time,
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
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(AppLocalizations.of(context).save,style: TextStyle(fontSize: 17)),
                                      onPressed: () async{
                                        await AppCubit.get(context).insertTaskToDatebase(
                                            taskname: taskNameController.text,
                                            content: descriptionController.text,
                                            date: dateController.text,
                                            time: timeController.text
                                        );
                                        Navigator.of(context).pop();
                                        state((){
                                          taskNameController.clear();
                                          descriptionController.clear();
                                          dateController.clear();
                                          timeController.clear();
                                        });
                                      },
                                    ),
                                    TextButton(
                                      child: Text(AppLocalizations.of(context).cancel,style: TextStyle(fontSize: 17),),
                                      onPressed: () {
                                        // print('task length: ${taskNamesList.length}');
                                        Navigator.of(ctxx).pop();
                                      },
                                    ),
                                  ],
                                );
                              }
                          )
                  );
                },
              )
          );
        }
      ),
    );
  }
}
