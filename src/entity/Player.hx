package entity;

import rm.Globals;
import rm.managers.ImageManager;
import anim.Anim;
import rm.scenes.Scene_Base;
import rm.managers.SceneManager;
import rm.core.Graphics;
import rm.core.Input;
import Types.Character;

using ext.PositionExt;
using ext.CharacterExt;

class Player extends entity.Character {
  public var player: Character;
  public var dir: {x: Int, y: Int};
  public var playerImg: Bitmap;
  public var bulletList: Array<Bullet>;
  public var boosting: Bool;
  public var boostCD: Float;
  public var boostFactor: Float;
  public var firingCooldown: Float;
  public var isDamaged: Bool;
  public var playerCoordTrail: Array<Position>;

  public function new(posX: Int, posY: Int, characterData: Character, playerImage: Bitmap) {
    super(posX, posY, characterData);
    // Initialize Important information to be passed to character
    // initialization.
    // this.player = characterData;
    this.layer = PLAYER;
    this.charImg = playerImage;
    this.playerCoordTrail = [];
    this.initialize();
  }

  public override function initialize() {
    super.initialize();
    this.bulletList = [];
    this.boostCD = Main.Params.boostCD;
    this.boostFactor = Main.Params.boostFactor;
    this.speed = Main.Params.playerSpeed;
    this.firingCooldown = Main.Params.playerFiringCooldown;
    this.dir = { x: 0, y: 0 };

    this.damageAnim = new Anim(this.sprite, (sprite, dt) -> {
      if (Graphics.frameCount % 30 == 0) {
        this.sprite.visible = true;
      } else if (Graphics.frameCount % 15 == 0) {
        this.sprite.visible = false;
      }
    });
    this.damageAnim.on(STOP, (anim: Anim) -> {
      this.sprite.visible = true;
      this.isDamaged = false;
    });
  }

  public override function update(?deltaTime: Float) {
    super.update(deltaTime);
    this.processBullets(deltaTime);
    this.processFiring(deltaTime);
    this.processMovement(deltaTime);
    this.processBoosting(deltaTime);
    this.processCoordTrail();
    this.processBoundingBox();
    if (!this.isDamaged) {
      this.processCollision();
    }
  }

  public function processBullets(deltaTime: Float) {
    this.bulletList = this.bulletList.filter((bullet) -> bullet.sprite.visible);
    this.bulletList.iter((bullet) -> {
      bullet.update(deltaTime);
      if (!bullet.sprite.visible) {
        var scene: Scene_Base = SceneManager.currentScene;
        scene.removeChild(bullet.sprite);
        // Assigning to null does nothing
        bullet = null;
      }
    });
  }

  public function processCoordTrail() {
    var xOffset = 0;
    var yOffset = 0;
    var currentPos: Position = { x: xOffset + this.pos.x, y: yOffset + this.pos.y };
    this.playerCoordTrail.push(currentPos);

    if (this.playerCoordTrail.length > 70) {
      this.playerCoordTrail.shift();
    }
  }

  public function processFiring(deltaTime: Float) {
    if (Input.isPressed(OK) && this.firingCooldown <= 0) {
      // bulletImg.fillRect(0, 0, bulletSize, bulletSize, 'white');
      var yOffset = 12;
      var bulletSize = 24;
      var bullet = createBullet(this.pos.x, this.pos.y - yOffset);
      var secondBullet = createBullet(this.pos.x + bulletSize + 4, this.pos.y - yOffset);

      var scene: Scene_Base = SceneManager.currentScene;

      scene.addChild(bullet.sprite);
      scene.addChild(secondBullet.sprite);

      bullet.fire({ x: 0, y: -1 });
      secondBullet.fire({ x: 0, y: -1 });
      this.firingCooldown = Main.Params.playerFiringCooldown;
    }
    if (this.firingCooldown > 0) {
      this.firingCooldown -= deltaTime;
    }
  }

  public function createBullet(x: Float, y: Float) {
    var bulletSize = 24;
    var bulletImg = new Bitmap(bulletSize, bulletSize);
    var playerBullet = ImageManager.loadPicture(Main.Params.playerBulletImage);
    playerBullet.addLoadListener((bitmap) -> {
      bulletImg.blt(bitmap, 0, 0, bitmap.width, bitmap.height, 0, 0, bulletSize, bulletSize);
    });
    // bulletImg.fillRect(0, 0, bulletSize, bulletSize, 'white');
    var bullet = new Bullet(PLAYERBULLET, this.char.atk, cast x, cast y, bulletImg);
    bullet.speed = Main.Params.playerBulletSpeed;
    this.bulletList.push(bullet);
    return bullet;
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

    if (Input.isPressed(SHIFT)) {
      this.boosting = true;
    }

    var xMove = this.dir.x * this.speed * deltaTime;
    var yMove = this.dir.y * this.speed * deltaTime;
    this.pos.moveBy(xMove, yMove);
  }

  public function processBoosting(deltaTime: Float) {
    var defaultSpeed = Main.Params.playerSpeed;
    if (this.boosting && this.boostCD > 0) {
      this.speed = defaultSpeed + cast defaultSpeed * (this.boostFactor * (this.boostCD / Main.Params.boostCD));
      this.boostCD -= deltaTime;
    } else {
      this.boostCD = Main.Params.boostCD;
      this.boosting = false;
      this.speed = defaultSpeed;
    }
  }

  public function processBoundingBox() {
    // Cannot go outside of Graphic.boxHeight/Width
    this.pos.x = this.pos.x.clampf(0, Graphics.boxWidth - this.collider.width);
    this.pos.y = this.pos.y.clampf(0, Graphics.boxHeight - this.collider.height);
  }

  public function processCollision() {
    for (collision in this.collider.collisions) {
      switch (collision.layer) {
        case ENEMYBULLET:
          // Do something
          var bullet: Bullet = collision.parent;
          this.takeDamage(bullet.atk);
          bullet.destroy();
        case ENEMY:
          var character: entity.Character = collision.parent;

          this.takeDamage(character.char.atk);
        case _:
          // Default do nothing
      }
    }
  }

  override public function takeDamage(damage: Int) {
    super.takeDamage(damage);
    this.isDamaged = true;
    Globals.GameScreen.startShake(2, 1, 20);
  }

  public override function destroy() {
    super.destroy();
    this.sprite.visible = false;
  }
}
