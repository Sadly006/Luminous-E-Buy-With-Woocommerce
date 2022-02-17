import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Services/google_sign_in.dart';
import '../front_page.dart';
import 'sign_up.dart';
import 'package:http/http.dart' as http;
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
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _validator() async {
    print(userName.text.toString());
    print(password.text.toString());

    final response = await http.post(
        Uri.parse(API().signInApi),
        headers: {
          "Content-Type": "application/json",
        },
        body:json.encode({
          "userName": userName.text.toString(),
          "password": password.text.toString(),
        })
    );

    if(response.statusCode==200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = json.decode(response.body);
      prefs.setString('token', token["accessToken"].toString());
      Navigator.popUntil(context, ModalRoute.withName(''));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>FrontPage(consKey: "ck_0c6098aaa736c3ae5869de1c701ba3c7b76bff1b", consSecret: "cs_b2fc56341982a8217eb9415643fa4c5f3628b163",),
          )
      );
    }
    else{
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
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 50)
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 3),
                    child: Text(
                      "HI THERE,",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
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
                        color: Theme.of(context).accentColor,
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
                        color: Theme.of(context).accentColor,
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
                            MaterialPageRoute(builder: (context) => const SignUp()),
                          );
                        },
                        child: Text('Sign Up!',
                          style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Center(
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: userName,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Center(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    obscureText: _obscureText,
                    controller: password,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: GestureDetector(
                  child: SizedBox(
                    width: displayHeight(context) * 0.45,
                    height: displayHeight(context) * 0.07,
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      child: const Center(
                        child: Text(
                            "Sign In"
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    _scaffoldKey.currentState!.showSnackBar(
                        SnackBar(content:
                          Row(
                            children: const <Widget>[
                              CircularProgressIndicator(),
                              Text("  Signing-In...")
                            ],
                          ),
                        )
                    );
                    _validator();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Center(
                  child: Text(
                    "OR,",
                    style: TextStyle(
                      color: Theme.of(context).accentColor
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.pop(context, true);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>FrontPage(consKey: "ck_0c6098aaa736c3ae5869de1c701ba3c7b76bff1b", consSecret: "cs_b2fc56341982a8217eb9415643fa4c5f3628b163",),
                          )
                      );
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
              const Padding(padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "Sign In with,",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.all(20)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: SizedBox(
                        width: 50,
                        child: TextButton(
                          onPressed: () {

                          },
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
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: SizedBox(
                        width: 50,
                        child: TextButton(
                          onPressed: () {

                          },
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

