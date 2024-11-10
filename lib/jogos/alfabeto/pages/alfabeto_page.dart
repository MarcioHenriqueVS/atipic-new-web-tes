import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Alfabeto extends StatefulWidget {
  const Alfabeto({super.key});

  @override
  State<Alfabeto> createState() => _AlfabetoState();
}

class _AlfabetoState extends State<Alfabeto> {
  final FlutterTts flutterTts = FlutterTts();
  final List<Map<String, String>> alfabeto = [
    {
      "letra": "A",
      "palavra": "Abelha",
      "imagem": "assets/images/alfabeto/abelha.png"
    },
    {
      "letra": "B",
      "palavra": "Bola",
      "imagem": "assets/images/alfabeto/bola.png"
    },
    {
      "letra": "C",
      "palavra": "Cachorro",
      "imagem": "assets/images/alfabeto/cachorro.png"
    },
    {
      "letra": "D",
      "palavra": "Dado",
      "imagem": "assets/images/alfabeto/dado.png"
    },
    {
      "letra": "E",
      "palavra": "Elefante",
      "imagem": "assets/images/alfabeto/elefante.png"
    },
    {
      "letra": "F",
      "palavra": "Flor",
      "imagem": "assets/images/alfabeto/flor.png"
    },
    {
      "letra": "G",
      "palavra": "Gato",
      "imagem": "assets/images/alfabeto/gato.png"
    },
    {
      "letra": "H",
      "palavra": "Hipopótamo",
      "imagem": "assets/images/alfabeto/hipopotamo.png"
    },
    {
      "letra": "I",
      "palavra": "Igreja",
      "imagem": "assets/images/alfabeto/igreja.png"
    },
    {
      "letra": "J",
      "palavra": "Jacaré",
      "imagem": "assets/images/alfabeto/jacare.png"
    },
    {
      "letra": "K",
      "palavra": "Kiwi",
      "imagem": "assets/images/alfabeto/kiwi.png"
    },
    {
      "letra": "L",
      "palavra": "Leão",
      "imagem": "assets/images/alfabeto/leao.png"
    },
    {
      "letra": "M",
      "palavra": "Macaco",
      "imagem": "assets/images/alfabeto/macaco.png"
    },
    {
      "letra": "N",
      "palavra": "Navio",
      "imagem": "assets/images/alfabeto/navio.png"
    },
    {
      "letra": "O",
      "palavra": "Ovo",
      "imagem": "assets/images/alfabeto/ovo.png"
    },
    {
      "letra": "P",
      "palavra": "Pato",
      "imagem": "assets/images/alfabeto/pato.png"
    },
    {
      "letra": "Q",
      "palavra": "Queijo",
      "imagem": "assets/images/alfabeto/queijo.png"
    },
    {
      "letra": "R",
      "palavra": "Rato",
      "imagem": "assets/images/alfabeto/rato.png"
    },
    {
      "letra": "S",
      "palavra": "Sapo",
      "imagem": "assets/images/alfabeto/sapo.png"
    },
    {
      "letra": "T",
      "palavra": "Tartaruga",
      "imagem": "assets/images/alfabeto/tartaruga.png"
    },
    {
      "letra": "U",
      "palavra": "Urso",
      "imagem": "assets/images/alfabeto/urso.png"
    },
    {
      "letra": "V",
      "palavra": "Vaca",
      "imagem": "assets/images/alfabeto/vaca.png"
    },
    {
      "letra": "W",
      "palavra": "Web",
      "imagem": "assets/images/alfabeto/web.png"
    },
    {
      "letra": "X",
      "palavra": "Xícara",
      "imagem": "assets/images/alfabeto/xicara.png"
    },
    {
      "letra": "Y",
      "palavra": "Yoga",
      "imagem": "assets/images/alfabeto/yoga.png"
    },
    {
      "letra": "Z",
      "palavra": "Zebra",
      "imagem": "assets/images/alfabeto/zebra.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    _configurarTTS();
  }

  Future<void> _configurarTTS() async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _falarLetraEPalavra(String letra, String palavra) async {
    await flutterTts.speak("Letra $letra de $palavra");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Alfabeto Mágico',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade400,
              Colors.purple.shade300,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: alfabeto.length,
            itemBuilder: (context, index) {
              final item = alfabeto[index];
              return GestureDetector(
                onTap: () =>
                    _falarLetraEPalavra(item["letra"]!, item["palavra"]!),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Stack(
                      children: [
                        // Fundo decorativo
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        // Conteúdo
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Hero(
                                tag: "letra_${item["letra"]}",
                                child: Text(
                                  item["letra"]!,
                                  style: TextStyle(
                                    fontSize: 56,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple.shade700,
                                    shadows: [
                                      Shadow(
                                        color: Colors.purple.withOpacity(0.2),
                                        offset: const Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.purple.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  item["imagem"]!,
                                  height: 70,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item["palavra"]!,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.purple.shade900,
                                ),
                              ),
                              Icon(
                                Icons.volume_up_rounded,
                                color: Colors.purple.shade400,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
