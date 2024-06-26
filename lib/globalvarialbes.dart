import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

User currentFirebaseUser;

final CameraPosition googlePlexPosition = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

final String mapKey = "AIzaSyBriaQcD5BVaIoZGg3-sdqZr58MjCsTNhg";
final String geoCodingApiKey = "AIzaSyDyGkF3_aKHfo5KUTP4Pm6lsuXMPK1HwTU";

DatabaseReference tripRequestRef;

StreamSubscription<Position> homeTabPositionStream;