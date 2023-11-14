import 'package:Duet_Classified/screens/color_helper.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 60,
        height: 60,
        child: CircularProgressIndicator(
          backgroundColor: HexColor().withOpacity(0.3),
          strokeWidth: 8,
          color: HexColor(),
        ),
      ),
    );
  }
}
