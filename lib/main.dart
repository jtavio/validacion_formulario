import 'package:flutter/material.dart';
import 'package:formulario_validacion/src/bloc/provider.dart';
import 'package:formulario_validacion/src/pages/home_page.dart';
import 'package:formulario_validacion/src/pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
          title: 'Material App',
          debugShowCheckedModeBanner: false,
          initialRoute: 'login',
          routes: {
            'login': (BuildContext context) => LoginPage(),
            'home': (BuildContext context) => HomePage()
          },
          theme: ThemeData(primaryColor: Colors.purple)),
    );
  }
}
