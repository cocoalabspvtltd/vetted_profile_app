import 'package:faculty_app/utils/custom_loader/dot_type.dart';
import 'package:faculty_app/utils/custom_loader/linear_loader.dart';
import 'package:flutter/material.dart';

class CommonApiLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1.0,
      child: Container(
        color: Colors.transparent,
        alignment: FractionalOffset.center,
        height: double.infinity,
        width: double.infinity,
        child: LinearLoader(
          dotOneColor: Colors.red,
          dotTwoColor: Colors.orange,
          dotThreeColor: Colors.green,
          dotType: DotType.circle,
          dotIcon: Icon(Icons.adjust),
          duration: Duration(seconds: 1),
        ),
      ),
    );
  }
}
