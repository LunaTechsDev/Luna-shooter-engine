package entity;

/**
 * A turret enemy that fires shots periodically.
 */
@:native('Turret')
class Turret extends Node2D {
  public var sprite: Sprite;
  public var turret: Enemy;

  public var collider: Collider;
  public var hpGauge: SpriteGauge;

  public function new(posX: Int, posY: Int, turretData: Enemy, enemyImage: Bitmap) {
    super(posX, posY);
    this.turret = turretData;
    enemyImage.addLoadListener((bitmap: Bitmap) -> {
      this.sprite = new Sprite(bitmap);
      this.collider = new Collider(ENEMY, this.pos.x, this.pos.y, bitmap.width, bitmap.height);
      CollisionSystem.addCollider(this.collider);
      this.hpGauge = new SpriteGauge(0, 0, cast bitmap.width, 12);
      this.sprite.addChild(this.hpGauge);
    });
  }

  public override function initialize() {
    super.initialize();
  }

  public override function update(?deltaTime: Float) {
    super.update(deltaTime);

    this.hpGauge.updateGauge(this.turret.hpRate());
    this.processCollider();
    this.processSprite();
  }

  public function processCollider() {
    this.collider.x = this.pos.x;
    this.collider.y = this.pos.y;
  }

  public function processSprite() {
    this.sprite.x = this.pos.x;
    this.sprite.y = this.pos.y;
  }

  public override function destroy() {
    super.destroy();
    this.sprite.hide();
  }
}
