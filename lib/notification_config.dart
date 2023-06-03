import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');

const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
Future<void> initLocalNotification() async =>
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

void onDidReceiveNotificationResponse(NotificationResponse response) {}

const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('0', 'post',
        channelDescription: 'show post update',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

void showNotification(String title, String body) async =>
    await flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: '');
