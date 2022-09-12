// 受信リストアイテム
import 'package:flutter/material.dart';

class ReceiveListItem extends StatelessWidget{
  const ReceiveListItem({
    required this.icon_data,
    required this.name,
    required this.size,
    super.key,
  });

  final IconData icon_data;
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
                  FractionallySizedBox(
                    heightFactor: 1.0,

                    child: Icon(icon_data,
//                      size: ,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
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
