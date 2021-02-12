# flutter_receive_notifications

# como usar
  Para testar esse projeto basta compilar ele através do VSCode

   O teste via [Postman] pode ser feito da seguinte forma

    - nos [Headers] adicionar uma key [Authorization] com valor:
   
    [pedir

    - lembrar de trocar o token no [body]

    - no [body] adicionar o seguinte JSON:
       {
         "notification": {
            "body": "Sua consulta foi confirmada",
            "title": "Consulta Confirmada."
         },
         "priority": "high",
         "data": {
            "clickaction": "FLUTTERNOTIFICATIONCLICK",
            "id": "1",
            "status": "done",
            "payload": {
                  "type": "updateAppointment",
                  "status": "Consulta Confirmada"
            }
         },
         "to": "AQUI DENTRO VAI O TOKEN DO SEU DISPOSITIVO QUE ESTA PRINTADO NO CONSOLE"
      }

  Ao chegar a notificação o payload é tratado de duas formas, que no momento apenas printam o que cada uma deve fazer, para testar a outra maneira do payload é só trocar dentro no [body]
   - o [type] do payload para "chatMessage"
   - a linha de [status] trocar para "message": "sua mensagem"

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
