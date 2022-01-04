import 'package:flutter/material.dart';
import 'package:tba/styles/colors.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Icon(Icons.info_outline, color: myBlue, size: 40.0,), 
      content: Text('Still under construction!', textAlign: TextAlign.center,), 
      actions:[
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('OK', style: TextStyle(fontSize: 20,),),
            ],
          ))
      ],
      shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),  
    );
  }
}


class ErrorDialog extends StatelessWidget { 
  final String errorMessage;
  ErrorDialog(this.errorMessage);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Icon(Icons.report_outlined, color: myRed, size: 40.0,), 
      content: Text(errorMessage, textAlign: TextAlign.center,), 
      actions:[
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('OK', style: TextStyle(fontSize: 20, color: myRed),),
            ],
          ))
      ],
      shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),  
    );
  }
}