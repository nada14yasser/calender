import 'package:bloc/bloc.dart';
import 'package:calender_project/database/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());
  static AppCubit get(Context)=> BlocProvider.of(Context);
  late Database database;
  List<Map> tasks = [];
  List<Map> habits = [];
  List<Map> notes = [];

  void createDatebase()
  {
    openDatabase(
      'task.db',
      version: 1,

      onCreate: (database, version)
      {
        print('DataBase Created');
        ///tasks table
        database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, taskname TEXT , content TEXT, date TEXT, time TEXT)').then((value)
        {
          print('Tasks Table Created');
        }).catchError((error){
          print('Error when creating table ${error.toString()}');
        });

        ///habits table
        database.execute('CREATE TABLE habits (id INTEGER PRIMARY KEY, habitname TEXT , content TEXT, repeat TEXT, time TEXT)').then((value)
        {
          print('Habits Table Created');
        }).catchError((error){
          print('Error when creating table ${error.toString()}');
        });

        ///notes table
        database.execute('CREATE TABLE notes (id INTEGER PRIMARY KEY,content TEXT, date TEXT, time TEXT)').then((value)
        {
          print('Notes Table Created');
        }).catchError((error){
          print('Error when creating table ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        getDataTasksFromDatabase(database);
        getDataHabitsFromDatabase(database);
        getDataNotesFromDatabase(database);
        print('DataBase opened');
        // print('columns added');
      },
    ).then((value) {
      database = value;
      print(database.path);
      emit(AppCreateDateBaseState());
    });
  }

  insertTaskToDatebase({
    required String taskname,
    required String content,
    required String date,
    required String time,
  }) async
  {
    await database.transaction((txn) async
    {
      txn.rawInsert('INSERT INTO tasks(taskname, content , date ,time) VALUES("$taskname","$content","$date","$time")').then((value)
      {
        print('$value inserted sussafuly');
        emit(AppInsertDateBaseState());

        getDataTasksFromDatabase(database);
      })
          .catchError((error){
        print('Error Inserting Table ${error.toString()}');
      });
    });

  }

  insertHabitToDatebase({
    required String habitname,
    required String content,
    required String repeat,
    required String time,
  }) async
  {
    await database.transaction((txn) async
    {
      txn.rawInsert('INSERT INTO habits(habitname, content , repeat ,time) VALUES("$habitname","$content","$repeat","$time")').then((value)
      {
        print('$value inserted sussafuly');
        emit(AppInsertDateBaseState());

        getDataHabitsFromDatabase(database);
      })
          .catchError((error){
        print('Error Inserting Table ${error.toString()}');
      });
    });

  }
  insertNotesToDatebase({
    required String content,
    required String date,
    required String time,
  }) async
  {
    await database.transaction((txn) async
    {
      txn.rawInsert('INSERT INTO notes(content , date ,time) VALUES("$content","$date","$time")').then((value)
      {
        print('$value inserted sussafuly');
        emit(AppInsertDateBaseState());

        getDataNotesFromDatabase(database);
      })
          .catchError((error){
        print('Error Inserting Table ${error.toString()}');
      });
    });

  }

  getDataTasksFromDatabase(database)
  {
    tasks=[];
    emit(AppGetDateBaseLoadinState());
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      value.forEach((element) {
        tasks.add(element);
      }
      );
      emit(AppGetDateBaseState());
    });

  }

  getDataHabitsFromDatabase(database)
  {
    habits=[];
    emit(AppGetDateBaseLoadinState());
    database.rawQuery('SELECT * FROM habits').then((value)
    {
      value.forEach((element) {
        habits.add(element);
      }
      );
      emit(AppGetDateBaseState());
    });

  }

  getDataNotesFromDatabase(database)
  {
    notes=[];
    emit(AppGetDateBaseLoadinState());
    database.rawQuery('SELECT * FROM notes').then((value)
    {
      value.forEach((element) {
        notes.add(element);
      }
      );
      emit(AppGetDateBaseState());
    });

  }

  updateData({
    required int id,
  }) async
  {
    database.rawUpdate(
        // 'UPDATE tasks WHERE id = ?',
        'UPDATE tasks SET taskname = ?, content = ?, date = ?, time = ? WHERE id = ?'
        [id]
    ).then((value)
    {
      getDataTasksFromDatabase(database);
      emit(AppUpdateDateBaseLoadinState());
    }
    );

  }

  deleteTaskDate({
    required id
  })
  {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value)
    {
      // print("$id");
      getDataTasksFromDatabase(database);
      emit(AppDeleteDateBaseLoadinState());
    });
  }

  deleteHabitDate({
    required id
  })
  {
    database.rawDelete('DELETE FROM habits WHERE id = ?', [id]).then((value)
    {
      // print("$id");
      getDataHabitsFromDatabase(database);
      emit(AppDeleteDateBaseLoadinState());
    });
  }
  deleteNoteDate({
    required id
  })
  {
    database.rawDelete('DELETE FROM notes WHERE id = ?', [id]).then((value)
    {
      getDataNotesFromDatabase(database);
      emit(AppDeleteDateBaseLoadinState());
    });
  }

  Future<List> allTasks()async{
    List<Map> list = await database.query("tasks");
    return list;
  }
  Future<List> allHabits()async{
    List<Map> list = await database.query("habits");
    return list;
  }
  Future<List> allNotes()async{
    List<Map> list = await database.query("notes");
    return list;
  }

}


