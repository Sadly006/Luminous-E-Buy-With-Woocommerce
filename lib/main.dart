import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Providers/theme_provider.dart';
import 'Screens/Authentications/sign_in.dart';
import 'Screens/OnBoarding/onboard.dart';
import 'Screens/front_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51KMUcMLQfbdHsu5AMMRAx55TScDvgY03S7c56cJJP7561raSVBBUCs8XHrQHMEHXbIevYJl4CUH4ANEIlTw7dWYm00CzNfxA7L";
  await Firebase.initializeApp();
  //await Stripe.instance.applySettings();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('consKey', "ck_825fd42d48673cc5acf4505f3d4ade0c50781cee");
  prefs.setString('consSecret', "cs_16950d98f2c9ddfc3112e57fa325302f8390b451");
  var token = prefs.getString('token');
  var onboarded = prefs.getBool('onboarded');
  onboarded ??= false;
  token ??= "not found";

  SharedPreferences.getInstance().then((prefs) async {
    var isDarkTheme = prefs.getBool("darkTheme") ?? false;
    return runApp(
      ChangeNotifierProvider<ThemeProvider>(
        child: MyApp(token: token, onboarded: onboarded),
        create: (BuildContext context) {
          return ThemeProvider(isDarkTheme);
        },
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  var token;
  bool? onboarded;
  MyApp({Key? key, required this.token, required this.onboarded}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  getHome(){
    if(widget.onboarded == false){
      return OnBoard();
    }
    else{
      if(widget.token == "not found"){
        return const SignIn();
      }
      else{
        return FrontPage(consKey: "ck_a7d5c001d8dc8b79799488cf0e06bf6043b7da10", consSecret: "cs_0e87ba8f8c94178368fdba9ac58c16f46b13ac19",);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, value, child) {
          return MaterialApp(
              theme: value.getTheme(),
              home: getHome(),
              //home: SplashScreen(token: widget.token,),
          );
        }
    );
  }
}






