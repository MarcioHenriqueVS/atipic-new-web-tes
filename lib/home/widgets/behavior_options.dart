import 'package:flutter/material.dart';
import '../models/behavior_types.dart';

class BehaviorOptions {
  static Widget buildAprendizagemOptions(
    Aprendizagem? selectedValue,
    Function(Aprendizagem) onSelect,
  ) {
    return Column(
      children: Aprendizagem.values.map((aprendizagem) {
        return _buildOptionButton(
          text: getAprendizagemText(aprendizagem),
          isSelected: selectedValue == aprendizagem,
          onPressed: () => onSelect(aprendizagem),
        );
      }).toList(),
    );
  }

  static Widget buildFalaOptions(
    Fala? selectedValue,
    Function(Fala) onSelect,
  ) {
    return Column(
      children: Fala.values.map((fala) {
        return _buildOptionButton(
          text: getFalaText(fala),
          isSelected: selectedValue == fala,
          onPressed: () => onSelect(fala),
        );
      }).toList(),
    );
  }

  static Widget buildSocializacaoOptions(
    Socializacao? selectedValue,
    Function(Socializacao) onSelect,
  ) {
    return Column(
      children: Socializacao.values.map((socializacao) {
        return _buildOptionButton(
          text: getSocializacaoText(socializacao),
          isSelected: selectedValue == socializacao,
          onPressed: () => onSelect(socializacao),
        );
      }).toList(),
    );
  }

  static Widget _buildOptionButton({
    required String text,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        elevation: isSelected ? 4 : 1,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFF7C4DFF), Color(0xFF6200EA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String getAprendizagemText(Aprendizagem aprendizagem) {
    switch (aprendizagem) {
      case Aprendizagem.semDificuldade:
        return 'Sem dificuldade de aprendizagem';
      case Aprendizagem.dificuldadeLeve:
        return 'Dificuldade leve';
      case Aprendizagem.dificuldadeModerada:
        return 'Dificuldade moderada';
      case Aprendizagem.dificuldadeSevera:
        return 'Dificuldade severa';
    }
  }

  static String getFalaText(Fala fala) {
    switch (fala) {
      case Fala.semDificuldade:
        return 'Fala bem desenvolvida';
      case Fala.dificuldadeLeve:
        return 'Pequena dificuldade na fala';
      case Fala.dificuldadeModerada:
        return 'Dificuldade moderada na fala';
      case Fala.dificuldadeSevera:
        return 'Dificuldade severa na fala';
    }
  }

  static String getSocializacaoText(Socializacao socializacao) {
    switch (socializacao) {
      case Socializacao.muitoSociavel:
        return 'Muito sociável';
      case Socializacao.sociavel:
        return 'Sociável';
      case Socializacao.timido:
        return 'Tímido';
      case Socializacao.dificuldadeSocializacao:
        return 'Dificuldade de socialização';
    }
  }
}
