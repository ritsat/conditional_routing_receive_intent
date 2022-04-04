import 'dart:async';

import 'package:conditional_routing/home_screen.dart';
import 'package:conditional_routing/init_data.dart';
import 'package:conditional_routing/show_data_argument.dart';
import 'package:conditional_routing/show_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

const String homeRoute = "home";
const String showDataRoute = "showData";

Future<InitData> init() async {
  String sharedText = "";
  String routeName = homeRoute;
  //This shared intent work when application is closed
  String? sharedValue = await ReceiveSharingIntent.getInitialText();
  if (sharedValue != null) {
    sharedText = sharedValue;
    routeName = showDataRoute;
  }
  return InitData(sharedText, routeName);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InitData initData = await init();
  runApp(MyApp(initData: initData));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.initData}) : super(key: key);

  final InitData initData;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navKey = GlobalKey<NavigatorState>();

  late StreamSubscription _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();

    //This shared intent work when application is in memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      _navKey.currentState!.pushNamed(
        showDataRoute,
        arguments: ShowDataArgument(value),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _intentDataStreamSubscription.cancel();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case homeRoute:
            return MaterialPageRoute(builder: (_) => HomeScreen());
          case showDataRoute:
            {
              if (settings.arguments != null) {
                final args = settings.arguments as ShowDataArgument;
                return MaterialPageRoute(
                    builder: (_) => ShowDataScreen(
                          sharedText: args.sharedText,
                        ));
              } else {
                return MaterialPageRoute(
                    builder: (_) => ShowDataScreen(
                          sharedText: widget.initData.sharedText,
                        ));
              }
            }
        }
      },
      initialRoute: widget.initData.routeName,
    );
  }
}
