import 'package:flutter_receive_notifications/core/push_notifications/strategy/chat_message.dart';
import 'package:flutter_receive_notifications/core/push_notifications/strategy/i_push_strategy.dart';
import 'package:flutter_receive_notifications/core/push_notifications/strategy/update_appointment.dart';

class PushNotificationsFactory {
  Map<String, dynamic> pushPayload;
  IPushStrategy strategy;

  PushNotificationsFactory.create(this.pushPayload){
    switch (pushPayload['type']) {
      case 'updateAppointment':
        strategy = UpdateAppointmentStrategy();
        break;
      case 'chatMessage':
        strategy = ChatMessageStrategy();
        break;
      default:
        throw Exception('Estratégia não criada');
    }
  }

  void execute() {
    strategy.execute(pushPayload);
  }
}