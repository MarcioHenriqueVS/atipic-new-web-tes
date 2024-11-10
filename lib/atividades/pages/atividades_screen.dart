import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:atipic/home/pages/strings/planejamento.dart';
import 'package:flutter/services.dart';

import '../../jogos/alfabeto/pages/alfabeto_page.dart';
import '../../jogos/associacao/pages/associacao_page.dart';
import '../../jogos/associacao/pages/jogo_de_associacao.dart';
import '../../jogos/caca_palavras/pages/caca_palavras.dart';
import '../../jogos/rima/pages/jogo_de_rima.dart';
import '../../jogos/silabas/pages/jogo_de_silabas.dart';

class AtividadesPage extends StatefulWidget {
  const AtividadesPage({super.key});

  @override
  State<AtividadesPage> createState() => _AtividadesPageState();
}

class _AtividadesPageState extends State<AtividadesPage> {
  int _selectedWeek = 0;

  @override
  Widget build(BuildContext context) {
    final planejamentoJson = jsonDecode(PlanejamentoString.planejamento);
    final semanas = planejamentoJson['semanas'] as List;

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
        title: const Text(
          'Atividades da Semana',
          style: TextStyle(color: Colors.white),
        ),
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
          child: Column(
            children: [
              // Seletor de semanas
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: semanas.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text('Semana ${index + 1}'),
                          selected: _selectedWeek == index,
                          onSelected: (selected) {
                            setState(() {
                              _selectedWeek = index;
                            });
                          },
                          selectedColor: const Color(0xFF7C4DFF),
                          labelStyle: TextStyle(
                            color: _selectedWeek == index
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Lista de atividades
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount:
                      (semanas[_selectedWeek]['atividades_crianca'] as List)
                          .length,
                  itemBuilder: (context, index) {
                    final atividade = (semanas[_selectedWeek]
                        ['atividades_crianca'] as List)[index];

                    Widget jogoWidget;

                    //verificar se o jogo é nulo
                    if (atividade['jogo'] == null) {
                      return Container();
                    } else {
                      //selecinar o widget do jogo correspondente
                      switch (atividade['jogo']) {
                        case 'associacao':
                          jogoWidget = const AssociacaoGame();
                          break;
                        case 'alfabeto':
                          jogoWidget = const Alfabeto();
                          break;
                        case 'caca_palavras':
                          jogoWidget = const CacaPalavras();
                          break;
                        case 'jogo_de_rima':
                          jogoWidget = const JogoDeRima();
                          break;
                        case 'jogo_de_silabas':
                          jogoWidget = const JogoDeSilabas();
                          break;
                        default:
                          jogoWidget = Container();
                      }
                    }

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              atividade['titulo'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                atividade['descricao'] as String,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // TextButton.icon(
                                //   icon: const Icon(Icons.info_outline),
                                //   label: const Text('Detalhes'),
                                //   onPressed: () {
                                //     showDialog(
                                //       context: context,
                                //       builder: (context) => AlertDialog(
                                //         title:
                                //             Text(atividade['titulo'] as String),
                                //         content: Text(
                                //             atividade['descricao'] as String),
                                //         actions: [
                                //           TextButton(
                                //             child: const Text('Fechar'),
                                //             onPressed: () =>
                                //                 Navigator.pop(context),
                                //           ),
                                //         ],
                                //       ),
                                //     );
                                //   },
                                // ),
                                TextButton.icon(
                                  icon: const Icon(Icons.edit_note),
                                  label: const Text('Observações'),
                                  onPressed: () {
                                    final observacoesController =
                                        TextEditingController();
                                    final tempoAtividadeController =
                                        TextEditingController();
                                    int? nivelDificuldade = 3;

                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Row(
                                          children: [
                                            const Icon(Icons.assessment,
                                                color: Color(0xFF7C4DFF)),
                                            const SizedBox(width: 8),
                                            const Text(
                                                'Avaliação da Atividade'),
                                          ],
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Nível de Dificuldade:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              StatefulBuilder(
                                                builder: (context, setState) =>
                                                    Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: List.generate(
                                                    5,
                                                    (index) => IconButton(
                                                      icon: Icon(
                                                        index <
                                                                (nivelDificuldade ??
                                                                    0)
                                                            ? Icons.star
                                                            : Icons.star_border,
                                                        color: const Color(
                                                            0xFF7C4DFF),
                                                      ),
                                                      onPressed: () =>
                                                          setState(() {
                                                        nivelDificuldade =
                                                            index + 1;
                                                      }),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              TextField(
                                                controller:
                                                    tempoAtividadeController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText:
                                                      'Tempo da Atividade (minutos)',
                                                  border: OutlineInputBorder(),
                                                  prefixIcon: Icon(Icons.timer),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                              const SizedBox(height: 16),
                                              TextField(
                                                controller:
                                                    observacoesController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Observações',
                                                  border: OutlineInputBorder(),
                                                  prefixIcon:
                                                      Icon(Icons.description),
                                                  alignLabelWithHint: true,
                                                ),
                                                maxLines: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('Cancelar'),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                          ElevatedButton.icon(
                                            icon: const Icon(Icons.save),
                                            label: const Text('Salvar'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF7C4DFF),
                                              foregroundColor: Colors.white,
                                            ),
                                            onPressed: () {
                                              // Aqui você pode implementar a lógica para salvar os dados
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Avaliação salva com sucesso!'),
                                                  backgroundColor:
                                                      Color(0xFF7C4DFF),
                                                ),
                                              );
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('Iniciar'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF7C4DFF),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => jogoWidget,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
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
