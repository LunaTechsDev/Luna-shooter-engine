package entity;

import rm.core.Graphics;
import rm.core.Input;
import Types.Character;

using ext.PositionExt;
using ext.CharacterExt;

class Player extends Node2D {
  public var player: Character;
  public var sprite: Sprite;
  public var speed: Int;
  public var dir: {x: Int, y: Int};
  public var collider: Collider;
  public var hpGauge: SpriteGauge;

  public function new(posX: Int, posY: Int, characterData: Character, playerImage: Bitmap) {
    super(posX, posY);

    this.player = characterData;
    playerImage.addLoadListener((bitmap: Bitmap) -> {
      this.sprite = new Sprite(bitmap);
      this.collider = new Collider(this.pos.x, this.pos.y, bitmap.width, bitmap.height);
      this.hpGauge = new SpriteGauge(0, 0, cast bitmap.width, 12);
      this.sprite.addChild(this.hpGauge);
    });
  }

  public override function initialize() {
    super.initialize();
    this.speed = 400;
    this.dir = { x: 0, y: 0 };
  }

  public override function update(?deltaTime: Float) {
    super.update(deltaTime);
    this.hpGauge.updateGauge(this.player.hpRate());
    this.processMovement(deltaTime);
    this.processBoundingBox();
    this.processCollider();
    this.processSprite();
  }

  public function processMovement(deltaTime: Float) {
    this.dir.x = 0;
    this.dir.y = 0;
    if (Input.isPressed(RIGHT)) {
      this.dir.x = 1;
    }

    if (Input.isPressed(LEFT)) {
      this.dir.x = -1;
    }

    if (Input.isPressed(DOWN)) {
      this.dir.y = 1;
    }

    if (Input.isPressed(UP)) {
      this.dir.y = -1;
    }

    var xMove = this.dir.x * this.speed * deltaTime;
    var yMove = this.dir.y * this.speed * deltaTime;
    this.pos.moveBy(xMove, yMove);
  }

  public function processBoundingBox() {
    // Cannot go outside of Graphic.boxHeight/Width
    this.pos.x = this.pos.x.clampf(0, Graphics.boxWidth - this.collider.width);
    this.pos.y = this.pos.y.clampf(0, Graphics.boxHeight - this.collider.height);
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
