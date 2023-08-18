import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:platform/platform.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import 'package:silkroad/app_theme.dart';
import 'package:silkroad/send/providers/send_provider.dart';
import 'package:silkroad/utils/models/animated_list_item_model.dart';
import 'package:silkroad/utils/views/theme_input_field.dart';
import 'package:silkroad/i18n/translations.g.dart';
import 'package:silkroad/utils/views/wait_progress_dialog.dart';

import '../../utils/views/theme_animated_list_item.dart';
import '../entities/sendible_device.dart';

class SendPage extends StatefulWidget {
  const SendPage({required this.platform, super.key});

  final Platform platform;

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> with RouteAware {
  late final SendProvider provider;

  static final String _ipFieldLabelText = t.send.receiverAddress;
  static const double _ipFieldOutPadding = 10.0;
  static const TextStyle _ipFieldCommaTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );

  final _listKey = GlobalKey<AnimatedListState>();
  late final AnimatedListItemModel<SendibleDevice> _sendibleDevices;

  final List<TextEditingController> _octetTextControllers =
      List.generate(4, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _sendibleDevices = AnimatedListItemModel(
        listKey: _listKey, removedItemBuilder: _removeItem);
    provider = SendProvider(
        platform: const LocalPlatform(), sendibleList: _sendibleDevices);
  }

  @override
  void dispose() {
    provider.close();
    super.dispose();
  }

  @override
  void didPop() {
    provider.close();
  }

  @override
  void didPushNext() {
    provider.close();
  }

  List<Widget> _getDebugActions() {
    List<Widget> debugActions = [];
    if (kDebugMode) {
      debugActions.add(IconButton(
        icon: const Icon(Icons.add_circle),
        onPressed: _debugInsertItem,
      ));

      debugActions.add(
        IconButton(
          icon: const Icon(Icons.remove_circle),
          onPressed: _debugRemoveItem,
        ),
      );
    }

    return debugActions;
  }

  void _debugInsertItem() {
    _sendibleDevices.append(const SendibleDevice(ipAddress: "127.0.0.1"));
  }

  void _debugRemoveItem() {
    if (_sendibleDevices.length > 0) {
      setState(() {
        _sendibleDevices.removeAt(0);
      });
    }
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    return AddListItem(
      title: Text(
        _sendibleDevices[index].ipAddress,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 20,
        ),
        textAlign: TextAlign.left,
      ),
      platform: widget.platform,
      index: index,
      animation: animation,
      onSelect: (context) {
        for (int i = 0; i < _octetTextControllers.length; i++) {
          _octetTextControllers[i].text =
              _sendibleDevices[index].ipAddress.split(".")[i];
        }
      },
      onDelete: (context) => provider.sendibleListRemoveAt(index),
    );
  }

  Widget _removeItem(SendibleDevice item, int index, BuildContext context,
      Animation<double> animation) {
    return RemoveListItem(
      platform: widget.platform,
      index: index,
      title: Text(
        item.ipAddress,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 20,
        ),
        textAlign: TextAlign.left,
      ),
      animation: animation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => provider,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(t.actions.send),
            actions: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: AppTheme.appIconColor1,
                    ),
                    onPressed: () async {
                      WaitProgressDialog.show(
                          context); // show wait progress dialog.
                      for (int i = 0; i < _octetTextControllers.length; i++) {
                        provider.setOctet(
                            i, int.parse(_octetTextControllers[i].text));
                      }

                      String message = (await provider.send()).message; // send.
                      if (!mounted) return;
                      WaitProgressDialog.close(
                          context); // close wait progress dialog.
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(message)));
                    },
                  )
                ] +
                _getDebugActions(),
          ),
          body: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(children: [
      _buildIpField(context), // ip address input field
      _buildFileSelector(), // file selector
      Consumer<SendProvider>(
        builder: (context, provider, child) => LinearProgressIndicator(
          value: provider.searchProgress,
          color: Colors.lightBlue,
        ),
      ),
      _SendibleList(
        listKey: _listKey,
        builder: _buildItem,
      ),
    ]);
  }

  Widget _buildIpField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_ipFieldOutPadding),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: _ipFieldLabelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          IntrinsicHeight(
            child: Row(
              children: [
                //FIXME: input action next does not work, because input field is in other state.
                _buildOctetField(
                  0,
                ),
                _buildComma(),
                _buildOctetField(
                  1,
                ),
                _buildComma(),
                _buildOctetField(
                  2,
                ),
                _buildComma(),
                _buildOctetField(
                  3,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
          Text(
            '[${t.send.sendibleAddress}]',
            textAlign: TextAlign.left,
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.all(10.0),
            child: Consumer<SendProvider>(
              builder: (context, provider, child) => ListView.builder(
                itemCount: provider.addressRangeCount,
                itemBuilder: (BuildContext context, int index) {
                  return Text(provider.addressRange[index]);
                },
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget _buildComma() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: const Text(
        ".",
        textAlign: TextAlign.center,
        style: _ipFieldCommaTextStyle,
      ),
    );
  }

  Widget _buildOctetField(int octetNumber,
      {textInputAction = TextInputAction.next, Key? key}) {
    return Expanded(
      child: SizedBox(
        height: 30,
        child: ThemeInputField(
          key: key,
          controller: _octetTextControllers[octetNumber],
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textInputAction: textInputAction,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }

  Widget _buildFileSelector() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(),
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
            label: Text(t.send.selectFile),
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

class _SendibleList extends StatelessWidget {
  const _SendibleList({
    required this.builder,
    required this.listKey,
  });

  final Key listKey;
  final Widget Function(BuildContext, int, Animation<double>) builder;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: AnimatedList(
        key: listKey,
        itemBuilder: builder,
      ),
    );
  }
}
