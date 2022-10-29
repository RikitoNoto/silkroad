import 'package:flutter/material.dart';
import 'package:platform/platform.dart';

import 'option_input.dart';
import '../params.dart';

class OptionPage extends StatefulWidget {
  const OptionPage({super.key, required this.platform});

  final Platform platform;

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              floating: true,
              pinned: false,
              snap: false,
              title: Text('Option'),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    child: OptionInput.construct(Params.values[index]),
                  );
                },
                childCount: Params.values.length,
              ),
            ),
          ],
        ),
      )
    );
  }
}
