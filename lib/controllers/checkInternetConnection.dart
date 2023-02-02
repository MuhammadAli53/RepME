import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckInternetConnection {
  static Future<void> check(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

      }
    } on SocketException catch (_) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(

              title: const Text('No Internet'),
              content: const Text('Please check your internet connection.'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: const Text('Exit'),
                ),
              ],
            );
          });
    }
  }
}
