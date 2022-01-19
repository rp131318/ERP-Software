import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key key,
    this.function,
  }) : super(key: key);

  final Function function;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => function(),
          child: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
        SizedBox(
          width: 12,
        ),
      ],
    );
  }
}
