import 'package:flutter/material.dart';
import 'atividades/pages/atividades_screen.dart';
import 'home/pages/home_page.dart';
import 'jogos/alfabeto/pages/alfabeto_page.dart';
import 'jogos/associacao/pages/associacao_page.dart';
import 'jogos/caca_palavras/pages/caca_palavras.dart';
import 'jogos/rima/pages/jogo_de_rima.dart';
import 'jogos/silabas/pages/jogo_de_silabas.dart';
import 'loja/pages/loja_page.dart';
import 'profissionais/pages/profissionais_page.dart';
import 'perfil/pages/perfil_page.dart';
import 'shared/state/navigation_state.dart';
import 'shared/widgets/shared_bottom_navigation.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    //JogoDeRima(),
    //Alfabeto(),
    //AssociacaoGame(),
    //const JogoDeSilabas(),
    //CacaPalavras(),
    const AtividadesPage(),
    //const PerfilPage(),
    const LojaPage(),
    const ProfissionaisPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationState = NavigationState.of(context);
    return Scaffold(
      body: IndexedStack(
        index: navigationState?.selectedIndex ?? 0,
        children: _pages,
      ),
      bottomNavigationBar: SharedBottomNavigation(
        currentIndex: navigationState?.selectedIndex ?? 0,
        onTap: navigationState?.updateIndex ?? (_) {},
      ),
    );
  }
}
