package entity;

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
}

class WhiteKnight extends entity.Enemy {
  public var state: State;

  public function new(posX: Int, posY: Int, characterData: Character, enemyImage: Bitmap) {
    super(posX, posY, characterData, enemyImage);
    this.initialize();
  }

  public override function initialize() {
    super.initialize();
    this.speed = 200;
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

    this.state.on(enter + PATTERN1, () -> {
      this.sprite.bitmap.fillRect(0, 0, 50, 50, 'green');
    });
  }

  public override function update(?deltaTime: Float) {
    super.update(deltaTime);
    this.processBossPattern();
    this.processBoundingBox();
    this.processCollision();
  }

  public function processBossPattern() {}

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
