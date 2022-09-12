// 受信画面
import 'package:flutter/material.dart';
import 'receive_list_item.dart';

// 受信画面描画クラス
class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key});

  @override
  State<ReceivePage> createState() => _ReceivePageIdleState();
}


// アイドルステート
// 通信処理を行っていないアイドル状態のステート
class _ReceivePageIdleState extends State<ReceivePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receive"),
      ),

      body: _buildBody(context)
    );
  }

  Widget _buildBody(BuildContext context)
  {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            // 入力欄
            Row(
              children: <Widget>[
                // パスワード入力欄
                const Expanded(
                  child: TextField(
                    maxLines: 1,
                  ),
                ),

                const SizedBox(
                  width: 30,
                ),

                // ポート解放ボタン
                ElevatedButton(
                  onPressed: ()=>{},
                  child: const Text("OPEN")
                ),
              ],
            ),

            // 受信リスト
            Flexible(
                child: ListView(
                    children: <Widget>[
                      const ReceiveListItem(icon_data: Icons.image, name: "name", size: "1024kb"),
                      const ReceiveListItem(icon_data: Icons.image, name: "name", size: "1024kb"),
                      
                    ],
                  )
            )

          ]
        )
      )
    );
  }
}

