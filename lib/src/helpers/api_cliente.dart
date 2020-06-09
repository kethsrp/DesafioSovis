import 'package:sovisproject/src/modelo/cliente.dart';
import 'package:sovisproject/src/helpers/db_provider.dart';
import 'package:dio/dio.dart';

class ApiCliente {
  //método para executar a chamada na API
  Future<List<Cliente>> getAllClientes() async {
    var url = "https://run.mocky.io/v3/d62a2b4a-1e6f-4279-800b-ee89597fe84a";
    Response response = await Dio().get(url);

    return (response.data as List).map((cliente) {
      print('Inserting $cliente');
      //Insere o conteúdo diretamente no BD
      DBProvider.db.createCliente(Cliente.fromJson(cliente));
    }).toList();
  }
}
