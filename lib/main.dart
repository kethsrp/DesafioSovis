import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sovisproject/src/helpers/api_cliente.dart';
import 'package:sovisproject/src/helpers/db_provider.dart';
import 'package:sovisproject/src/modelo/cliente.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('Imagens/SovisLogo.png'),
            new FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: Colors.transparent,
              textColor: Colors.black,
              padding: EdgeInsets.all(40.0),
              splashColor: Colors.grey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListClientes()),
                );
              },
              child: new Text(
                "ENTRAR SISTEMA",
                style: TextStyle(fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListClientes extends StatefulWidget {
  @override
  _ListClientesState createState() => _ListClientesState();
}

class _ListClientesState extends State<ListClientes> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listagem cliente'),
        actions: <Widget>[
          Container(
            child: IconButton(
              icon: Text("Sincronizar"),
              padding: EdgeInsets.only(right: 20.0),
              iconSize: 80.0,
              onPressed: () async {
                await _loadFromApi();
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildClienteListView(),
    );
  }

  //Obtem os dados da API para o BD
  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = ApiCliente();
    await apiProvider.getAllClientes();

    setState(() {
      isLoading = false;
    });
  }

  _buildClienteListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllClientes(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black12,
            ),
            //Exibe os dados na Tela
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                    "${snapshot.data[index].id} - ${snapshot.data[index].nome} "),
                subtitle: Text(
                    '${snapshot.data[index].cidade} - ${snapshot.data[index].estado}'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetalheCliente(snapshot.data[index])));
                },
              );
            },
          );
        }
      },
    );
  }
}

class DetalheCliente extends StatelessWidget {
  final Cliente cliente;
  DetalheCliente(this.cliente);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detalhes do cliente"),
          actions: <Widget>[
            Container(
              child: IconButton(
                icon: Text("Sair"),
                iconSize: 60.0,
                onPressed: () async => exit(0),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Código",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            )),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(" ${cliente.id}",
                              style: TextStyle(
                                color: Colors.black,
                                height: 2.0,
                              )),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Nome",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              height: 2.0,
                            )),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(" ${cliente.nome}",
                              style: TextStyle(
                                color: Colors.black,
                                height: 2.0,
                              )),
                        ),
                      ]),
                  Container(
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Cidade",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  height: 2.0,
                                )),
                            Text("Estado ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  height: 2.0,
                                )),
                          ]),
                    ]),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: 250,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(" ${cliente.cidade}",
                              style: TextStyle(
                                color: Colors.black,
                                height: 2.0,
                              )),
                        ),
                        Container(
                          height: 40,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(" ${cliente.estado}",
                              style: TextStyle(
                                color: Colors.black,
                                height: 2.0,
                              )),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Endereço",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              height: 2.0,
                            )),
                        Text("Número",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              height: 2.0,
                            )),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: 250,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(" ${cliente.endereco}",
                              style: TextStyle(
                                color: Colors.black,
                                height: 2.0,
                              )),
                        ),
                        Container(
                          height: 40,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(" ${cliente.numero}",
                              style: TextStyle(
                                color: Colors.black,
                                height: 2.0,
                              )),
                        ),
                      ]),
                ])));
  }
}