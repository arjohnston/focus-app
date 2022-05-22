import 'dart:async';

import 'package:flutter/material.dart';
import 'FocusWidget.dart';
import 'Reminders/Reminder.dart';
import 'TasksWidget.dart';
import 'GoalsWidget.dart';
import 'RemindersWidget.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _configureLocalTimeZone();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
      });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'Focus';

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[];

  _MyHomePageState() {
    _widgetOptions = <Widget>[
      const FocusWidget(),
      TasksWidget(setScene),
      GoalsWidget(setScene),
      RemindersWidget(setScene, setupPeriodicReminder, removePeriodicReminder),
    ];
  }

  void setupPeriodicReminder(Reminder reminder) {
    Timer(reminder.time.difference(DateTime.now()), () => showPeriodicReminder(reminder));
  }

  void removePeriodicReminder(Reminder reminder) async {
    await flutterLocalNotificationsPlugin.cancel(reminder.id);
  }

  void showPeriodicReminder(Reminder reminder) async {
    // Show the notification immediately at the specified time
    await flutterLocalNotificationsPlugin.show(reminder.id, 'Focus Reminder', reminder.name, const NotificationDetails(
        android: AndroidNotificationDetails(
            'focus-app', 'focus',
            channelDescription: 'reminder notifications')));

    // Show the notification at the specified interval from hereon out
    await flutterLocalNotificationsPlugin.periodicallyShow(reminder.id, 'Focus Reminder', reminder.name, RepeatInterval.daily, const NotificationDetails(
        android: AndroidNotificationDetails(
            '0', 'focus',
            channelDescription: 'reminder notifications')),
        androidAllowWhileIdle: true);
  }

  void setScene(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(child: Image.asset('assets/images/logo.png')),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.cover,),
            ),
          ),
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_empty),
            label: 'FOCUS',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_check_outlined),
            label: 'TASKS',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.outlined_flag),
            label: 'GOALS',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm),
            label: 'REMINDERS',
            backgroundColor: Colors.white,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[600],
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: setScene,
      ),
    );
  }

}

