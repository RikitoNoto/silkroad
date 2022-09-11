// 受信リストアイテム
import 'package:flutter/material.dart';

class ReceiveListItem extends StatelessWidget{
  const ReceiveListItem({
    required this.icon,
    required this.name,
    required this.size,
    super.key,
  });

  final Widget icon;
  final String name;
  final String size;

  @override
  Widget build(BuildContext context)
  {
    return ElevatedButton(
        onPressed: ()=>{},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 5, //影の大きさ
          side: BorderSide(
            color: Colors.black,
          ),
        ),
        child: Expanded(
            child: IntrinsicHeight(
              child: Row(
                children: [
                  icon,
                  SizedBox(
                    width: 10,
                  ),
                  Text(name),
                  SizedBox(
                    width: 10,
                  ),
                  Text(size),
                ],
              ),
            )
        )
    );
  }
}
