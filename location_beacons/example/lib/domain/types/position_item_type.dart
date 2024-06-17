enum PositionItemType {
  log,
  position;

  bool get isLog => this == PositionItemType.log;
  bool get isPosition => this == PositionItemType.position;
}
