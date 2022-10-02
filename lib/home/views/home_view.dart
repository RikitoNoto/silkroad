import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:silkroad/utils/views/theme_input_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: SizedBox(
                  height: 50,
                  child: ThemeInputField(
                    labelText: 'Your name',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              _buildActionSelectButton(label: 'Send', svgPath: 'assets/icons/transfer-in.svg',),
              _buildActionSelectButton(label: 'Receive', svgPath: 'assets/icons/transfer-out.svg',),
            ]
          ),
        ),
      ),
    );
  }

  Widget _buildActionSelectButton({required String label, required String svgPath}){
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
        child: ElevatedButton(
          onPressed:() {},
          child: SizedBox(
            height: 200,
            // width: 200,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  svgPath,
                  height: 90,
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
