import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class JogoDeSilabas extends StatefulWidget {
  const JogoDeSilabas({super.key});

  @override
  State<JogoDeSilabas> createState() => _JogoDeSilabasState();
}

class _JogoDeSilabasState extends State<JogoDeSilabas> {
  final FlutterTts flutterTts = FlutterTts();
  int pontos = 0;
  int rodadaAtual = 0;
  late Map<String, dynamic> palavraAtual;
  bool respondido = false;

  final List<Map<String, dynamic>> palavras = [
    {
      "palavra": "BOLA",
      "silabas": ["BO", "LA"],
      "imagem": "assets/images/silabas/bola.png"
    },
    {
      "palavra": "CASA",
      "silabas": ["CA", "SA"],
      "imagem": "assets/images/silabas/casa.png"
    },
    {
      "palavra": "GATO",
      "silabas": ["GA", "TO"],
      "imagem": "assets/images/silabas/gato.png"
    },
    {
      "palavra": "SAPATO",
      "silabas": ["SA", "PA", "TO"],
      "imagem": "assets/images/silabas/sapato.png"
    },
    {
      "palavra": "BANANA",
      "silabas": ["BA", "NA", "NA"],
      "imagem": "assets/images/silabas/banana.png"
    },
  ];

  List<String> silabasEmbaralhadas = [];
  List<String> silabasSelecionadas = [];

  @override
  void initState() {
    super.initState();
    _configurarTTS();
    _iniciarNovaRodada();
  }

  Future<void> _configurarTTS() async {
    try {
      await flutterTts.setLanguage("pt-BR");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.setQueueMode(1); // Adiciona modo de fila
    } catch (e) {
      debugPrint("Erro ao configurar TTS: $e");
    }
  }

  void _iniciarNovaRodada() {
    palavraAtual = palavras[rodadaAtual % palavras.length];
    silabasSelecionadas = [];
    silabasEmbaralhadas = List.from(palavraAtual['silabas'])..shuffle();

    setState(() {
      rodadaAtual++;
      respondido = false;
    });

    _falarPalavra(palavraAtual['palavra']);
  }

  Future<void> _falarPalavra(String palavra) async {
    try {
      await flutterTts.stop();
      await flutterTts.speak(palavra);
    } catch (e) {
      debugPrint("Erro ao falar palavra: $e");
    }
  }

  void _selecionarSilaba(String silaba) {
    if (respondido) return;

    setState(() {
      if (!silabasSelecionadas.contains(silaba)) {
        silabasSelecionadas.add(silaba);
        silabasEmbaralhadas.remove(silaba);
      }

      if (silabasSelecionadas.length == palavraAtual['silabas'].length) {
        _verificarResposta();
      }
    });
  }

  void _removerSilaba(String silaba) {
    if (respondido) return;

    setState(() {
      silabasSelecionadas.remove(silaba);
      silabasEmbaralhadas.add(silaba);
    });
  }

  void _verificarResposta() {
    bool acertou = true;
    for (int i = 0; i < palavraAtual['silabas'].length; i++) {
      if (silabasSelecionadas[i] != palavraAtual['silabas'][i]) {
        acertou = false;
        break;
      }
    }

    setState(() {
      respondido = true;
      if (acertou) pontos += 10;
    });

    _mostrarFeedback(acertou);

    if (acertou) {
      Future.delayed(const Duration(seconds: 2), () {
        if (rodadaAtual < palavras.length) {
          _iniciarNovaRodada();
        } else {
          _mostrarFimDeJogo();
        }
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          silabasSelecionadas = [];
          silabasEmbaralhadas = List.from(palavraAtual['silabas'])..shuffle();
          respondido = false;
        });
      });
    }
  }

  void _mostrarFeedback(bool acertou) {
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
              acertou ? 'Muito bem! Você acertou!' : 'Tente novamente!',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        backgroundColor: acertou ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _mostrarFimDeJogo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Parabéns!'),
        content: Text('Você completou o jogo com $pontos pontos!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                pontos = 0;
                rodadaAtual = 0;
                _iniciarNovaRodada();
              });
            },
            child: const Text('Jogar Novamente'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Jogo de Sílabas',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade300, Colors.blue.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Placar e Imagem
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Pontos: $pontos',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Rodada: $rodadaAtual',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Palavra e Imagem
                GestureDetector(
                  onTap: () async {
                    await _falarPalavra(
                      palavraAtual['palavra'],
                    );
                  },
                  child: Container(
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
                    child: Column(
                      children: [
                        Text(
                          palavraAtual['palavra'],
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Icon(Icons.volume_up, size: 30),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Área das sílabas selecionadas
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (String silaba in silabasSelecionadas)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () => _removerSilaba(silaba),
                            child: Chip(
                              label: Text(
                                silaba,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Colors.blue.shade100,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Área das sílabas disponíveis
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: silabasEmbaralhadas.map((silaba) {
                    return GestureDetector(
                      onTap: () => _selecionarSilaba(silaba),
                      child: Chip(
                        label: Text(
                          silaba,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.orange.shade100,
                      ),
                    );
                  }).toList(),
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
