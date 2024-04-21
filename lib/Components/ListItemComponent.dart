import 'package:flutter/material.dart';

class ListItemComponent extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  // final bool center;
  final Function callback;
  final double widthPercent;

  const ListItemComponent(
      {Key? key,
      required this.backgroundColor,
      required this.text,
      // required this.center,
      required this.widthPercent,
      required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * widthPercent,
      height: 80,
      // alignment: Center(child: ,)
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              textAlign: TextAlign.center,
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
