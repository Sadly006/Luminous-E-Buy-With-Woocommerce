import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/front_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        color: const Color.fromRGBO(152, 251, 152, 1),
        child: Column(
          children: [
            SizedBox(
              height: displayHeight(context)*0.5,
              child: const Center(
                child: Icon(
                  Icons.check,
                  size: 200,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              child: Column(
                children: [
                  Text(
                    "Order Placed!",
                    style: TextStyle(
                        fontSize: titleSize
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
                          Navigator.popUntil(context, ModalRoute.withName(''));
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
