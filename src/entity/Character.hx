package entity;

import anim.Anim;

@:keep
class Character extends Node2D {
  public var sprite: Sprite;
  public var takenDamage: Bool;
  public var damageAnimTime: Float;
  public var damageAnim: Anim;

  public function new(posX: Int, posY: Int) {
    super(posX, posY);
  }

  public override function initialize() {
    this.damageAnimTime = 0;
  }

  public function takeDamage() {
    this.damageAnimTime = Main.Params.damageFlashTime;
    this.damageAnim.start();
  }

  public override function update(?deltaTime: Float) {
    super.update(deltaTime);
    if (damageAnim != null && damageAnim.isStarted) {
      this.processDamage(deltaTime);
    }
  }

  public function processDamage(deltaTime: Float) {
    if (this.damageAnimTime > 0) {
      damageAnim.update(deltaTime);
      this.damageAnimTime -= deltaTime;
    } else {
      this.damageAnim.stop();
    }
  }
}
