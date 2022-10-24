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
    Size screenSize = MediaQuery.of(context).size;
    return Card(
      borderOnForeground: false,
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
        child: Row(
          children: [
            SizedBox(
              width: screenSize.width * 0.3,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
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

