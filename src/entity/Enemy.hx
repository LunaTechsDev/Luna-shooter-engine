package entity;

class Enemy extends entity.Character {
  public var enemyImage: Bitmap;
  public var timeScale: Float;

  public function new(posX: Int, posY: Int, characterData: Character, enemyImg: Bitmap) {
    super(posX, posY, characterData);
    this.layer = ENEMY;
    this.charImg = enemyImg;
  }

  public function setTimeScale(scale: Float) {
    this.timeScale = scale;
  }
}
