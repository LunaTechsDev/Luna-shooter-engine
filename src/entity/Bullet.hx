package entity;

import rm.core.Graphics;

class Bullet extends Node2D {
  public var sprite: Sprite;
  public var speed: Int;
  public var dir: {x: Int, y: Int};
  public var collider: Collider;
  public var bulletImage: Bitmap;

  public function new(posX: Int, posY: Int, bulletImage: Bitmap) {
    super(posX, posY);
    this.bulletImage = bulletImage;
    this.initialize();
  }

  public override function initialize() {
    super.initialize();
    // Bullet Speed
    this.speed = 400;
    this.dir = { x: 0, y: 0 };
    this.bulletImage.addLoadListener((bitmap) -> {
      this.sprite = new Sprite(bitmap);
      this.collider = new Collider(this.pos.x, this.pos.y, bitmap.width, bitmap.height);
    });
  }

  public function fire(direction: Position) {
    this.dir.x = cast direction.x;
    this.dir.y = cast direction.y;
  }

  public override function update(?deltaTime: Float) {
    super.update(deltaTime);
    this.processMovement(deltaTime);
    this.processSprite();
    this.processDeletion();
  }

  public function processMovement(deltaTime: Float) {
    var xMove = this.dir.x * this.speed * deltaTime;
    var yMove = this.dir.y * this.speed * deltaTime;
    this.pos.moveBy(xMove, yMove);
  }

  public function processSprite() {
    this.sprite.x = this.pos.x;
    this.sprite.y = this.pos.y;
  }

  public function processDeletion() {
    if (this.pos.x < 0 || (this.collider.width + this.pos.x) > Graphics.boxWidth) {
      this.destroy();
    }

    if (this.pos.y < 0 || (this.collider.height + this.pos.y) > Graphics.boxHeight) {
      this.destroy();
    }
  }

  public override function destroy() {
    super.destroy();
    this.sprite.visible = false;
  }
}
