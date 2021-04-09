import 'package:cabdriver/brand_colors.dart';
import 'package:cabdriver/datamodels/tripdetails.dart';
import 'package:cabdriver/widgets/BrandDivider.dart';
import 'package:cabdriver/widgets/TaxiButton.dart';
import 'package:cabdriver/widgets/TaxiOutlineButton.dart';
import 'package:flutter/material.dart';

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
}
