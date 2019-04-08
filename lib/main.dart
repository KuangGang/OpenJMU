import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:OpenJMU/constants/Constants.dart';
import 'package:OpenJMU/events/Events.dart';
import 'package:OpenJMU/utils/DataUtils.dart';
import 'package:OpenJMU/utils/ThemeUtils.dart';

// Routes Pages
import 'package:OpenJMU/pages/SplashPage.dart';
import 'package:OpenJMU/pages/LoginPage.dart';
import 'package:OpenJMU/pages/MainPage.dart';
import 'package:OpenJMU/pages/ChangeThemePage.dart';
import 'package:OpenJMU/pages/PublishPostPage.dart';
import 'package:OpenJMU/pages/Test.dart';

void main() {
  runApp(new JMUAppClient());
}

class JMUAppClient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new JMUAppClientState();
}

class JMUAppClientState extends State<JMUAppClient> {
  bool isUserLogin = false;

  Brightness currentBrightness;
  Color currentPrimaryColor;
  Color currentThemeColor;

  @override
  void initState() {
    super.initState();
    listenToBrightness();
    currentThemeColor = ThemeUtils.currentColorTheme;
    Constants.eventBus.on<LogoutEvent>().listen((event) {
      setState(() {
        currentBrightness = Brightness.light;
        currentPrimaryColor = Colors.white;
      });
    });
    Constants.eventBus.on<ChangeThemeEvent>().listen((event) {
      setState(() {
        currentThemeColor = event.color;
      });
    });
  }

  // 监听夜间模式变化
  void listenToBrightness() {
    DataUtils.getBrightnessDark().then((isDark) {
      if (isDark == null) {
        DataUtils.setBrightnessDark(false).then((whatever) {
          setState(() {
            currentBrightness = Brightness.light;
            currentPrimaryColor = Colors.white;
          });
        });
      } else {
        if (isDark) {
          setState(() {
            currentBrightness = Brightness.dark;
            currentPrimaryColor = Colors.grey[850];
          });
        } else {
          setState(() {
            currentBrightness = Brightness.light;
            currentPrimaryColor = Colors.white;
          });
        }
      }
    });
    Constants.eventBus.on<ChangeBrightnessEvent>().listen((event) {
      setState(() {
        currentBrightness = event.brightness;
        currentPrimaryColor = event.primaryColor;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: <String,WidgetBuilder>{
          "/splash": (BuildContext context) => new SplashPage(),
          "/login": (BuildContext context) => new LoginPage(),
          "/home": (BuildContext context) => new MainPage(),
          "/changeTheme": (BuildContext context) => new ChangeThemePage(),
          "/publishPost": (BuildContext context) => new PublishPostPage(),
          "/test": (BuildContext context) => new TestPage(),
        },
        title: "OpenJMU",
        theme: new ThemeData(
          accentColor: currentThemeColor,
          primaryColor: currentPrimaryColor,
          primaryColorBrightness: Brightness.dark,
          primaryIconTheme: new IconThemeData(color: currentPrimaryColor),
          brightness: currentBrightness,
        ),
        home: new SplashPage()
    );
  }
}
