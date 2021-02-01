import 'package:flutter/material.dart';
import 'resources/app_config.dart';
import 'main.dart';

void main(){
  var config = AppConfig(appTitle: 'Flutter Flavors', buildFlavor: 'Production', child: MyApp(),);

  return runApp(config);
}