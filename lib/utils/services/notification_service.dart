import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// --- Función de nivel superior para manejar respuestas de notificaciones en segundo plano ---
// ¡¡ESTA FUNCIÓN DEBE SER TOP-LEVEL O ESTÁTICA!!
// Es crucial para que Flutter pueda llamarla cuando la app está en segundo plano o terminada.
@pragma('vm:entry-point') // Anotación necesaria para que Dart la preserve para el background
void notificationTapBackground(NotificationResponse notificationResponse) {
  print('Notification tapped (background local - top-level): ${notificationResponse.payload}');
  // Puedes añadir lógica de navegación o procesamiento aquí.
  // Ten en cuenta que en este contexto, no tienes acceso directo al BuildContext de la UI.
  // Si necesitas navegar, podrías usar una clave de navegador global o un sistema de rutas.
}


class NotificationService {
  // Instancia de FlutterLocalNotificationsPlugin (debe ser estática o singleton)
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Instancia de FirebaseMessaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Constructor privado para singleton (buena práctica para servicios)
  // Esto asegura que solo haya una instancia de NotificationService en toda la app.
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  // Método de inicialización para el servicio de notificaciones
  initFCM() async { // Renombrado a initializeNotifications para mayor claridad, pero mantuve initFCM si prefieres
    // 1. Configuración de FlutterLocalNotificationsPlugin para Android
    // NOTA: Corregido @minmap a @mipmap
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Este callback se dispara cuando el usuario toca una notificación local
        // (ya sea en primer plano, segundo plano o app terminada, si fue mostrada localmente)
        print('Notification tapped (local - foreground/terminated): ${response.payload}');
        // Aquí puedes añadir lógica de navegación, por ejemplo:
        // if (response.payload != null) {
        //   Navigator.of(context).pushNamed(response.payload!); // Necesitarías un GlobalKey<NavigatorState>
        // }
      },
      // ¡¡AQUÍ ES DONDE CAMBIAMOS!! Referenciamos la función top-level
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // 2. Solicitar permisos de Firebase Messaging (principalmente para Android 13+ y Web)
    // Para Android, el permiso POST_NOTIFICATIONS se solicita en tiempo de ejecución
    // con este método. Para versiones anteriores, los permisos se otorgan en la instalación.
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // await _firebaseMessaging.requestPermission(); // Esta línea es redundante, ya se hizo arriba

    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');
    // Aquí es donde deberías enviar este token a tu backend (Firestore)
    // para poder enviar notificaciones dirigidas a este dispositivo.
    // Ejemplo: await FirebaseFirestore.instance.collection('users').doc(userId).update({'fcmToken': fcmToken});

    // 3. Configurar manejadores de mensajes de Firebase Messaging
    _configureFCMListeners();

    /*FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      print('Message: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message: ${message.notification?.title}');
    });    */ // Estas líneas están comentadas y duplicadas por _configureFCMListeners()
  }

  void _configureFCMListeners() {
    // Manejar mensajes cuando la app está en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
          'Message also contained a notification: ${message.notification?.title}',
        );
        // Muestra la notificación usando flutter_local_notifications
        _showLocalNotification(message);
      }
    });

    // Manejar la interacción del usuario con la notificación cuando la app está en segundo plano
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
      // Aquí puedes navegar a una pantalla específica basada en los datos de la notificación
      // Ejemplo: Navigator.pushNamed(context, message.data['route'], arguments: message.data);
    });

    // Manejar la notificación cuando la app fue terminada y se abre por la notificación
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print(
          'App opened from terminated state by notification: ${message.data}',
        );
      }
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    if (message.notification == null) return;

    const AndroidNotificationDetails
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel', // Debe coincidir con el channelId en AndroidManifest.xml
      'Notificaciones de Renta Control', // Nombre visible para el usuario
      channelDescription:
          'Canal para notificaciones importantes de la aplicación de Renta Control',
      importance: Importance.max, // Importancia alta
      priority: Priority.high, // Prioridad alta
      showWhen: false, // No muestra la hora de la notificación
      playSound: true,
      icon: '@mipmap/ic_launcher', // NOTA: Corregido @minmap a @mipmap
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode, // Un ID único para la notificación
      message.notification!.title,
      message.notification!.body,
      platformChannelSpecifics,
      payload: message.data['route'] ?? message.data['id'], // Puedes usar datos para el payload
    );
  }
}