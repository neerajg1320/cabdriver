import 'package:cabdriver/brand_colors.dart';
import 'package:cabdriver/globalvarialbes.dart';
import 'package:cabdriver/screens/mainpage.dart';
import 'package:cabdriver/widgets/TaxiButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class VehicleInfoPage extends StatelessWidget {
  static const String id = 'vehicleinfo';

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final snackbar = SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        )
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  var carModelController = TextEditingController();
  var carColorController = TextEditingController();
  var vehicleNumberController = TextEditingController();

  // Update driver profile with the vehicle information
  void updateProfile(context) {
    String id = currentFirebaseUser.uid;
    DatabaseReference driverRef = FirebaseDatabase.instance.reference().child('drivers/$id/vehicle_details');

    Map map = {
      'car_model': carModelController.text,
      'car_color': carColorController.text,
      'vehicle_number': vehicleNumberController.text,
    };

    driverRef.set(map);
    
    Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40,),
              Image.asset('images/logo.png', height: 110, width: 110,),
              Padding(
                padding: const EdgeInsets.fromLTRB(30,20,30,30),
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Text(
                      'Enter vehicle details',
                      style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 22),
                    ),
                    SizedBox(height: 25,),
                    TextField(
                      controller: carModelController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Car model',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 10,),
                    TextField(
                      controller: carColorController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Car color',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 10,),
                    TextField(
                      controller: vehicleNumberController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Vehicle number',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 40,),
                    TaxiButton(
                      color: BrandColors.colorGreen,
                      title: 'PROCEED',
                      onPressed: () {
                        if(carModelController.text.length < 3) {
                          showSnackBar('Please provide a valid car model');
                        }
                        if(carColorController.text.length < 3) {
                          showSnackBar('Please provide a valid car color');
                        }
                        if(vehicleNumberController.text.length < 3) {
                          showSnackBar('Please provide a valid vehicle number');
                        }

                        updateProfile(context);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
