package entity;

class BulletSpawner extends Node2D {
  public var isStarted: Bool;
  public var spawnPoint: Position;
  public var shootDirection: Position;
  public var shootRotation: Float;
  public var bulletList: Array<Bullet>;

  public function start() {
    this.isStarted = true;
  }

  public function stop() {
    this.isStarted = false;
  }

  public override function update(?deltaTime: Float) {
    if (this.isStarted) {
      this.spawnBullet(deltaTime);
      this.processBullets(deltaTime);
    }
  }

  public function spawnBullet(?deltaTime: Float) {}

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
