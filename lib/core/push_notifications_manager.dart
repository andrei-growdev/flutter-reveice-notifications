import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_receive_notifications/core/push_notifications/push_notificatios_factory.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationManager {
  FirebaseMessaging _fcm = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationDetails platformChannelSpecifics;
  SharedPreferences prefs;
  bool alreadyConfigured = false;

  Future<void> configure() async {
    print('entrou na configuração');
    //* inscreve o celular num topico chamado 'ALL' do firebase
    _fcm.subscribeToTopic('all');

    //! initialize configurações android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    //! initialize configurações iOS
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    //! initialize ambas as configurações
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    //! inicializar o plugin
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    //! pede as permições no iOS
    final bool result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    //! detalhes das mensagens de plataformas
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('push_notification_ID',
            'push_notification_NAME', 'push_notification_DESCRIPTion',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(threadIdentifier: 'thread_id');
    platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        _processMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _processMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        // _processMessage(message);
      },
      onBackgroundMessage: onBackgroundMessage,
    );

    String token = await _fcm.getToken();
    print(token);

    prefs = await SharedPreferences.getInstance();
    bool alreadyConfigured = prefs.getBool('configured') ?? false;

    if (!alreadyConfigured) {
      await prefs.setBool('configured', true);
      await saveTokenOnSharedPreferences(token);

      alreadyConfigured = true;
    }
  }

  Future<void> verifyToken() async {
    print('passou no verify');
    _fcm.onTokenRefresh.listen((newToken) async {
      prefs = await SharedPreferences.getInstance();
      String fcmToken = prefs.getString('fcm_token');

      print(newToken);

      if (fcmToken == newToken) return;

      prefs.setString('fcm_token', newToken);
      //! fazer requisição para trocar o token no servidor enviando ambos os tokens, o novo e o velho
    });
  }

  Future<void> saveTokenOnSharedPreferences(String token) async {
    print('passou no save');
    prefs = await SharedPreferences.getInstance();
    prefs.setString('fcm_token', token);
  }

  void _processMessage(message) {
    //! este cara é o que vai receber a mensagem
    _flutterLocalNotificationShow(message);
  }

  //! define o que será feito com a mensagem quando for recebida
  Future<void> _flutterLocalNotificationShow(message) async {
    String payload;
    //! verifica da onde deve ser buscado o payload
    if (Platform.isIOS) {
      payload = message['payload'];
    } else {
      payload = message['data']['payload'];
    }
    //!vai mostrar a notificação contendo tudo, title, body, e o payload serve para o dev
    await flutterLocalNotificationsPlugin.show(
        0,
        message['notification']['title'],
        message['notification']['body'],
        platformChannelSpecifics,
        payload: payload);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {}

  //! define o que acontece quando é clicado na notificação
  Future onSelectNotification(String payload) {
    if (payload != null) {
      PushNotificationsFactory.create(json.decode(payload))..execute();
    }
  }
}

Future onBackgroundMessage(Map<String, dynamic> message) {}
