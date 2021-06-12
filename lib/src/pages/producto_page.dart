import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formulario_validacion/src/models/producto_model.dart';
import 'package:formulario_validacion/src/providers/productos_providers.dart';
import 'package:formulario_validacion/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formkey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productoProvider = new ProductosProvider();

  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File? foto;
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      producto = ModalRoute.of(context)!.settings.arguments as ProductoModel;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            onPressed: _seleccionarFoto,
            icon: Icon(Icons.photo_size_select_actual),
          ),
          IconButton(
            onPressed: _tomarFoto,
            icon: Icon(Icons.camera_alt),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formkey,
            child: Column(children: [
              _mostrarFoto(),
              _crearNombre(),
              _crearPrecio(),
              _crearDisponible(),
              _crearBoton()
            ]),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (newValue) => producto.titulo = newValue!,
      validator: (value) {
        if (value!.length < 3) {
          return ('Ingrese el nombre del producto');
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (newValue) => producto.valor = double.parse(newValue!),
      validator: (value) {
        if (utils.isNumeric(value!)) {
          return null;
        } else {
          return 'Solo numeros';
        }
      },
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          primary: Colors.deepPurple,
        ),
        onPressed: (_guardando) ? null : _submit,
        icon: Icon(Icons.save),
        label: Text('Guardar'));
  }

  Widget _crearDisponible() {
    return SwitchListTile(
        value: producto.disponible,
        title: Text('Disponible'),
        activeColor: Colors.deepPurple,
        onChanged: (value) => setState(() {
              producto.disponible = value;
            }));
  }

  void _submit() async {
    if (!formkey.currentState!.validate()) return;
    //disparar el save de todos los textformfield que esten dentro del form
    formkey.currentState!.save();

    //redibuja el widget

    setState(() {
      _guardando = true;
    });

    //porcesar imagen en firebase
    if (foto != null) {
      producto.fotoUrl = await productoProvider.subirImagen(foto!);
    }

    if (producto.id == null) {
      productoProvider.crearProducto(producto);
    } else {
      productoProvider.editarProducto(producto);
    }
    setState(() {
      _guardando = false;
    });
    mostrarSnackbar('Registro guardado');
    var timer = Timer(Duration(seconds: 1), () => Navigator.pop(context));
  }

  void mostrarSnackbar(String mensaje) {
    // final snackbar = SnackBar(
    //   content: Text(mensaje),
    //   duration: Duration(milliseconds: 1500),
    // );
    // scaffoldKey.currentState.showSnackBar(snackbar)(snackbar);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 2500),
        content: Text(mensaje),
      ),
    );
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(producto.fotoUrl!),
          height: 300.0,
          fit: BoxFit.contain);
    } else {
      if (foto != null) {
        return Image.file(
          foto!,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarFoto() async {
    _procesarFoto(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarFoto(ImageSource.camera);
  }

  _procesarFoto(ImageSource origen) async {
    final pickedCamera = await picker.getImage(source: origen);
    setState(() {
      if (pickedCamera != null) {
        producto.fotoUrl = null;
        //foto = File(pickedCamera.path);
      }
      // else {
      //   mostrarSnackbar('Imagen no seleccionada');
      // }
      if (pickedCamera == null) {
        return null;
      } else {
        foto = File(pickedCamera.path);
        print('object');
        print(foto);
      }
    });
  }
}
