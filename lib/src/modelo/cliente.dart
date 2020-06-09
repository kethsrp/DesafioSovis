import 'dart:convert';

List<Cliente> clienteFromJson(String str) =>
  List<Cliente>.from(json.decode(str).map((x) => Cliente.fromJson(x)));

String clienteToJson(List<Cliente> data) => 
  json.encode(List<dynamic>.from(data.map((x) => x.toJson)));


class Cliente {
  int id;
  String nome;
  String cidade;
  String estado;
  String endereco;
  int numero;

  Cliente({
      this.id, 
      this.nome, 
      this.cidade, 
      this.estado, 
      this.endereco, 
      this.numero
  });

  //Transforma o MAP em um objeto
  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
    id: json["id"],
    nome: json["nome"],
    cidade: json["cidade"],
    estado: json["estado"],
    endereco: json["endereco"],
    numero: json["numero"],
  );

  //Transforma objeto em Map
  Map<String, dynamic> toJson() => {
    "id": id,
    "nome": nome,
    "cidade": cidade,
    "estado": estado,
    "endereco": endereco,
    "numero": numero,
  };
}
