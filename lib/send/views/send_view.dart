// 送信画面
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SendPage(),
    );
  }
}

// 送信画面描画クラス
class SendPage extends StatefulWidget {
  const SendPage({super.key});

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage>{
  String _selectFile = "No select";
  // TextEditingController _ipTextcontroller = TextEditingController(text: '0.0.0.0');
  // TextEditingController _fileNameTextcontroller = TextEditingController(text: 'no select file');
  // TextEditingController _fileSizeTextcontroller = TextEditingController(text: '0byte');


  static const String _ipFieldLabelText = 'Receiver Ipaddress';
  static const double _ipFieldOutPadding = 10.0;
  static const TextStyle _ipFieldCommaTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Send"),
        ),

        body: _buildBody(context)
    );
  }


  Widget _buildBody(BuildContext context)
  {
    return Container(
        color: Colors.white,
        child: Column(
            children: [
              _buildIpField(context), // IPアドレスフィールド
              _buildFileSelector(),   // ファイルセレクター
              // _buildItemInfo(),       // ファイル情報
            ]
        )
    );
  }

  // Widget _buildItemInfo()
  // {
  //   return Expanded(
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           _buildItemInfoContent(icon: Icons.language_rounded, controller: _ipTextcontroller),     // ip
  //           _buildItemInfoContent(icon: Icons.file_present, controller: _fileNameTextcontroller),   // file name
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildItemInfoContent({required IconData? icon, required TextEditingController controller})
  // {
  //   return TextField(
  //     textAlignVertical: TextAlignVertical.center,
  //     textAlign: TextAlign.left,
  //     enabled: false,
  //     readOnly: true,
  //     controller: controller,
  //     decoration: InputDecoration(
  //       prefixIcon: Icon(icon),
  //     ),
  //   );
  // }

  Widget _buildIpField(BuildContext context)
  {
    return Container(
      padding: const EdgeInsets.all(_ipFieldOutPadding),
      color: Colors.white,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: _ipFieldLabelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              _buildOctetField(),
              _buildComma(),
              _buildOctetField(),
              _buildComma(),
              _buildOctetField(),
              _buildComma(),
              _buildOctetField(textInputAction: TextInputAction.done),
            ],
          ),
        ),
        // ),
      ),
    );
  }

  Widget _buildComma()
  {
    return Container(
      alignment: Alignment.bottomCenter,
      child: const Text(
        ".",
        textAlign: TextAlign.center,
        style: _ipFieldCommaTextStyle,
      ),
    );
  }

  Widget _buildOctetField({textInputAction=TextInputAction.next})
  {
    return Expanded(
      child: SizedBox(
        height: 30,
        child: TextField(
          textInputAction: textInputAction,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(),
          ),
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _buildFileSelector()
  {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.file_present,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: Text(
                    _selectFile,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton.icon(
            label: const Text("select file"),
            icon: const Icon(Icons.search),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                File file = File(result.files.single.path!);
                setState(() {
                  _selectFile = basename(file.path);
                });
              }
            },
          ),
        ),
      ],
    );
  }
}

