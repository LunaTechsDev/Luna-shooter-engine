typedef Param = {
  public var backgroundPicture: String;
  public var playerSpeed: Int;
  public var playerBulletImage: String;
  public var playerBulletSpeed: Int;
  public var enemySpeed: Int;
  public var enemyBulletImage: String;
  public var enemyBulletSpeed: Int;
  public var godMode: Bool;
  public var debugCollider: Bool;
  public var boostFactor: Float;
  public var boostCD: Float;
  public var hpColor: String;
  public var damageFlashTime: Float;
  public var pauseText: String;
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
