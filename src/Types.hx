typedef Param = {
  public var backgroundPicture: String;
  public var debugCollider: Bool;
  public var hpColor: String;
  public var damageFlashTime: Float;
}

typedef Position = {
  public var x: Float;
  public var y: Float;
}

typedef Character = {
  public var hp: Int;
  public var maxHp: Int;
  public var def: Int;
  public var atk: Int;
  public var name: String;
}

typedef Enemy = {
  > Character,
  public var isEnemy: Bool;
}

typedef Player = {
  > Character,
  public var isPlayer: Bool;
}
