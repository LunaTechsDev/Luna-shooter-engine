package entity;

import rm.scenes.Scene_Base;
import rm.managers.SceneManager;
import rm.managers.ImageManager;
import anim.Anim;
import rm.core.Graphics;
import core.State;

using StringTools;

enum abstract WKState(String) from String to String {
  public var IDLE = 'idle';

  /**
   * Pattern 1 is the basic pattern ->
   * This fires a V Shaped bullet spawner at the player
   *
   */
  public var PATTERN1 = 'pattern1';

  public var PATTERN2 = 'pattern2';
  public var DEATH = 'death';
}

class WhiteKnight extends entity.Enemy {
  public var state: State;
  public var spawner: BulletSpawner;
  public var spawnerTwo: BulletSpawner;
  public var dir: Position;
  public var deltaTime: Float;
  public var moveTimer: Float;

  public function new(scene: Scene_Base, posX: Int, posY: Int, characterData: Character, enemyImage: Bitmap) {
    super(posX, posY, characterData, enemyImage);
    this.scene = scene;
    this.initialize();
  }

  public override function initialize() {
    super.initialize();
    // MoveTimer = 2.5;
    this.moveTimer = 2.5;
    this.dir = { x: 0, y: 0 };
    this.speed = 200;
    this.createSpawners();
    this.state = State.create(IDLE);
    this.setupStates();
    this.state.transitionTo(IDLE);

    this.damageAnim = new Anim(this.sprite, (sprite, dt) -> {
      if (Graphics.frameCount % 30 == 0) {
        this.sprite.visible = true;
      } else if (Graphics.frameCount % 15 == 0) {
        this.sprite.visible = false;
      }
    });
    this.damageAnim.on(STOP, (anim: Anim) -> {
      this.sprite.visible = true;
    });
  }

  public function setupStates() {
    var enter: String = ENTERSTATE;
    this.state.on(enter + IDLE, () -> {
      this.sprite.bitmap.fillRect(0, 0, 50, 50, 'blue');
    });

    // Starting Pattern for normal hp
    this.state.on(enter + PATTERN1, () -> {
      this.dir.x = -1;
      this.sprite.bitmap.fillRect(0, 0, 50, 50, 'green');
      this.spawner.start();
    });

    this.state.on(PATTERN1, () -> {
      this.pattern1();
    });

    // Low Hp
    this.state.on(enter + PATTERN2, () -> {
      this.sprite.bitmap.fillRect(0, 0, 50, 50, 'pink');
      this.spawnerTwo.start();
    });

    this.state.on(PATTERN2, () -> {
      this.pattern2();
    });
  }

  public function createSpawners() {
    var enemyBullet = ImageManager.loadPicture('enemy_bullet2full');
    var spawnerX = this.pos.x;
    var spawnerY = this.pos.y;
    enemyBullet.addLoadListener((bitmap) -> {
      var spawner = new SpinningXSpawner(ENEMYBULLET, this.scene, bitmap, cast spawnerX, cast spawnerY);
      var secondSpawner = new XSpawner(ENEMYBULLET, this.scene, bitmap, cast spawnerX, cast spawnerY);
      this.spawner = spawner;
      this.spawnerTwo = secondSpawner;
    });
  }

  public override function update(?deltaTime: Float) {
    super.update(deltaTime);
    this.processSpawners(deltaTime);
    this.processBossPattern();
    this.processBoundingBox();
    this.processCollision();
  }

  public function processSpawners(deltaTime) {
    this.deltaTime = deltaTime;
    this.spawner.update(deltaTime);
    this.spawnerTwo.update(deltaTime);
  }

  public function processBossPattern() {
    this.state.update();
  }

  public function pattern1() {
    if (this.moveTimer <= 0) {
      this.dir.x = this.dir.x * -1;
      this.moveTimer = 2.5;
    } else {
      this.moveTimer -= this.deltaTime;
    }
    var xMove = this.dir.x * this.speed * this.deltaTime;
    var yMove = this.dir.y * this.speed * this.deltaTime;
    this.pos.moveBy(xMove, yMove);
    this.spawner.pos.moveTo(this.pos.x, this.pos.y);
    this.spawnerTwo.pos.moveTo(this.pos.x, this.pos.y);
    if (this.char.hpRate() < .50) {
      this.state.transitionTo(PATTERN2);
    }
  }

  public function pattern2() {
    if (this.char.hpRate() <= 0) {
      this.state.transitionTo(DEATH);
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
        case PLAYERBULLET:
          // Do something
          this.takeDamage();
        case PLAYER:
          this.takeDamage();
        case _:
          // Default do nothing
      }
    }
  }

  public override function destroy() {
    super.destroy();
    this.sprite.visible = false;
  }
}
