import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/state/navigation_state.dart';
import '../widgets/behavior_options.dart';
import '../models/behavior_types.dart';
import '../../perfil/pages/perfil_page.dart';
import 'dart:convert';
import 'package:atipic/home/pages/strings/planejamento.dart';

class Message {
  final String text;
  final bool isUserMessage;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isUserMessage,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _behaviorSelection = BehaviorSelection();
  String? _aiResponse;
  int _currentStep = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasPlanActive = true; // Adicione esta linha
  int _selectedIndex = 0; // Adicione esta linha
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _addInitialBotMessage();
  }

  void _addInitialBotMessage() {
    _messages.add(
      Message(
        text:
            'Olá! Sou a assistente do AtiPic. Me conte um pouco sobre seu filho(a) para que eu possa ajudar a criar um plano personalizado. Qual a idade dele(a)?',
        isUserMessage: false,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleNavigation(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 2: // índice do item Perfil
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PerfilPage()),
        ).then((_) {
          setState(() {
            _selectedIndex = 0; // Volta para o índice inicial ao retornar
          });
        });
        break;
      // Adicione outros casos conforme necessário
    }
  }

  Widget _buildPlanejamentoAtivo() {
    final planejamentoJson = jsonDecode(PlanejamentoString.planejamento);
    final semanas = planejamentoJson['semanas'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              // Título com container flexível
              const Expanded(
                child: Text(
                  'Seu Plano de Atividades',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // Botão compacto e moderno
              Container(
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    // Aqui está a mudança:
                    NavigationState.of(context)?.updateIndex(1);
                  },
                  icon: const Icon(
                    Icons.visibility_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    'Ver Atividades',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: semanas.length,
          itemBuilder: (context, index) {
            final semana = semanas[index] as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    semana['titulo'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6200EA),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAtividadesList(semana['atividades_crianca']),
                          const Divider(height: 24),
                          _buildDicasList(semana['dicas_pais']),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAtividadesList(List<dynamic> atividades) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Atividades para a Criança:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7C4DFF),
          ),
        ),
        const SizedBox(height: 8),
        ...atividades.map((atividade) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    atividade['titulo'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(atividade['descricao'] as String),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildDicasList(List<dynamic> dicas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dicas para os Pais:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7C4DFF),
          ),
        ),
        const SizedBox(height: 8),
        ...dicas.map((dica) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dica['titulo'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(dica['descricao'] as String),
                ],
              ),
            )),
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
        systemOverlayStyle: SystemUiOverlayStyle.light,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7C4DFF), Color(0xFF6200EA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.family_restroom,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'AtiPic - Apoio Familiar',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF7C4DFF),
              const Color(0xFF6200EA).withOpacity(0.8),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Header modernizado
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 30),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.waving_hand,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              const Text(
                                'Bem-vindo ao AtiPic',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: !_hasPlanActive ? 0 : 12),
                              !_hasPlanActive
                                  ? Text(
                                      'Vamos criar um plano personalizado para seu filho',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white.withOpacity(0.9),
                                        height: 1.5,
                                      ),
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Adicione após o Header e antes do Progress Indicator
                  _hasPlanActive
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 30),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7C4DFF), Color(0xFF6200EA)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7C4DFF).withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // TODO: Implementar visualização detalhada do plano
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text(
                                        'Plano de Desenvolvimento Atual'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildProgressSection(
                                              'Aprendizagem', 0.7),
                                          const SizedBox(height: 16),
                                          _buildProgressSection('Fala', 0.5),
                                          const SizedBox(height: 16),
                                          _buildProgressSection(
                                              'Socialização', 0.8),
                                          const SizedBox(height: 16),
                                          _buildProgressSection(
                                              'Comportamento', 0.6),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Fechar'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Plano Atual',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Text(
                                            'Em andamento',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    const LinearProgressIndicator(
                                      value: 0.65,
                                      backgroundColor: Colors.white24,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Progresso geral: 65%',
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),

                  // Substitua o Card principal pelo seguinte código condicional
                  if (!_hasPlanActive) ...[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: _buildChatWidget(),
                    ),
                  ] else ...[
                    _buildPlanejamentoAtivo(),
                  ],
                  // Botão de gerar plano modernizado
                  if (_behaviorSelection.isComplete)
                    AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: 1.0,
                      child: Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: ElevatedButton(
                          onPressed: _generatePlan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6200EA),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 8,
                            shadowColor:
                                const Color(0xFF6200EA).withOpacity(0.4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome, color: Colors.white),
                              SizedBox(width: 12),
                              Text(
                                'Gerar Plano Personalizado',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Resposta AI modernizada
                  if (_aiResponse != null) ...[
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Icon(Icons.lightbulb, color: Color(0xFF7C4DFF)),
                        SizedBox(width: 8),
                        Text(
                          'Plano Sugerido:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF303F9F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE8EAF6), Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        _aiResponse!,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getAgitacaoText(Agitacao agitacao) {
    switch (agitacao) {
      case Agitacao.calmo:
        return 'Calmo';
      case Agitacao.normal:
        return 'Normal';
      case Agitacao.agitado:
        return 'Agitado';
      case Agitacao.muitoAgitado:
        return 'Muito Agitado';
    }
  }

  void _generatePlan() {
    setState(() {
      _aiResponse = '''
Plano personalizado com base nas seleções:
- Agitação: ${_getAgitacaoText(_behaviorSelection.agitacao!)}
- Aprendizagem: ${BehaviorOptions.getAprendizagemText(_behaviorSelection.aprendizagem!)}
- Fala: ${BehaviorOptions.getFalaText(_behaviorSelection.fala!)}
- Socialização: ${BehaviorOptions.getSocializacaoText(_behaviorSelection.socializacao!)}
''';
    });
  }

  Widget _buildProgressSection(String title, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7C4DFF)),
        ),
        const SizedBox(height: 4),
        Text(
          '${(progress * 100).toInt()}%',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildChatWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                            size: 48,
                            color: Color(0xFF7C4DFF),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Olá! Me conte um pouco sobre o seu filho.\nEle possui alguma dificuldade na fala?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isTyping) {
                        return _buildTypingIndicator();
                      }
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Text('Digitando'),
                SizedBox(width: 8),
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Color(0xFF7C4DFF)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment:
          message.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUserMessage
              ? const Color(0xFF7C4DFF)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUserMessage ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Digite sua mensagem...',
                border: InputBorder.none,
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: const Color(0xFF7C4DFF),
            onPressed: () => _sendMessage(_messageController.text),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isUserMessage: true));
      _messageController.clear();
      _isTyping = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      _processAIResponse(text);
    });

    _scrollToBottom();
  }

  void _processAIResponse(String userMessage) {
    String aiResponse = _generateAIResponse(userMessage);

    setState(() {
      _messages.add(Message(text: aiResponse, isUserMessage: false));
      _isTyping = false;
    });

    _scrollToBottom();
  }

  String _generateAIResponse(String userMessage) {
    // Aqui você implementará a lógica real da IA
    // Por enquanto, retorna respostas simuladas
    if (userMessage.toLowerCase().contains('idade')) {
      return 'Qual a idade do seu filho? Isso me ajudará a personalizar melhor as recomendações.';
    } else if (userMessage.toLowerCase().contains('comportamento')) {
      return 'Como você descreveria o comportamento dele em casa e na escola?';
    }
    return 'Entendi. Me conte mais sobre as atividades diárias dele.';
  }

  void _scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }
}
