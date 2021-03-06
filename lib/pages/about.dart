import 'package:flutter/material.dart';
import 'package:tba/services/date_time_helper.dart';
import 'package:tba/services/web.dart'; 
import 'package:tba/shared/bottom_nav_bar.dart';
import 'package:tba/styles/colors.dart';
import 'package:tba/styles/style.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currentYear = DateTimeHelper().currentYear(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text('About app', style: AppBarTitleStyle,), 
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text('phita', style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),),),
              Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text('phita is a simple app aiming to help transporters, transport workers and other transport-related businesses keep track of their finances, better manage and organize their daily operations.', textAlign: TextAlign.center,),), 
              /* Container(
                margin: EdgeInsets.only(top: 100.0),
                child: Text('\u00A9 $currentYear Phita Ltd.'),) */ 
                              Container(
                margin: EdgeInsets.only(top: 100.0),
                child: GestureDetector(
                  onTap: () => WebService().openUrl('https://johnapps.de', context),
                  child: Text('\u00A9 $currentYear JOHN APPS', 
                  style: TextStyle(
                    // fontStyle: FontStyle.italic, 
                    color: myBlue,
                    fontWeight: FontWeight.bold, 
                    // decoration: TextDecoration.underline
                    ),),
                ),
              ) 
            ],
          ),),),
          bottomNavigationBar: BottomNavBar(), 
        
    );
  }
}