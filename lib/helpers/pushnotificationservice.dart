import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart' as assets_audio_player;
import 'package:cabdriver/datamodels/tripdetails.dart';
import 'package:cabdriver/globalvarialbes.dart';
import 'package:cabdriver/widgets/NotificationDialog.dart';
import 'package:cabdriver/widgets/ProgressDialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// https://firebase.flutter.dev/docs/messaging/usage/
class PushNotificationService {
  static FirebaseMessaging messaging;
  static var clsContext;

  static String getRideId(RemoteMessage message) {
    String rideId;
    if (Platform.isAndroid) {
      rideId = message.data['ride_id'];
    } else {
      // Need to verify on iOS
      // rideId = message.ride_id;
    }
    return rideId;
  }

  static void fetchRideInfo(String rideId, context ) {
    DatabaseReference rideRef = FirebaseDatabase.instance.reference().child('rideRequest/$rideId');
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog('Fetching Details ... '),
    );

    rideRef.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);

      if (snapshot.value != null) {
        // final assetsAudioPlayer = assets_audio_player.AssetsAudioPlayer();
        assetsAudioPlayer.open(
          assets_audio_player.Audio('sounds/alert.mp3'),
        );
        assetsAudioPlayer.play();

        double pickupLat = double.parse(
            snapshot.value['location']['latitude'].toString());
        double pickupLng = double.parse(
            snapshot.value['location']['longitude'].toString());
        String pickupAddress = snapshot.value['pickup_address'].toString();

        double destinationLat = double.parse(
            snapshot.value['destination']['latitude'].toString());
        double destinationLng = double.parse(
            snapshot.value['destination']['longitude'].toString());
        String destinationAddress = snapshot.value['destination_address'];

        String paymentMethod = snapshot.value['payment_method'];

        TripDetails tripDetails = TripDetails(
          destinationAddress: destinationAddress,
          pickupAddress: pickupAddress,
          pickup: LatLng(pickupLat, pickupLng),
          destination: LatLng(destinationLat, destinationLng),
          rideId: rideId,
          paymentMethod: paymentMethod,
          riderName: "",
          riderPhone: "",
        );

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => NotificationDialog(tripDetails: tripDetails,),
        );
      }
    });
  }

  static void processMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }

    String rideId = getRideId(message);
    print('ride_id: $rideId');

    fetchRideInfo(rideId, clsContext);
  }


  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
    processMessage(message);
  }



  static Future<void> initialize(contextParam) async {
    messaging = FirebaseMessaging.instance;
    clsContext = contextParam;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen(processMessage);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<String> getToken() async {
    if (messaging == null) {
      print('Error! call initialize method first');
      return null;
    }

    String token = await messaging.getToken();
    print('token: $token');

    DatabaseReference tokenRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/token');
    tokenRef.set(token);

    messaging.subscribeToTopic('alldrivers');
    messaging.subscribeToTopic('allusers');
  }
}