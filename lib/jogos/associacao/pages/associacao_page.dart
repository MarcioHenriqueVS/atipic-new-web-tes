import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';

class AssociacaoGame extends StatefulWidget {
  const AssociacaoGame({super.key});

  @override
  State<AssociacaoGame> createState() => _AssociacaoGameState();
}

class _AssociacaoGameState extends State<AssociacaoGame> {
  final FlutterTts flutterTts = FlutterTts();
  int pontos = 0;
  int rodadaAtual = 0;
  late Map<String, String> palavraCorreta;
  List<Map<String, String>> opcoesAtuais = [];
  bool respondido = false;

  final List<Map<String, String>> todasPalavras = [
    {"palavra": "Cachorro", "imagem": "assets/images/associacao/cachorro.png"},
    {"palavra": "Gato", "imagem": "assets/images/associacao/gato.png"},
    {"palavra": "Elefante", "imagem": "assets/images/associacao/elefante.png"},
    {"palavra": "Leão", "imagem": "assets/images/associacao/leao.png"},
    {"palavra": "Girafa", "imagem": "assets/images/associacao/girafa.png"},
    {"palavra": "Zebra", "imagem": "assets/images/associacao/zebra.png"},
    {"palavra": "Macaco", "imagem": "assets/images/associacao/macaco.png"},
    {"palavra": "Panda", "imagem": "assets/images/associacao/panda.png"},
    // Adicione mais palavras conforme necessário
  ];

  @override
  void initState() {
    super.initState();
    _configurarTTS();
    _iniciarNovaRodada();
  }

  Future<void> _configurarTTS() async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  void _iniciarNovaRodada() {
    List<Map<String, String>> palavrasDisponiveis = List.from(todasPalavras);
    palavrasDisponiveis.shuffle();

    // Seleciona a palavra correta
    palavraCorreta = palavrasDisponiveis.first;

    // Seleciona 3 palavras incorretas aleatórias
    opcoesAtuais = [palavraCorreta];
    palavrasDisponiveis.removeAt(0);
    opcoesAtuais.addAll(palavrasDisponiveis.take(3));
    opcoesAtuais.shuffle();

    setState(() {
      rodadaAtual++;
      respondido = false;
    });

    // Fala a palavra
    _falarPalavra(palavraCorreta['palavra']!);
  }

  Future<void> _falarPalavra(String palavra) async {
    await flutterTts.speak("Encontre a imagem de $palavra");
  }

  void _verificarResposta(Map<String, String> escolha) {
    if (respondido) return;

    bool acertou = escolha == palavraCorreta;

    if (acertou) {
      setState(() {
        respondido = true;
        pontos += 10;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              acertou ? Icons.star : Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              acertou ? 'Parabéns! Você acertou!' : 'Ops! Tente novamente!',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        backgroundColor: acertou ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );

    if (acertou) {
      Future.delayed(const Duration(seconds: 2), _iniciarNovaRodada);
    } else {
      // Fala a palavra novamente para ajudar a criança
      Future.delayed(
        const Duration(seconds: 1),
        () => _falarPalavra(palavraCorreta['palavra']!),
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
          'Associação de Palavras',
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
            colors: [Colors.blue.shade300, Colors.purple.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Placar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Pontos: $pontos',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rodada: $rodadaAtual',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Palavra atual
                GestureDetector(
                  onTap: () => _falarPalavra(palavraCorreta['palavra']!),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          palavraCorreta['palavra']!,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.volume_up, size: 32),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Grid de opções
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: opcoesAtuais.length,
                    itemBuilder: (context, index) {
                      final opcao = opcoesAtuais[index];
                      return GestureDetector(
                        onTap: () => _verificarResposta(opcao),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              opcao['imagem']!,
                              fit: BoxFit.cover,
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
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
