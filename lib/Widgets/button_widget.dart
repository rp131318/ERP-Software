import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../globalVariable.dart';

class ButtonWidget extends StatelessWidget {
  final BuildContext context;
  final String buttonText;
  double left = 14;
  double right = 14;
  double fontSize = 18;
  double width = double.infinity;
  double height = 26;
  Function function;
  var color = colorButton;
  bool border = false;
  bool isIcon = false;
  String image;
  Widget widget = Container();

  ButtonWidget(
      {this.context,
      this.buttonText,
      this.function,
      this.left = 14,
      this.right = 14,
      this.fontSize = 18,
      this.width = double.infinity,
      this.height = 26,
      this.color = colorButton,
      this.border = false,
      this.widget,
      this.isIcon = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => function(),
      child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: !border ? color : Colors.transparent,
              border: Border.all(
                  color: border ? color : Colors.transparent,
                  width: border ? 2 : 0),
              borderRadius: BorderRadius.circular(0)),
          margin: EdgeInsets.only(left: left, right: right),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(visible: isIcon, child: widget),
              Text(
                buttonText,
                style: TextStyle(
                    fontSize: fontSize, color: !border ? Colors.white : color),
              ),
            ],
          ))),
    );
  }
}
