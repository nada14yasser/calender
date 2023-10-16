import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Custom_Widget/text_field.dart';
class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {

  EventController controller = EventController();
  TextEditingController eventController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController descController= TextEditingController();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  DateTime startDate= DateTime.now();
  DateTime endDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Color.fromRGBO(215, 190, 105, 1),size: 30),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Padding(
            padding: const EdgeInsets.symmetric (horizontal: 10, vertical: 10),
            child: TextInput (
                controller: eventController,
                label: 'Event',
                    ), // TextInput
            ),
              Padding(
                padding: const EdgeInsets.symmetric (horizontal: 10, vertical: 10),
                child: TextInput (
                controller: titleController,
                label: 'Title',
                ), // TextInput
                ),
              Padding(
                padding: const EdgeInsets.symmetric (horizontal: 10, vertical: 10),
                child: Row(
                children: <Widget> [
                  Expanded (
                  child: TextInput (
                    controller: startDateController,
                    label: 'Start Date',
                    onTap: () {
                    selectDate(context, true);
                    }),
                  ),
                  const SizedBox (
                  width: 20,
                  ), // Sized Box
                  Expanded (
                  child: TextInput (
                    controller: endDateController,
                    label: 'End Date',
                    onTap: () {
                    selectDate(context, false);
                    },
                    ),
                  ),
                ],
                ),
             ),
              Padding(
              padding: const EdgeInsets.symmetric (horizontal: 10, vertical: 10),
              child: Row(
              children:[
              Expanded (
              child: TextInput (
                controller: startTimeController,
                label: 'Start Time',
                onTap: () {
                selectTime(context, true);
                },
                ),
              ),
              const SizedBox (
              width: 20,
              ), // Sized Box
              Expanded (
              child: TextInput (
                controller: endTimeController,
                label: 'End Time',
                onTap: () {
                selectTime(context, false);
                },
                ),
              ),
              ]
              ),
              ), // Padding
              Padding(
                padding: const EdgeInsets.symmetric (horizontal: 10, vertical: 10),
                child: TextInput(
                  controller: descController,
                  label: 'Description',
                  line: 3,)
              )
          ],
        ),
      ),
    floatingActionButton: FloatingActionButton(
    onPressed: () {

      Navigator.of(context).pop(); //back to calendar view
    },
    child: Icon(Icons.add,color: Theme.of(context).backgroundColor,),
    ), // FloatingActionButton
    );
  }

  //time picker dialog
  Future<void> selectTime (BuildContext context, bool time) async {
    final setTime = time? startTime: endTime;
    final TimeOfDay? pickedTime=
    await showTimePicker (context: context, initialTime: setTime);
    if (pickedTime != null && pickedTime != setTime) {
      setState(() {
        if (time) {
          startTime=pickedTime;
          startTimeController.text = pickedTime. format (context).toString();
        } else {
          endTime=pickedTime;
          endTimeController.text = pickedTime. format (context).toString();
        }
      });
    }
  }
  //date picker dialog
  Future<void> selectDate (BuildContext context, bool date) async {
    final setTime = date ? startDate: endDate;
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime (2023, 1, 1),
        lastDate: DateTime (2025, 12, 31),
        initialDate: DateTime.now()
    );
    if(pickedDate != null && pickedDate != setTime) {
    setState(() {
    if (date) {
    startDate= pickedDate;
    startDateController.text = DateFormat.yMMMd (). format (pickedDate);
    } else {
    endDate = pickedDate;
    endDateController.text= DateFormat.yMMMd (). format (pickedDate);
    }
    });
    }
  }
}
