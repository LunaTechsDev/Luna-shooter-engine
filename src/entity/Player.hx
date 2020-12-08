package entity;

import rm.core.Sprite;
import rm.scenes.Scene_Base;
import rm.managers.SceneManager;
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
  public var playerImg: Bitmap;
  public var bulletList: Array<Bullet>;

  public function new(posX: Int, posY: Int, characterData: Character, playerImage: Bitmap) {
    super(posX, posY);
    this.player = characterData;
    this.playerImg = playerImage;
    this.initialize();
  }

  public override function initialize() {
    super.initialize();
    this.bulletList = [];
    this.speed = 400;
    this.dir = { x: 0, y: 0 };
    this.playerImg.addLoadListener((bitmap: Bitmap) -> {
      this.sprite = new Sprite(bitmap);
      this.collider = new Collider(PLAYER, this.pos.x, this.pos.y, bitmap.width, bitmap.height);
      CollisionSystem.addCollider(this.collider);
      this.hpGauge = new SpriteGauge(0, 0, cast bitmap.width, 12);
      this.sprite.addChild(this.hpGauge);
    });
  }

  public override function update(?deltaTime: Float) {
    super.update(deltaTime);
    this.hpGauge.updateGauge(this.player.hpRate());
    // TODO: If marked not visible -- remove it from the bullet list
    this.bulletList.iter((bullet) -> {
      bullet.update(deltaTime);
      if (bullet.sprite.visible == false) {
        var scene: Scene_Base = SceneManager.currentScene;
        scene.removeChild(bullet.sprite);
        bullet = null;
      }
    });

    this.processFiring();
    this.processMovement(deltaTime);
    this.processBoundingBox();
    this.processCollider();
    this.processSprite();
  }

  public function processFiring() {
    if (Input.isTriggered(OK)) {
      var yOffset = 12;
      var bulletImg = new Bitmap(4, 4);
      bulletImg.fillRect(0, 0, 4, 4, 'white');

      var bullet = new Bullet(cast this.pos.x, cast this.pos.y - yOffset, bulletImg);

      var scene: Scene_Base = SceneManager.currentScene;
      scene.addChild(bullet.sprite);

      this.bulletList.push(bullet);
      bullet.fire({ x: 0, y: -1 });
    }
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
    this.sprite.visible = false;
  }
}
