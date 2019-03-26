import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/Constants.dart';
import '../events/TicketGotEvent.dart';
import '../events/TicketFailedEvent.dart';
import '../utils/DataUtils.dart';
import '../utils/ThemeUtils.dart';
import 'MainPage.dart';
import 'LoginPage.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<SplashPage> {
  Timer timer;
  bool isUserLogin = false;

  @override
  void initState() {
    super.initState();
    DataUtils.isLogin().then((isLogin) {
      if (isLogin) {
        DataUtils.getTicket();
      } else {
        Constants.eventBus.fire(new TicketFailedEvent());
      }
    });
    Constants.eventBus.on<TicketGotEvent>().listen((event) {
      setState(() {
        this.isUserLogin = true;
        navigate();
      });
    });
    Constants.eventBus.on<TicketFailedEvent>().listen((event) {
      setState(() {
        this.isUserLogin = false;
        navigate();
      });
    });
  }

  void navigate() {
    timer = new Timer(const Duration(milliseconds: 1500), () {
      if (!isUserLogin) {
        try {
          Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => new LoginPage()
            ),
          );
        } catch (e) {}
      } else {
        try {
          Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
                builder: (BuildContext context) => new MainPage()
            ),
          );
        } catch (e) {}
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Padding buildLogo() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Image.asset(
        './images/ic_jmu_logo.png',
        width: 128.0,
        height: 128.0,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Builder(
          builder: (context) =>
              new Stack(
                children: <Widget>[
                  new Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        colors: const <Color>[
                          ThemeUtils.defaultColor,
                          Colors.redAccent
                        ],
                      ),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                            padding: const EdgeInsets.all(10.0),
                            child: new Center(
                              child: new Column(
                                children: <Widget>[
                                  buildLogo(),
                                  new Text(
                                      "集小通",
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 48.0,
                                        letterSpacing: 4.0
                                      )
                                  ),
                                  SizedBox(height: 90.0),
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
//                  new Align(
//                    alignment: AlignmentGeometry
//                  )
                ]
              )
        )
    );
  }
}
