enum Agitacao { calmo, normal, agitado, muitoAgitado }

enum Aprendizagem {
  semDificuldade,
  dificuldadeLeve,
  dificuldadeModerada,
  dificuldadeSevera
}

enum Fala {
  semDificuldade,
  dificuldadeLeve,
  dificuldadeModerada,
  dificuldadeSevera
}

enum Socializacao { muitoSociavel, sociavel, timido, dificuldadeSocializacao }

class BehaviorSelection {
  Agitacao? agitacao;
  Aprendizagem? aprendizagem;
  Fala? fala;
  Socializacao? socializacao;

  bool get isComplete =>
      agitacao != null &&
      aprendizagem != null &&
      fala != null &&
      socializacao != null;
}
