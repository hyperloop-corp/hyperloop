import 'package:flutter/material.dart';
import 'package:hyperloop/app/pages/pages.dart';

class Router {
  final RouteObserver<PageRoute> routeObserver;

  Router({@required this.routeObserver});

  Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Pages.landing:
        return _buildRoute(settings, LandingPage());
      case Pages.home:
        return _buildRoute(settings, HomePage());
      case Pages.login:
        return _buildRoute(settings, LoginPage());
      case Pages.register:
        return _buildRoute(settings, RegisterPage());
      case Pages.payment:
        return _buildRoute(settings, PaymentPage());
      case Pages.tickets:
        return _buildRoute(settings, TicketsPage());
      default:
        return null;
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return new MaterialPageRoute(
      settings: settings,
      builder: (context) => builder,
    );
  }
}
