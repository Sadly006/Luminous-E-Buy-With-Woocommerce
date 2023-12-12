import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Screen Sizes/screen_size_page.dart';
import '../front_page.dart';

class ErrorScreen extends StatelessWidget {
  ErrorScreen({Key? key, required this.errorMessage}) : super(key: key);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        color: const Color.fromRGBO(237, 41, 57, 1),
        child: Column(
          children: [
            SizedBox(
              height: displayHeight(context)*0.5,
              child: const Center(
                child: Icon(
                  Icons.clear,
                  size: 200,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              child: Column(
                children: [
                  Container(
                    width: displayWidth(context)*0.7,
                    child: Text(
                      errorMessage.toString(),
                      style: TextStyle(
                          fontSize: titleSize,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(20)),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                        ),
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String consKey = prefs.getString("consKey") as String;
                          String consSecret = prefs.getString("consSecret") as String;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FrontPage(consKey: consKey, consSecret: consSecret),
                              )
                          );
                        },
                        child: Text("Go to Home")
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
