package core;

import rm.core.Rectangle;

class Collider extends Rectangle {
  public var id: Int;
  public var inCollission: Bool;
  public var layer: CollisionLayer;
  public var isOn: Bool;
  public var parent: Any;
  public var collisions: Array<Collider>;

  public function new(parent: Any, layer: CollisionLayer, x: Float, y: Float, width: Float, height: Float) {
    super(x, y, width, height);
    this.parent = parent;
    this.layer = layer;
    this.isOn = true;
    this.collisions = [];
  }

  public function isCollided(collider: Collider): Bool {
    var topLeft = { x: this.x, y: this.y };
    var bottomLeft = { x: this.x, y: this.y + this.height };
    var topRight = { x: this.x + this.width, y: this.y };
    var bottomRight = { x: this.x + this.width, y: this.y + this.height };
    return collider.contains(topLeft.x, topLeft.y)
      || collider.contains(bottomLeft.x, bottomLeft.y)
      || collider.contains(topRight.x, topRight.y)
      || collider.contains(bottomRight.x, bottomRight.y);
  }

  public function addCollision(collision: Collider) {
    if (!this.collisions.contains(collision)) {
      this.collisions.push(collision);
    }
  }

  public function removeCollision(collision: Collider) {
    if (this.collisions.contains(collision) && !collision.isCollided(this)) {
      this.collisions.remove(collision);
    }
  }
}
