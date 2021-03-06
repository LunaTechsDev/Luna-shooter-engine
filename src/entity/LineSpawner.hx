package entity;

import rm.scenes.Scene_Base;

class LineSpawner extends BulletSpawner {
  public var fireCooldown: Float;

  public function new(layer: CollisionLayer, scene: Scene_Base, bulletImg: Bitmap, posX: Int, posY: Int) {
    super(layer, bulletImg, posX, posY);
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
      // bulletImg.fillRect(0, 0, bulletSize, bulletSize, 'white');
      var bitmap = this.bulletImg;
      bulletImg.blt(bitmap, 0, 0, bitmap.width, bitmap.height, 0, 0, bulletSize, bulletSize);

      var right = 0 + this.shootRotation;
      var left = 180 + this.shootRotation;

      var angleList = [right, left];
      for (angle in angleList) {
        var bullet = new Bullet(this.layer, this.bulletAtk, cast this.spawnPoint.x, cast this.spawnPoint.y, bulletImg);
        bullet.speed = cast this.bulletSpeed;
        this.scene.addChild(bullet.sprite);
        this.bulletList.push(bullet);
        var pos = createRotationVector(angle);
        pos.y = 0;
        bullet.fire(pos);
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
