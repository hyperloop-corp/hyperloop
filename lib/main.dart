import 'package:flutter/material.dart';
import 'package:hyperloop/app/pages/pages.dart';
import 'package:hyperloop/app/utils/router.dart';

import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Router _router = Router(routeObserver: RouteObserver<PageRoute>());

    return MaterialApp(
        title: 'Hyperloop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: Pages.landing,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: _router.getRoute,
        navigatorObservers: [_router.routeObserver]);
  }
}
