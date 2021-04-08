import 'dart:async';

import 'package:cabdriver/brand_colors.dart';
import 'package:cabdriver/globalvarialbes.dart';
import 'package:cabdriver/widgets/AvailabilityButton.dart';
import 'package:cabdriver/widgets/ConfirmSheet.dart';
import 'package:cabdriver/widgets/TaxiButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  Position currentPosition;
  Geolocator geoLocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);

  String availabilityTitle = 'START';
  Color availabilityColor = BrandColors.colorOrange;
  bool isAvailable = false;

  void getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation
    );
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(pos));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: 135),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: googlePlexPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            mapController = controller;

            getCurrentPosition();
          },
        ),
        Container(
          height: 135,
          width: double.infinity,
          color: BrandColors.colorPrimary,
        ),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AvailabilityButton(
                title: (!isAvailable) ? 'GO ONLINE' : 'GO OFFLINE',
                color: availabilityColor,
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => ConfirmSheet(
                        title: (!isAvailable) ? 'GO ONLINE' : 'GO OFFLINE',
                        subTitle: (!isAvailable) ? 'Start receiving trip requests' : 'Stop receiving trip requests',
                        confirmButtonColor: (!isAvailable) ? BrandColors.colorGreen : Colors.red,
                        onConfirmPressed: () {
                          if(!isAvailable) {
                            goOnline();
                            getLocationUpdates();
                            Navigator.pop(context);

                            setState(() {
                              availabilityColor = BrandColors.colorGreen;
                              availabilityTitle = 'GO OFFLINE';
                              isAvailable = true;
                            });
                          } else {
                            goOffline();
                            Navigator.pop(context);

                            setState(() {
                              availabilityColor = BrandColors.colorOrange;
                              availabilityTitle = 'GO ONLINE';
                              isAvailable = false;
                            });
                          }
                        },
                      ));
                },
              ),

            ],
          ),
        )
      ],
    );
  }

  void goOnline() {
    Geofire.initialize('driversAvailable');
    Geofire.setLocation(currentFirebaseUser.uid,
        currentPosition.latitude,
        currentPosition.longitude,
    );

    tripRequestRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/newtrip');
    tripRequestRef.set('waiting');

    tripRequestRef.onValue.listen((event) {

    });
  }

  void goOffline() {
    Geofire.removeLocation(currentFirebaseUser.uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef = null;
  }

  void getLocationUpdates() {
    homeTabPositionStream = Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (isAvailable) {
        Geofire.setLocation(currentFirebaseUser.uid, position.latitude, position.longitude);
      }

      LatLng pos = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }
}
