import 'package:flutter/material.dart';
import 'package:formulario_validacion/src/bloc/login_bloc.dart';
export 'package:formulario_validacion/src/bloc/login_bloc.dart';

import 'package:formulario_validacion/src/bloc/productos_bloc.dart';
export 'package:formulario_validacion/src/bloc/productos_bloc.dart';

//clase provider puede tener cualquier nombre
//maneja multiple instancia de bloc o de objeto y maje todo este lugar
class Provider extends InheritedWidget {
  final loginBloc = LoginBloc();

  final _productosBloc = new ProductosBloc();

  static Provider? _instancia;

  factory Provider({Key? key, required Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia!;
  }
  Provider._internal({Key? key, required Widget child})
      : super(key: key, child: child);

  //Provider({Key? key, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()!.loginBloc;
  }

  static ProductosBloc productosBloc(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()!
        ._productosBloc;
  }
}
