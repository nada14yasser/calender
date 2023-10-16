import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}
class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

class CalendarViewTab extends StatelessWidget {
  const CalendarViewTab({Key? key, required this.view,}) : super(key: key);

  final CalendarView view;
  // final CalendarController calendarController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SfCalendar(
        view : view,
        controller: CalendarController(),
        firstDayOfWeek: 6,
        showNavigationArrow: true,
        cellEndPadding: 0,
        showWeekNumber: true,
        weekNumberStyle: const WeekNumberStyle(
          backgroundColor: Color.fromRGBO(215, 190, 105, 1),
          textStyle: TextStyle(color: Colors.black, fontSize: 15),
        ),
        dataSource: MeetingDataSource(_getDataSource()),
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          showAgenda: true,
          agendaViewHeight: 200,
        ),
      ),
    );
  }
}
List<Meeting> _getDataSource() {
  final List<Meeting> meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
  DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  meetings.add(Meeting(
      'Meeting 1', startTime, endTime, const Color(0xFF0F8644), false));
  meetings.add(Meeting(
      'Meeting 3', startTime, endTime,Colors.blue, false));
  meetings.add(Meeting(
      'Meeting 4', startTime, endTime,Colors.purple, false));
  meetings.add(Meeting(
      'Meeting 5', startTime, endTime,Colors.orange, false));
  meetings.add(
      Meeting(
          'Meeting 2',
          DateTime(2023, 8, 15, 13, 0, 0),
          DateTime(2023, 8, 15, 15, 0, 0),
          Colors.pinkAccent,
          false)
  );
  return meetings;
}


