import 'dart:io';
import 'package:sovisproject/src/modelo/cliente.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  //Criação de objeto Database --- instancia
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    //retorna o db caso exista
    if (_database != null) return _database;

    //se não existir ele cria um DB
    _database = await initDB();

    return _database;
  }

  //Criação do DB e tabela cliente
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'sovis_clientes.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Cliente('
          'id INTEGER PRIMARY KEY,'
          'nome VARCHAR(100),'
          'cidade VARCHAR(100),'
          'estado VARCHAR(2),'
          'endereco VARCHAR(100),'
          'numero INTEGER');
    });
  }

  //Adiciona o cliente no DB
  createCliente(Cliente newCliente) async {
    await deleteAllClientes();
    final db = await database;
    final res = await db.insert('Cliente', newCliente.toJson());

    return res;
  }

  //Deleta todos os clientes
  Future<int> deleteAllClientes() async {
    final db = await database;
    final res = await db.rawDelete("SELECT * FROM CLIENTE");

    return res;
  }

  Future<List<Cliente>> getAllClientes() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM CLIENTE");

    List<Cliente> list =
        res.isNotEmpty ? res.map((c) => Cliente.fromJson(c)).toList() : [];

    return list;
  }
}
