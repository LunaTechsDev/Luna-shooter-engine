package entity;

import rm.scenes.Scene_Base;

class SpiralSpawner extends Node2D {
  public var isStarted: Bool;
  public var spawnPoint: Position;
  public var shootDirection: Position;
  public var shootRotation: Float;
  public var bulletList: Array<Bullet>;

  public function new(scene: Scene_Base, posX: Int, posY: Int) {
    super(posX, posY);
    this.scene = scene;
    var spawnX = 10;
    var spawnY = 10;
    this.spawnPoint = { x: this.pos.x + spawnX, y: this.pos.y + spawnY };
    this.shootDirection = { x: 1, y: 1 };
    this.shootRotation = 0;
    this.bulletList = [];
  }

  public function start() {
    this.isStarted = true;
  }

  public function stop() {
    this.isStarted = false;
  }

  public override function update(?deltaTime: Float) {
    if (this.isStarted) {
      this.spawnBullet();
      this.processBullets(deltaTime);
    }
  }

  public function spawnBullet() {
    var bulletSize = 12;
    var bulletImg = new Bitmap(bulletSize, bulletSize);
    bulletImg.fillRect(0, 0, bulletSize, bulletSize, 'white');
    var bullet = new Bullet(cast this.spawnPoint.x, cast this.spawnPoint.y, bulletImg);
    bullet.speed = 200;
    this.shootRotation += 15;
    this.scene.addChild(bullet.sprite);
    this.bulletList.push(bullet);
    bullet.fire({ x: Math.cos(this.shootRotation.degToRad()), y: Math.sin(this.shootRotation.degToRad()) });
  }

  public function processBullets(deltaTime: Float) {
    this.bulletList = this.bulletList.filter((bullet) -> bullet.sprite.visible);
    this.bulletList.iter((bullet) -> {
      bullet.update(deltaTime);
      if (bullet.sprite.visible == false) {
        this.scene.removeChild(bullet.sprite);
        // Assigning to null does nothing
        bullet = null;
      }
    });
  }
}
