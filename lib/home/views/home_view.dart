import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: SizedBox(
                height: 50,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'your name',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 1,
                ),
              ),
            ),


            _buildActionSelectButton(label: 'Send', svgPath: 'assets/icons/transfer-in.svg',),
            _buildActionSelectButton(label: 'Receive', svgPath: 'assets/icons/transfer-out.svg',),
          ]
        ),
      ),
    );
  }

  Widget _buildActionSelectButton({required String label, required String svgPath}){
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: ElevatedButton(
          onPressed:() {},
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                SvgPicture.asset(
                  svgPath,
                ),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
