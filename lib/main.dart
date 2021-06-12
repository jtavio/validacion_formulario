import 'package:flutter/material.dart';
import 'package:formulario_validacion/src/bloc/provider.dart';
import 'package:formulario_validacion/src/pages/home_page.dart';
import 'package:formulario_validacion/src/pages/login_page.dart';
import 'package:formulario_validacion/src/pages/producto_page.dart';
import 'package:formulario_validacion/src/pages/registro_page.dart';
import 'package:formulario_validacion/src/preferencias_usuario/Preferencias_usuario.dart';

void main() async {
  //singelton
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    print(prefs.token);
    return Provider(
      child: MaterialApp(
          title: 'Material App',
          debugShowCheckedModeBanner: false,
          initialRoute: 'login',
          routes: {
            'login': (BuildContext context) => LoginPage(),
            'registro': (BuildContext context) => RegistroPage(),
            'home': (BuildContext context) => HomePage(),
            'producto': (BuildContext context) => ProductoPage()
          },
          theme: ThemeData(primaryColor: Colors.purple)),
    );
  }
}
