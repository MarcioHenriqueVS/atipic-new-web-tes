import 'package:flutter/material.dart';
import 'dart:math';

class CacaPalavras extends StatefulWidget {
  const CacaPalavras({super.key});

  @override
  State<CacaPalavras> createState() => _CacaPalavrasState();
}

class _CacaPalavrasState extends State<CacaPalavras> {
  final List<String> palavras = ['GATO', 'CASA', 'BOLA', 'PATO', 'SAPO'];
  List<String> palavrasEncontradas = [];
  List<List<String>> grade = [];
  List<List<bool>> selecionadas = [];
  List<Offset> selecaoAtual = [];
  List<List<Offset>> palavrasHighlight = [];

  @override
  void initState() {
    super.initState();
    _inicializarJogo();
  }

  void _inicializarJogo() {
    grade = List.generate(8, (_) => List.filled(8, ''));
    selecionadas = List.generate(8, (_) => List.filled(8, false));
    _preencherGrade();
  }

  void _preencherGrade() {
    // Primeiro, coloca as palavras na grade
    for (String palavra in palavras) {
      bool colocada = false;
      while (!colocada) {
        int direcao = Random().nextInt(2); // 0 = horizontal, 1 = vertical
        int linha = Random().nextInt(8);
        int coluna = Random().nextInt(8);

        if (direcao == 0 && coluna + palavra.length <= 8) {
          // Tenta colocar horizontalmente
          bool espacoLivre = true;
          for (int i = 0; i < palavra.length; i++) {
            if (grade[linha][coluna + i].isNotEmpty) {
              espacoLivre = false;
              break;
            }
          }
          if (espacoLivre) {
            for (int i = 0; i < palavra.length; i++) {
              grade[linha][coluna + i] = palavra[i];
            }
            colocada = true;
          }
        } else if (direcao == 1 && linha + palavra.length <= 8) {
          // Tenta colocar verticalmente
          bool espacoLivre = true;
          for (int i = 0; i < palavra.length; i++) {
            if (grade[linha + i][coluna].isNotEmpty) {
              espacoLivre = false;
              break;
            }
          }
          if (espacoLivre) {
            for (int i = 0; i < palavra.length; i++) {
              grade[linha + i][coluna] = palavra[i];
            }
            colocada = true;
          }
        }
      }
    }

    // Preenche os espaços vazios com letras aleatórias
    const letras = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (grade[i][j].isEmpty) {
          grade[i][j] = letras[Random().nextInt(letras.length)];
        }
      }
    }
  }

  void _onLetraPress(int linha, int coluna) {
    setState(() {
      if (selecaoAtual.isEmpty) {
        selecionadas[linha][coluna] = true;
        selecaoAtual.add(Offset(linha.toDouble(), coluna.toDouble()));
      } else {
        // Verifica se a nova letra está adjacente à última selecionada
        final ultimaSelecao = selecaoAtual.last;
        if (_isAdjacente(
            ultimaSelecao, Offset(linha.toDouble(), coluna.toDouble()))) {
          selecionadas[linha][coluna] = true;
          selecaoAtual.add(Offset(linha.toDouble(), coluna.toDouble()));
          _verificarPalavra();
        }
      }
    });
  }

  bool _isAdjacente(Offset a, Offset b) {
    return (a.dx - b.dx).abs() <= 1 && (a.dy - b.dy).abs() <= 1;
  }

  void _verificarPalavra() {
    String palavraSelecionada = '';
    for (var posicao in selecaoAtual) {
      palavraSelecionada += grade[posicao.dx.toInt()][posicao.dy.toInt()];
    }

    if (palavras.contains(palavraSelecionada) &&
        !palavrasEncontradas.contains(palavraSelecionada)) {
      setState(() {
        palavrasEncontradas.add(palavraSelecionada);
        palavrasHighlight.add(List.from(selecaoAtual));
      });
      _mostrarFeedback(true);
    }

    // Limpa a seleção após um curto delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        if (!palavrasEncontradas.contains(palavraSelecionada)) {
          for (var posicao in selecaoAtual) {
            selecionadas[posicao.dx.toInt()][posicao.dy.toInt()] = false;
          }
        }
        selecaoAtual.clear();
      });
    });
  }

  void _mostrarFeedback(bool encontrou) {
    if (encontrou) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.yellow),
              const SizedBox(width: 8),
              Text('Você encontrou ${palavrasEncontradas.last}!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Caça Palavras',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade300, Colors.blue.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Palavras para encontrar
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: palavras.map((palavra) {
                    bool encontrada = palavrasEncontradas.contains(palavra);
                    return Chip(
                      label: Text(
                        palavra,
                        style: TextStyle(
                          decoration:
                              encontrada ? TextDecoration.lineThrough : null,
                          color: encontrada ? Colors.grey : Colors.black,
                        ),
                      ),
                      backgroundColor: encontrada
                          ? Colors.grey.shade200
                          : Colors.orange.shade100,
                    );
                  }).toList(),
                ),
              ),

              // Grade do caça-palavras
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    childAspectRatio: 1,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: 64,
                  itemBuilder: (context, index) {
                    int linha = index ~/ 8;
                    int coluna = index % 8;
                    bool selecionada = selecionadas[linha][coluna];

                    return GestureDetector(
                      onTapDown: (_) => _onLetraPress(linha, coluna),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selecionada ? Colors.yellow : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            grade[linha][coluna],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: selecionada
                                  ? Colors.orange.shade900
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
