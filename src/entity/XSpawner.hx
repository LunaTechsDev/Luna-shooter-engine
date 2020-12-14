package entity;

import rm.scenes.Scene_Base;

class XSpawner extends BulletSpawner {
  public var fireCooldown: Float;

  public function new(scene: Scene_Base, posX: Int, posY: Int) {
    super(posX, posY);
    this.scene = scene;
    var spawnX = 10;
    var spawnY = 10;
    this.spawnPoint = { x: this.pos.x + spawnX, y: this.pos.y + spawnY };
    this.shootDirection = { x: 1, y: 1 };
    this.shootRotation = 0;
    this.fireCooldown = 0.5;
    this.bulletList = [];
  }

  public override function spawnBullet(?deltaTime: Float) {
    if (this.fireCooldown <= 0) {
      var bulletSize = 12;
      var bulletImg = new Bitmap(bulletSize, bulletSize);
      bulletImg.fillRect(0, 0, bulletSize, bulletSize, 'white');

      var topRight = 45;
      var topLeft = 125;
      var bottomLeft = 225;
      var bottomRight = 315;
      var angleList = [topRight, topLeft, bottomLeft, bottomRight];
      for (angle in angleList) {
        var bullet = new Bullet(cast this.spawnPoint.x, cast this.spawnPoint.y, bulletImg);
        bullet.speed = 200;
        this.scene.addChild(bullet.sprite);
        this.bulletList.push(bullet);
        bullet.fire(createRotationVector(angle));
      }
      this.fireCooldown = 0.25;
    } else {
      this.fireCooldown -= deltaTime;
    }
  }

  public function createRotationVector(angle: Float) {
    return { x: Math.cos(angle.degToRad()), y: Math.sin(angle.degToRad()) };
  }
}
