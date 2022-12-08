import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experiment 10',
      theme: ThemeData.dark(),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final LocalNotificationService service;
  @override
  void initState(){
    service = LocalNotificationService();
    service.initialize();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Local Notifications Experiment"
        ),
        backgroundColor: const Color(0xff006473),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.25),
        child: Column(
          children: <Widget>[
            TextButton(
              onPressed: () async {
                await service.showNotification(
                    id: 0,
                    title: "Sample Notification",
                    body: "Sample Body"
                );
              },
              child: const Text(
                  "Get an instant Notification"
              ),
            ),
            TextButton(
              onPressed: () async {
                await service.showScheduledNotification(
                  id: 0,
                  title: "Sample Notification",
                  body: "Sample Body",
                  seconds: 4,
                );
              },
              child: const Text(
                  "Get a delayed Notification"
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async{
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('ic_stat_assistant_navigation');

    const DarwinInitializationSettings iosInitializationSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings settings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings
    );

    await _localNotificationService.initialize(settings);
  }
  Future<NotificationDetails> _notificationDetails() async{
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      "channel_id", "channel_name",
      channelDescription: "Description",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails();
    return const NotificationDetails(android: androidNotificationDetails,iOS: darwinNotificationDetails);
  }
  Future<void> showNotification({
    required int id,
    required String title,
    required String body}) async{
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }
  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required int seconds
  }) async{
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(DateTime.now().add(Duration(seconds: seconds)), tz.local,),
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }
}