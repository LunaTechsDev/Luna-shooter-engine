package entity;

import systems.SpriteSystem;
import spr.LNSprite;
import anim.Anim;

using ext.PositionExt;
using ext.CharacterExt;

@:keep
class Character extends Node2D {
  public var char: Types.Character;
  public var sprite: LNSprite;
  public var charImg: Bitmap;
  public var speed: Int;
  public var takenDamage: Bool;
  public var damageAnimTime: Float;
  public var damageAnim: Anim;
  public var collider: Collider;
  public var hpGauge: SpriteGauge;
  public var layer: CollisionLayer;

  public function new(posX: Int, posY: Int, characterData: Types.Character) {
    super(posX, posY);
    this.char = characterData;
  }

  public override function initialize() {
    this.damageAnimTime = 0;
    this.charImg.addLoadListener((bitmap: Bitmap) -> {
      this.sprite = new LNSprite(this, bitmap);
      this.collider = new Collider(
        this,
        this.layer,
        this.pos.x,
        this.pos.y,
        bitmap.width,
        bitmap.height
      );
      SpriteSystem.add(this.sprite);
      CollisionSystem.addCollider(this.collider);
      this.hpGauge = new SpriteGauge(0, 0, cast bitmap.width, 12);
      this.sprite.addChild(this.hpGauge);
    });
  }

  public function takeDamage(damage: Int) {
    // Should lower character hp based on damage taken
    this.char.hp -= damage;
    this.damageAnimTime = Main.Params.damageFlashTime;
    this.damageAnim.start();
  }

  public override function update(?deltaTime: Float) {
    super.update(deltaTime);
    if (damageAnim != null && damageAnim.isStarted) {
      this.processDamage(deltaTime);
    }
    this.processHp();
  }

  public function processDamage(deltaTime: Float) {
    if (this.damageAnimTime > 0) {
      damageAnim.update(deltaTime);
      this.damageAnimTime -= deltaTime;
    } else {
      this.damageAnim.stop();
    }
  }

  public function processHp() {
    this.hpGauge.updateGauge(this.char.hpRate());
  }
}
