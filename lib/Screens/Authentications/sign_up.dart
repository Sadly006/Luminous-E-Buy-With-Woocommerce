import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Functions/google_sign_in.dart';
import 'package:luminous_e_buy/Functions/masked_text.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/Authentications/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../front_page.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final first_name = TextEditingController();
  final last_name = TextEditingController();
  final user_name = TextEditingController();
  final contact_number = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm_password = TextEditingController();

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
    first_name.dispose();
    last_name.dispose();
    user_name.dispose();
    contact_number.dispose();
    confirm_password.dispose();
  }

  _validator() async {
    if(password.text.toString()==confirm_password.text.toString()){
      final response = await http.post(
          Uri.parse(API().signUpApi),
          body:{
            'first_name': first_name.text.toString(),
            'last_name': last_name.text.toString(),
            'user_name': user_name.text.toString(),
            'contact_number': contact_number.text.toString(),
            'email': email.text.toString(),
            'password': password.text.toString(),
            'confirm_password': confirm_password.text.toString(),
          }
      );
      print("res: "+response.body);

      if(response.body=="succeeded") {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email.text.toString());
        prefs.setString('consKey', "ck_825fd42d48673cc5acf4505f3d4ade0c50781cee");
        prefs.setString('consSecret', "cs_16950d98f2c9ddfc3112e57fa325302f8390b451");
        Navigator.popUntil(context, ModalRoute.withName(''));
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>FrontPage(consKey: "ck_825fd42d48673cc5acf4505f3d4ade0c50781cee", consSecret: "cs_16950d98f2c9ddfc3112e57fa325302f8390b451",),
            )
        );      }
      else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Alert!!"),
              content: const Text("Email or Password incorrect"),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text("Alert!!"),
            content: Text("Password must match"),
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
                    padding: EdgeInsets.fromLTRB(20, 3, 0, 10),
                    child: Text(
                      "JOIN US NOW!!",
                      style: TextStyle(
                        fontSize: 23,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 3, 0, 10),
                    child: Text(
                      "Already have an account? ",
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
                          onSurface: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignIn()),
                          );
                        },
                        child: Text('Sign In!',
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
                  child: TextFormField(
                    controller: first_name,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'First Name',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Center(
                  child: TextFormField(
                    controller: last_name,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Last Name',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Center(
                  child: TextFormField(
                    controller: user_name,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Username',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Center(
                  child: TextFormField(
                    controller: email,
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
                    inputFormatters: [
                      MaskedTextInputFormatter(
                        mask: 'xxxxx-xxxxxx',
                        separator: '-',
                      ),
                    ],
                    controller: contact_number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Contact Number',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Center(
                  child: TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Password',
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Center(
                  child: TextFormField(
                    obscureText: true,
                    controller: confirm_password,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Confirm Password',
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
                child: SizedBox(
                  width: displayHeight(context) * 0.45,
                  height: displayHeight(context) * 0.07,
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState!.showSnackBar(
                          SnackBar(content:
                          Row(
                            children: const <Widget>[
                              CircularProgressIndicator(),
                              Text("  Signing-Up...")
                            ],
                          ),
                          )
                      );
                      _validator();
                    },
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      child: const Center(
                        child: Text(
                            "Sign Up"
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              const Padding(padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "Sign Up with,",
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

