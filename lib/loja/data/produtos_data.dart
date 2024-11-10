import 'package:flutter/material.dart';

class ProdutosData {
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.all_inclusive, 'label': 'Todos'},
    {'icon': Icons.toys, 'label': 'Jogos'},
    {'icon': Icons.checkroom, 'label': 'Camisas'},
    {'icon': Icons.local_cafe, 'label': 'Canecas'},
    {'icon': Icons.book, 'label': 'Livros'},
    {'icon': Icons.extension, 'label': 'Brinquedos'},
  ];

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Quebra-cabeça Alfabeto',
      'price': 49.90,
      'image': 'assets/puzzle.png',
      'category': 0,
      'description': 'Quebra-cabeça educativo com letras do alfabeto'
    },
    {
      'name': 'Dominó de Números',
      'price': 39.90,
      'image': 'assets/domino.png',
      'category': 0,
      'description': 'Jogo de dominó com números e quantidades'
    },
    {
      'name': 'Camiseta AtiPic',
      'price': 59.90,
      'image': 'assets/shirt.png',
      'category': 1,
      'description': 'Camiseta infantil com estampa exclusiva'
    },
    {
      'name': 'Caneca Personalizada',
      'price': 34.90,
      'image': 'assets/mug.png',
      'category': 2,
      'description': 'Caneca com desenhos educativos'
    },
  ];
}