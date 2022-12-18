enum TaskFilterEnum {
  today,
  tomorrow,
  week;
}

extension TaskFilterDescription on TaskFilterEnum {
  String get description {
    switch (this) {
      case TaskFilterEnum.today:
        return 'DE HOJE';
        break;
      case TaskFilterEnum.tomorrow:
        return 'DE AMANHÃ';
        break;
      case TaskFilterEnum.week:
        return 'DA SEMANA';
        break;
    }
  }
}
