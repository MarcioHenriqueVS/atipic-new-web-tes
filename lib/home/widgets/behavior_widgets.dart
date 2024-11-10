
import 'package:flutter/material.dart';
import '../models/behavior_types.dart';
import './behavior_options.dart';

class BehaviorWidgets {
  static Step buildStep(String title, Widget content, int step, int currentStep) {
    return Step(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: currentStep >= step ? FontWeight.bold : FontWeight.normal,
          color: currentStep >= step ? const Color(0xFF6200EA) : Colors.grey,
        ),
      ),
      content: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: currentStep == step ? 1.0 : 0.5,
        child: content,
      ),
      isActive: currentStep >= step,
      state: currentStep > step ? StepState.complete : StepState.indexed,
    );
  }

  static Widget buildAgitacaoOptions(
    BehaviorSelection behaviorSelection,
    Function(void Function()) setState,
  ) {
    return Column(
      children: Agitacao.values.map((agitacao) {
        return _buildOptionButton(
          text: getAgitacaoText(agitacao),
          isSelected: behaviorSelection.agitacao == agitacao,
          onPressed: () {
            setState(() {
              behaviorSelection.agitacao = agitacao;
            });
          },
        );
      }).toList(),
    );
  }

  static String getAgitacaoText(Agitacao agitacao) {
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

  static Widget buildAprendizagemOptions(
    BehaviorSelection behaviorSelection,
    Function(void Function()) setState,
  ) {
    return BehaviorOptions.buildAprendizagemOptions(
      behaviorSelection.aprendizagem,
      (value) {
        setState(() {
          behaviorSelection.aprendizagem = value;
        });
      },
    );
  }

  static Widget buildFalaOptions(
    BehaviorSelection behaviorSelection,
    Function(void Function()) setState,
  ) {
    return BehaviorOptions.buildFalaOptions(
      behaviorSelection.fala,
      (value) {
        setState(() {
          behaviorSelection.fala = value;
        });
      },
    );
  }

  static Widget buildSocializacaoOptions(
    BehaviorSelection behaviorSelection,
    Function(void Function()) setState,
  ) {
    return BehaviorOptions.buildSocializacaoOptions(
      behaviorSelection.socializacao,
      (value) {
        setState(() {
          behaviorSelection.socializacao = value;
        });
      },
    );
  }

  static Widget _buildOptionButton({
    required String text,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF7C4DFF) : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? const Color(0xFF7C4DFF) : Colors.grey[300]!,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}