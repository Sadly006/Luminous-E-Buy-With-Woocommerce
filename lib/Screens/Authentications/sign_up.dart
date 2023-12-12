
import 'package:flutter/material.dart';
import 'package:luminous_e_buy/APIs/apis.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/Authentications/sign_in.dart';
import 'package:luminous_e_buy/Services/google_sign_in.dart';
import 'package:luminous_e_buy/Services/masked_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Services/woocommerce_api_call.dart';
import '../front_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final contactNumber = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

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
    firstName.dispose();
    lastName.dispose();
    userName.dispose();
    contactNumber.dispose();
    confirmPassword.dispose();
  }

  _validator() async {
    if (password.text.toString() == confirmPassword.text.toString()) {
      // final response = await http.post(
      //     Uri.parse(API().signUpApi),
      //     body:{
      //       'first_name': firstName.text.toString(),
      //       'last_name': lastName.text.toString(),
      //       'user_name': userName.text.toString(),
      //       'contact_number': contactNumber.text.toString(),
      //       'email': email.text.toString(),
      //       'password': password.text.toString(),
      //       'confirm_password': confirmPassword.text.toString(),
      //     }
      // );
      //
      // if(response.body=="succeeded") {
      //
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   prefs.setString('email', email.text.toString());
      //   prefs.setString('consKey', "ck_825fd42d48673cc5acf4505f3d4ade0c50781cee");
      //   prefs.setString('consSecret', "cs_16950d98f2c9ddfc3112e57fa325302f8390b451");
      //   Navigator.popUntil(context, ModalRoute.withName(''));
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) =>FrontPage(consKey: "ck_825fd42d48673cc5acf4505f3d4ade0c50781cee", consSecret: "cs_16950d98f2c9ddfc3112e57fa325302f8390b451",),
      //       )
      //   );
      // }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String consKey = prefs.getString("consKey") as String;
      String consSecret = prefs.getString("consSecret") as String;
      WoocommerceAPI woocommerceAPI1 = WoocommerceAPI(
          url: API().signUpApi,
          consumerKey: consKey,
          consumerSecret: consSecret);
      var response = await woocommerceAPI1.postAsync(
          "?username=" +
              userName.text.toString() +
              "&email=" +
              email.text.toString() +
              "&password=" +
              password.text.toString(),
          {});

      if (response["code"] == 200) {
        prefs.setString('token', 'true');
        prefs.setString('userName', userName.text.toString());
        prefs.setString('email', email.text.toString());
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
              content: Text(response['message']),
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
    } else {
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
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 50)),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 3, 0, 10),
                    child: Text(
                      "JOIN US NOW!!",
                      style: TextStyle(
                        fontSize: 23,
                        color: Theme.of(context).highlightColor,
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
                      "Already have an account? ",
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
                          onSurface: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignIn()),
                          );
                        },
                        child: Text(
                          'Sign In!',
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
                  child: TextFormField(
                    controller: firstName,
                    decoration: InputDecoration(
                      filled: true,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Center(
                  child: TextFormField(
                    controller: lastName,
                    decoration: InputDecoration(
                      filled: true,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Center(
                  child: TextFormField(
                    controller: userName,
                    decoration: InputDecoration(
                      filled: true,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Center(
                  child: TextFormField(
                    controller: email,
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
                    inputFormatters: [
                      MaskedTextInputFormatter(
                        mask: 'xxxxx-xxxxxx',
                        separator: '-',
                      ),
                    ],
                    controller: contactNumber,
                    decoration: InputDecoration(
                      filled: true,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Center(
                  child: TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                      filled: true,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Center(
                  child: TextFormField(
                    obscureText: true,
                    controller: confirmPassword,
                    decoration: InputDecoration(
                      filled: true,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: SizedBox(
                  width: displayHeight(context) * 0.45,
                  height: displayHeight(context) * 0.07,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                          children: const <Widget>[
                            CircularProgressIndicator(),
                            Text("  Signing-Up...")
                          ],
                        ),
                      ));
                      _validator();
                    },
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      child: const Center(
                        child: Text("Sign Up"),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "Sign Up with,",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
