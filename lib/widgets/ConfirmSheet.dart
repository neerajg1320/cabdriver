import 'package:cabdriver/brand_colors.dart';
import 'package:cabdriver/widgets/TaxiButton.dart';
import 'package:cabdriver/widgets/TaxiOutlineButton.dart';
import 'package:flutter/material.dart';

class ConfirmSheet extends StatelessWidget {
  final String title;
  final String subTitle;
  final Color confirmButtonColor;
  final Function onConfirmPressed;

  ConfirmSheet({this.title, this.subTitle, this.confirmButtonColor, this.onConfirmPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0,
            spreadRadius: 0.5,
            offset: Offset(
              0.7,
              0.7,
            )
          )
        ]
      ),
      height: 220,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontFamily: 'Brand-Bold', color: BrandColors.colorText),
            ),
            SizedBox(height: 20,),
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: BrandColors.colorTextLight),
            ),
            SizedBox(height: 24,),
            Row(
              children: [
                Expanded(
                  child : Container(
                    child: TaxiOutlineButton(
                      title: 'BACK',
                      color: BrandColors.colorLightGrayFair,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                SizedBox(width: 16,),
                Expanded(
                  child: Container(
                    child: TaxiButton(
                      title: 'CONFIRM',
                      color: confirmButtonColor,
                      onPressed: onConfirmPressed,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
