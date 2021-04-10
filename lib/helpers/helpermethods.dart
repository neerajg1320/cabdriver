import 'dart:math';

import 'package:cabdriver/datamodels/directiondetails.dart';
import 'package:cabdriver/helpers/requesthelper.dart';
import 'package:cabdriver/widgets/ProgressDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../globalvarialbes.dart';

class HelperMethods {



  static Future<DirectionDetails> getDirectionDetails(LatLng startPosition, LatLng endPosition) async {
    String directionMode = 'driving';
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=$directionMode&key=$geoCodingApiKey";

    var response = await RequestHelper.getRequest(url);

    if (response == 'failed') {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails(
      distanceText: response['routes'][0]['legs'][0]['distance']['text'],
      distanceValue: response['routes'][0]['legs'][0]['distance']['value'],
      durationText: response['routes'][0]['legs'][0]['duration']['text'],
      durationValue: response['routes'][0]['legs'][0]['duration']['value'],
      encodedPoints: response['routes'][0]['overview_polyline']['points']
    );

    return directionDetails;
  }

  static int estimateFares(DirectionDetails details, int durationValue) {
    double perKm = 0.3;
    double perMin = 0.2;
    double baseFare = 3;

    double distanceFare = (details. distanceValue / 1000) * perKm;
    double timeFare = (durationValue / 60) * perMin;

    double totalFare = baseFare + distanceFare + timeFare;

    return totalFare.truncate();
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int radInt = randomGenerator.nextInt(max);
    return radInt.toDouble();
  }

  static void disableHomeTabPositionStream() {
    if (homeTabPositionStream != null) {
      homeTabPositionStream.pause();
    }
    Geofire.removeLocation(currentFirebaseUser.uid);
  }

  static void enableHomeTabLocationStream() {
    if (homeTabPositionStream != null) {
      homeTabPositionStream.resume();
    }
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);
  }

  static void showProgressDialog(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog('Please wait'),
    );
  }
}