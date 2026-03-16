import 'package:flutter/material.dart';

import '../views/home/home_page.dart';
import '../views/clean/clean_page.dart';
import '../views/settings/settings_page.dart';
import '../views/records/records_page.dart';

class Routes {
  static const String home = '/';
  static const String clean = '/clean';
  static const String settings = '/settings';
  static const String records = '/records';
  static const String mediaDetail = '/media-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case clean:
        return MaterialPageRoute(builder: (_) => const CleanPage());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case records:
        return MaterialPageRoute(builder: (_) => const RecordsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
