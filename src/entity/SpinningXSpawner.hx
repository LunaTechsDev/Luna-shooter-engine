package entity;

import rm.scenes.Scene_Base;

class SpinningXSpawner extends XSpawner {
  public function new(scene: Scene_Base, posX: Int, posY: Int) {
    super(scene, posX, posY);
  }

  public override function spawnBullet(?deltaTime: Float) {
    if (this.fireCooldown <= 0) {
      var bulletSize = 12;
      var bulletImg = new Bitmap(bulletSize, bulletSize);
      bulletImg.fillRect(0, 0, bulletSize, bulletSize, 'white');

      var topRight = 45 + this.shootRotation;
      var topLeft = 125 + this.shootRotation;
      var bottomLeft = 225 + this.shootRotation;
      var bottomRight = 315 + this.shootRotation;
      var angleList = [topRight, topLeft, bottomLeft, bottomRight];
      for (angle in angleList) {
        var bullet = new Bullet(cast this.spawnPoint.x, cast this.spawnPoint.y, bulletImg);
        bullet.speed = 200;
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
