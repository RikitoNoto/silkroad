import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:silkroad/send/providers/send_provider.dart';

import 'package:silkroad/utils/views/theme_input_field.dart';

class SendPage extends StatefulWidget {
  const SendPage({super.key});

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage>{
  late final SendProvider provider;

  static const String _ipFieldLabelText = 'Receiver Ipaddress';
  static const double _ipFieldOutPadding = 10.0;
  static const TextStyle _ipFieldCommaTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );

  @override
  void initState() {
    super.initState();

    provider = SendProvider();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => provider,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Send"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  provider.send();
                },
              )
            ],
          ),

          body: _buildBody(context),
        ),
      ),
    );
  }


  Widget _buildBody(BuildContext context)
  {
    return Column(
      children: [
        _buildIpField(context), // ip address input field
        _buildFileSelector(),   // file selector
      ]
    );
  }

  Widget _buildIpField(BuildContext context)
  {
    return Container(
      padding: const EdgeInsets.all(_ipFieldOutPadding),
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
              _buildOctetField(0,),
              _buildComma(),
              _buildOctetField(1,),
              _buildComma(),
              _buildOctetField(2,),
              _buildComma(),
              _buildOctetField(3, textInputAction: TextInputAction.done,),
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

  Widget _buildOctetField(int octetNumber, {textInputAction=TextInputAction.next, Key? key})
  {
    return Expanded(
      child: SizedBox(
        height: 30,

        child: ThemeInputField(
          key: key,
          keyboardType: TextInputType.number,
          onChanged: (String value)
          {
            provider.setOctet(octetNumber, int.parse(value));
          },
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                  child: Consumer<SendProvider>(
                    builder: (context, provider, child) => Text(
                      provider.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
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
                provider.file = File(result.files.single.path!);
              }
            },
          ),
        ),
      ],
    );
  }
}
