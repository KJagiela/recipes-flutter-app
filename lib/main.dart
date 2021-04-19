import 'package:flutter/material.dart';
import 'add_recipe.dart';
import 'init.dart';
import 'splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Future _initFuture = Init.initialize();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes',
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done) {
            return AddRecipe();
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }
}
