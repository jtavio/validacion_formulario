import 'dart:convert';
import 'dart:io';

import 'package:formulario_validacion/src/preferencias_usuario/Preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:formulario_validacion/src/models/producto_model.dart';

import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class ProductosProvider {
  final String _url = 'https://variosflutter-21-default-rtdb.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = Uri.parse('$_url/productos.json?auth=${_prefs.token}');
    final resp = await http.post(url, body: productoModelToJson(producto));
    final decodeData = json.decode(resp.body);
    print(decodeData);
    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url =
        Uri.parse('$_url/productos/${producto.id}.json?auth=${_prefs.token}');
    final resp = await http.put(url, body: productoModelToJson(producto));
    final decodeData = json.decode(resp.body);
    print(decodeData);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = Uri.parse('$_url/productos.json?auth=${_prefs.token}');
    final resp = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = [];

    // ignore: unnecessary_null_comparison
    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      print(productos);
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;
      productos.add(prodTemp);
    });
    print(productos[0].id);
    return productos;
  }

  Future<int> borrarProducto(String? id) async {
    final url = Uri.parse('$_url/productos/$id.json?auth=${_prefs.token}');
    final resp = await http.delete(url);

    print(resp.body);

    return 1;
  }

  Future<String?> subirImagen(File imagen) async {
    //subir cualquier tipo de archivo
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dop3uxlhz/image/upload?upload_preset=qu12k0ro');
    final mimeType = mime(imagen.path)!.split('/');
    print(mimeType);

    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    //multiple archivos repite el codigo de abajo varias veces
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    print('response data');
    print(respData);
    return respData['secure_url'];
  }
}
