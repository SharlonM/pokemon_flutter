import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  static Widget logo() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      child: Image.asset(
        "lib/images/pokemon-png-logo.png",
        height: 80,
        width: 300,
      ),
    );
  }

  static TextStyle getStyle(double size, {FontStyle? fs, cor}) {
    return TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: cor ?? Colors.blueAccent,
        fontStyle: fs);
  }

  static appBar(String _title) {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            "lib/images/pikachu.png",
            height: 60,
            width: 85,
            alignment: Alignment.centerLeft,
          ),
          Expanded(
            child: Center(
              child: Text(
                _title,
                style: Utils.getStyle(22),
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          Image.asset(
            "lib/images/pikachu.png",
            height: 60,
            width: 85,
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
      backgroundColor: Colors.amber,
      titleSpacing: 0,
      centerTitle: true,
    );
  }
}
