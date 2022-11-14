import 'package:flutter/material.dart';


 void showSnackBar(BuildContext context,String msg) {
    final snackBar = SnackBar(
      backgroundColor: Colors.deepPurple,
      elevation: 2,
      margin: const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child:Row(
            children: <Widget>[
        const Icon(
          Icons.report_problem,
          color: Colors.white,
        ),
        const SizedBox(width: 9),
        Text(msg),
      ]),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
