import 'package:cabdriver/brand_colors.dart';
import 'package:cabdriver/helpers/helpermethods.dart';
import 'package:cabdriver/widgets/BrandDivider.dart';
import 'package:cabdriver/widgets/TaxiButton.dart';
import 'package:flutter/material.dart';

class CollectPaymentDialog extends StatelessWidget {
  final String paymentMethod;
  final int fare;


  CollectPaymentDialog({this.paymentMethod, this.fare});

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
            children: [
              SizedBox(height: 20,),
              Text(paymentMethod),
              SizedBox(height: 20,),
              BrandDivider(),
              SizedBox(height: 16,),
              Text('\$$fare', style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 50)),
              SizedBox(height: 16,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Total fare to be charged to the rider', textAlign: TextAlign.center,),
              ),
              SizedBox(height: 30,),
              Container(
                width: 230,
                child: TaxiButton(
                  title: (paymentMethod == 'cash') ? 'COLLECT CASH' : 'CONFIRM',
                  color: BrandColors.colorGreen,
                  onPressed: () {
                    // Close Dialog
                    Navigator.pop(context);
                    // Close NewTripPage
                    Navigator.pop(context);

                    HelperMethods.enableHomeTabLocationStream();
                  },
                ),
              ),
              SizedBox(height: 40,),
            ],
          )
      ),
    );
  }
}
