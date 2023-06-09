import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:joke/connected/joke_connected.dart';
import 'package:joke/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  runApp(const MyApp());

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
}

@pragma('vm:entry-point')
void notify() async {
  JokeConnected.getJoke().then((value) {
    NotificationServices notificationServices = NotificationServices();
    notificationServices.initialiseNotifications();
    notificationServices.sendNotification("Joke", value);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'joke',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'joke'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String joke = "";
  bool _load = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _load
                  ? const CircularProgressIndicator()
                  : Text(
                      joke,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _load = true;
                  });

                  JokeConnected.getJoke().then((value) {
                    setState(() {
                      joke = value;
                      _load = false;
                    });
                  });
                },
                child: const Text(
                  "Получить шутку",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  await AndroidAlarmManager.oneShot(
                      const Duration(minutes: 1), 1111, notify);
                },
                child: const Text(
                  "Сообщить через 1 минуту",
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await AndroidAlarmManager.oneShot(
                      const Duration(minutes: 30), 3030, notify);
                },
                child: const Text(
                  "Сообщить через 30 минут",
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await AndroidAlarmManager.oneShot(
                      const Duration(minutes: 60), 6060, notify);
                },
                child: const Text(
                  "Сообщить через 1 час",
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
