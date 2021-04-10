import 'package:cabdriver/brand_colors.dart';
import 'package:cabdriver/datamodels/tripdetails.dart';
import 'package:cabdriver/globalvarialbes.dart';
import 'package:cabdriver/helpers/helpermethods.dart';
import 'package:cabdriver/screens/newtrippage.dart';
import 'package:cabdriver/widgets/BrandDivider.dart';
import 'package:cabdriver/widgets/ProgressDialog.dart';
import 'package:cabdriver/widgets/TaxiButton.dart';
import 'package:cabdriver/widgets/TaxiOutlineButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class NotificationDialog extends StatelessWidget {
  final TripDetails tripDetails;

  NotificationDialog({this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 40,),
            Image.asset('images/taxi.png', width: 100,),
            SizedBox(height: 30,),
            Text(
              'New Trip Request',
              style: TextStyle(
                fontFamily: 'Brand-Bold',
                fontSize: 18,
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('images/pickicon.png', height: 16, width: 16,),
                      SizedBox(width: 18,),
                      Expanded(child: Container(child: Text(tripDetails.pickupAddress, style: TextStyle(fontSize: 18),)))
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('images/desticon.png', height: 16, width: 16,),
                      SizedBox(width: 18,),
                      Expanded(child: Container(child: Text(tripDetails.destinationAddress, style: TextStyle(fontSize: 18),)))
                    ],
                  ),
                ],
              )
            ),
            SizedBox(height: 20,),
            BrandDivider(),
            SizedBox(height: 8,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      child: TaxiOutlineButton(
                        title: 'DECLINE',
                        color: BrandColors.colorPrimary,
                        onPressed: () async {
                          assetsAudioPlayer.stop();
                          Navigator.pop(context);
                        },
                      )
                    )
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                      child: Container(
                          child: TaxiButton(
                            title: 'ACCEPT',
                            color: BrandColors.colorGreen,
                            onPressed: () async {
                              assetsAudioPlayer.stop();
                              checkAvailability(context);
                            },
                          )
                      )
                  ),
                ],
              )
            ),
            SizedBox(height: 20,),
          ],
        )
      ),
    );
  }

  void checkAvailability(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog('Accepting Request'),
    );

    DatabaseReference newRideRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/newtrip');
    newRideRef.once().then((DataSnapshot snapshot) {
      // To close ProgressDialog
      Navigator.pop(context);

      // To close NotificationDialog
      Navigator.pop(context);

      String thisRideId = "";
      if (snapshot.value != null) {
        thisRideId = snapshot.value.toString();

        if (thisRideId == tripDetails.rideId) {
          newRideRef.set('accepted');
          HelperMethods.disableHomeTabPositionStream();

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewTripPage(tripDetails: tripDetails,))
          );
          print('Ride has been accepted');
        } else if (thisRideId == 'cancelled') {
          Toast.show("Ride has been cancelled", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          // print('Ride has been cancelled');
        } else if (thisRideId == 'timeout') {
          Toast.show("Ride has been timed out", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          // print('Ride has been timed out');
        } else {
          Toast.show("Ride not valid", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          // print('Ride not valid');
        }
      } else {
        Toast.show("Ride not found", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        // print('Ride not found');
      }

    });
  }
}
