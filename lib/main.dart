import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Providers/theme_provider.dart';
import 'Screens/Authentications/sign_in.dart';
import 'Screens/OnBoarding/onboard.dart';
import 'Screens/front_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('consKey', "ck_a0094219bf70a3a30e0a66439751119f12910226");
  prefs.setString('consSecret', "cs_eb45f6ecb77584397f63a272b401413311076e33");
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
        return FrontPage(consKey: "ck_0c6098aaa736c3ae5869de1c701ba3c7b76bff1b", consSecret: "cs_b2fc56341982a8217eb9415643fa4c5f3628b163",);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, value, child) {
          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('de', ''),
            ],
              theme: value.getTheme(),
              home: getHome(),
              //home: SplashScreen(token: widget.token,),
          );
        }
    );
  }
}






