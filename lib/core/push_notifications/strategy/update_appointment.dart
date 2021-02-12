import 'package:flutter_receive_notifications/core/push_notifications/strategy/i_push_strategy.dart';

class UpdateAppointmentStrategy implements IPushStrategy {
  @override
  void execute(Map<String, dynamic> payload) {
    print('##################');
    print('Update appointment');
  }
  
}