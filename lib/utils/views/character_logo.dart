import 'package:flutter/material.dart';

import 'package:silkroad/app_theme.dart';

class CharacterLogo extends StatelessWidget{
  const CharacterLogo(
    {
      super.key,
    }
  );

  @override
  Widget build(BuildContext context){
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.headline6?.copyWith(fontFamily: 'Klee_One', fontWeight: FontWeight.w600, fontSize: 24),
        children: const <InlineSpan>[
          TextSpan(
            text: 'S',
            style: TextStyle(color: AppTheme.appIconColor1),
          ),

          TextSpan(
            text: 'ilk',
          ),

          TextSpan(
            text: 'R',
            style: TextStyle(color: AppTheme.appIconColor2),
          ),

          TextSpan(
            text: 'oad',
          ),
        ]
      ),
    );
  }
}
