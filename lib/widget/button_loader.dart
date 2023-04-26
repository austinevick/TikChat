import 'package:flutter/material.dart';

class ButtonLoader extends StatelessWidget {
  final bool isLoading;
  final String? text;
  final Color? color;
  final TextStyle? style;
  final Color? spinnerColor;
  const ButtonLoader(
      {Key? key,
      required this.isLoading,
      required this.text,
      this.color = Colors.black,
      this.spinnerColor,
      this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Text(
            text!,
            style: style ?? TextStyle(color: color, fontSize: 18),
          )
        : Center(
            child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: spinnerColor ?? Colors.black, strokeWidth: 2)),
          );
  }
}
