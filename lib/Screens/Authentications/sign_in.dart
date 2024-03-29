import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Services/google_sign_in.dart';
import '../../Services/woocommerce_api_call.dart';
import '../front_page.dart';
import 'sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late var token;
  final userName = TextEditingController();
  final password = TextEditingController();
  late String consKey;
  late String consSecret;
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _validator() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    consKey = prefs.getString("consKey") as String;
    consSecret = prefs.getString("consSecret") as String;
    WoocommerceAPI woocommerceAPI1 = WoocommerceAPI(
        url: API().signInApi, consumerKey: consKey, consumerSecret: consSecret);
    var response = await woocommerceAPI1.getAsync("?username=" +
        userName.text.toString() +
        "&password=" +
        password.text.toString());
    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      prefs.setString('token', 'true');
      prefs.setString('userName', res['data']['user_login']);
      prefs.setString('email', res['data']['user_email']);
      Navigator.popUntil(context, ModalRoute.withName(''));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FrontPage(
              consKey: consKey,
              consSecret: consSecret,
            ),
          ));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alert!!"),
            content: const Text("UserName or Password incorrect"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 50)),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 3),
                    child: Text(
                      "HI THERE,",
                      style: TextStyle(
                        color: Theme.of(context).highlightColor,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 3, 0, 10),
                    child: Text(
                      "WELCOME!!",
                      style: TextStyle(
                        color: Theme.of(context).highlightColor,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 3, 0, 10),
                    child: Text(
                      "If you are new, ",
                      style: TextStyle(
                        color: Theme.of(context).highlightColor,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 0, 10),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          onSurface: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()),
                          );
                        },
                        child: Text(
                          'Sign Up!',
                          style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).primaryColor,
                          ),
                        )),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Center(
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: userName,
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Email',
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Center(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    obscureText: _obscureText,
                    controller: password,
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Password",
                      suffixIcon: InkWell(
                        onTap: _toggle,
                        child: Icon(
                          _obscureText
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye_outlined,
                          size: 20.0,
                          color: _obscureText
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: GestureDetector(
                  child: SizedBox(
                    width: displayHeight(context) * 0.45,
                    height: displayHeight(context) * 0.07,
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      child: const Center(
                        child: Text("Sign In"),
                      ),
                    ),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                        children: const <Widget>[
                          CircularProgressIndicator(),
                          Text("  Signing-In...")
                        ],
                      ),
                    ));
                    _validator();
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Center(
                  child: Text(
                    "OR,",
                    style: TextStyle(color: Theme.of(context).highlightColor),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('userName', 'Guest');
                      prefs.setString('email', 'user@gmail.com');
                      consKey = prefs.getString("consKey") as String;
                      consSecret = prefs.getString("consSecret") as String;
                      Navigator.pop(context, true);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FrontPage(
                              consKey: consKey,
                              consSecret: consSecret,
                            ),
                          ));
                    },
                    child: Text(
                      "Continue as a guest",
                      style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "Sign In with,",
                    style: TextStyle(
                        color: Theme.of(context).highlightColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.all(20)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: SizedBox(
                        width: 50,
                        child: TextButton(
                          onPressed: () {
                            GoogleSigning().signInWithGoogle(context: context);
                          },
                          child: const Image(
                            image: AssetImage('assets/google.png'),
                            fit: BoxFit.contain,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: SizedBox(
                        width: 50,
                        child: TextButton(
                          onPressed: () {},
                          child: const Image(
                            image: AssetImage('assets/facebook.png'),
                            fit: BoxFit.contain,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: SizedBox(
                        width: 50,
                        child: TextButton(
                          onPressed: () {},
                          child: const Image(
                            image: AssetImage('assets/twitter.png'),
                            fit: BoxFit.contain,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
