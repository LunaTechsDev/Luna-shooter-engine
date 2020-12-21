package entity;

import rm.scenes.Scene_Base;

class SpinningXSpawner extends XSpawner {
  public function new(layer: CollisionLayer, scene: Scene_Base, bulletImg: Bitmap, posX: Int, posY: Int) {
    super(layer, scene, bulletImg, posX, posY);
  }

  public override function spawnBullet(?deltaTime: Float) {
    if (this.fireCooldown <= 0) {
      var spawnX = 10;
      var spawnY = 10;
      this.spawnPoint = { x: this.pos.x + spawnX, y: this.pos.y + spawnY };
      var bulletSize = 12;
      var bulletImg = new Bitmap(bulletSize, bulletSize);
      // bulletImg.fillRect(0, 0, bulletSize, bulletSize, 'white');
      var bitmap = this.bulletImg;
      bulletImg.blt(bitmap, 0, 0, bitmap.width, bitmap.height, 0, 0, bulletSize, bulletSize);

      var topRight = 45 + this.shootRotation;
      var topLeft = 125 + this.shootRotation;
      var bottomLeft = 225 + this.shootRotation;
      var bottomRight = 315 + this.shootRotation;
      var angleList = [topRight, topLeft, bottomLeft, bottomRight];
      for (angle in angleList) {
        var bullet = new Bullet(this.layer, this.bulletAtk, cast this.spawnPoint.x, cast this.spawnPoint.y, bulletImg);
        bullet.speed = cast this.bulletSpeed;
        this.scene.addChild(bullet.sprite);
        this.bulletList.push(bullet);
        bullet.fire(createRotationVector(angle));
      }
      this.shootRotation += 15;
      this.fireCooldown = 0.25;
    } else {
      this.fireCooldown -= deltaTime;
    }
  }
}
