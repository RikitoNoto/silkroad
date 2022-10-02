import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:silkroad/utils/views/theme_input_field.dart';

class SendPage extends StatefulWidget {
  const SendPage({super.key});

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage>{
  String _selectFile = "No select";

  static const String _ipFieldLabelText = 'Receiver Ipaddress';
  static const double _ipFieldOutPadding = 10.0;
  static const TextStyle _ipFieldCommaTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Send"),
        ),

        body: _buildBody(context),
        floatingActionButton: FloatingActionButton(
          onPressed: ()=>{

          },
          tooltip: 'Send',
          child: const Icon(Icons.send),
        ),
      ),
    );
  }


  Widget _buildBody(BuildContext context)
  {
    return Container(
        color: Colors.white,
        child: Column(
            children: [
              _buildIpField(context), // ip address input field
              _buildFileSelector(),   // file selector
            ]
        )
    );
  }

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
              //TODO: input action next does not work, because input field is in other state.
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

        child: ThemeInputField(
          textInputAction: textInputAction,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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

