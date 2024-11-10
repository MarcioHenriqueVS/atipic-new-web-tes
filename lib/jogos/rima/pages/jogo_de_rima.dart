import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart'; // Adicione esta linha
import 'dart:math';

class JogoDeRima extends StatefulWidget {
  const JogoDeRima({super.key});

  @override
  State<JogoDeRima> createState() => _JogoDeRimaState();
}

class _JogoDeRimaState extends State<JogoDeRima>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _userWord = '';
  int _pontos = 0;
  int _rodadaAtual = 0;
  late String _palavraAlvo;
  bool _acertou = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final FlutterTts flutterTts = FlutterTts(); // Adicione esta linha

  final List<Map<String, List<String>>> _conjuntosRimas = [
    {
      'ÃO': ['cão', 'mão', 'pão', 'chão', 'avião', 'coração', 'leão'],
    },
    {
      'ATA': ['lata', 'pata', 'mata', 'rata', 'gata', 'data', 'bata'],
    },
    {
      'ELA': ['bela', 'vela', 'dela', 'pela', 'aquela', 'janela', 'amarela'],
    },
    {
      'ITO': ['bonito', 'gatito', 'grito', 'palito', 'mosquito', 'apito'],
    },
    {
      'OLA': ['bola', 'cola', 'escola', 'carambola', 'viola', 'gola'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _inicializarReconhecimentoVoz();
    _selecionarNovaPalavra();
    _configurarTTS(); // Adicione esta linha
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _inicializarReconhecimentoVoz() async {
    bool available = await _speech.initialize(
      onError: (error) => print('Erro: $error'),
      onStatus: (status) => print('Status: $status'),
    );
    if (!available) {
      // Mostrar mensagem de erro se o reconhecimento de voz não estiver disponível
    }
  }

  Future<void> _configurarTTS() async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setSpeechRate(0.5); // Velocidade mais lenta para crianças
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _falarPalavra(String palavra) async {
    await flutterTts.speak(palavra);
  }

  void _selecionarNovaPalavra() {
    final random = Random();
    final conjuntoRimas =
        _conjuntosRimas[random.nextInt(_conjuntosRimas.length)];
    final tipoRima = conjuntoRimas.keys.first;
    final palavras = conjuntoRimas[tipoRima]!;
    setState(() {
      _palavraAlvo = palavras[random.nextInt(palavras.length)];
      _rodadaAtual++;
      _acertou = false;
      _userWord = '';
    });
  }

  void _iniciarEscuta() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _userWord = result.recognizedWords.toLowerCase();
              _verificarRima();
            });
          },
          localeId: 'pt_BR',
        );
      }
    }
  }

  void _pararEscuta() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _verificarRima() {
    if (_userWord.isEmpty) return;

    // Pega o sufixo da palavra alvo (últimas letras que determinam a rima)
    String sufixoAlvo = _obterSufixoRima(_palavraAlvo);
    String sufixoUsuario = _obterSufixoRima(_userWord);

    // Verifica se os sufixos são iguais e se não é a mesma palavra
    if (sufixoAlvo == sufixoUsuario &&
        _palavraAlvo.toLowerCase() != _userWord.toLowerCase()) {
      if (!_acertou) {
        setState(() {
          _pontos += 10;
          _acertou = true;
        });
        _mostrarFeedback(true);
      }
    } else if (_palavraAlvo.toLowerCase() == _userWord.toLowerCase()) {
      // Caso o usuário repita a mesma palavra
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Diga uma palavra diferente que rime!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  String _obterSufixoRima(String palavra) {
    // Palavras com terminação "ão"
    if (palavra.toLowerCase().endsWith('ão')) {
      return 'ão';
    }
    // Para outras palavras, pega as últimas 3 letras ou a palavra inteira se for menor
    return palavra.length >= 3
        ? palavra.substring(palavra.length - 3).toLowerCase()
        : palavra.toLowerCase();
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

  Widget _buildScoreItem(String label, int value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$value',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade700,
            ),
          ),
        ),
      ],
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
          'Jogo de Rimas',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Placar
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildScoreItem('Pontos', _pontos),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      _buildScoreItem('Rodada', _rodadaAtual),
                    ],
                  ),
                ),

                // Palavra Alvo
                GestureDetector(
                  onTap: () => _falarPalavra(_palavraAlvo),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade400,
                          Colors.deepPurple.shade700,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Encontre uma palavra que rime com:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.volume_up,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _palavraAlvo,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Palavra reconhecida
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    _userWord.isEmpty ? 'Fale uma palavra...' : _userWord,
                    style: TextStyle(
                      fontSize: 24,
                      color: _userWord.isEmpty ? Colors.grey : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Botões
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isListening ? _pararEscuta : _iniciarEscuta,
                      icon: Icon(
                        _isListening ? Icons.mic_off : Icons.mic,
                        size: 28,
                        color: Colors.white,
                      ),
                      label: Text(
                        _isListening ? 'Parar' : 'Falar',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isListening
                            ? Colors.red.shade400
                            : Colors.deepPurple.shade600,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _selecionarNovaPalavra,
                      icon: const Icon(
                        Icons.refresh,
                        size: 28,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Próxima',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade600,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
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
    _animationController.dispose();
    _speech.stop();
    flutterTts.stop(); // Adicione esta linha
    super.dispose();
  }
}
