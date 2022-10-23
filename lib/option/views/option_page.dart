import 'package:flutter/material.dart';
import 'package:platform/platform.dart';

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
            SliverAppBar(
              floating: true,
              pinned: false,
              snap: false,
              title: const Text('Option'),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    // color: index.isOdd ? Colors.white : Colors.black12,
                    // height: 100.0,
                    child: OptionNumberInput(label: '$index'),
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}

class OptionNumberInput extends StatelessWidget{
  const OptionNumberInput({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: false,
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(this.label),
            Expanded(
              child: TextField(

              ),
            ),
          ],
        ),
      ),
    );
  }
}

