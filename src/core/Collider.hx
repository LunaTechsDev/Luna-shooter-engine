package core;

import rm.core.Rectangle;

class Collider extends Rectangle {
  public function new(x: Float, y: Float, width: Float, height: Float) {
    super(x, y, width, height);
  }

  public function isCollided(collider: Collider): Bool {
    var topLeft = { x: this.x, y: this.y };
    var bottomLeft = { x: this.x, y: this.y + this.height };
    var topRight = { x: this.x + this.width, y: this.x };
    var bottomRight = { x: this.x + this.width, y: this.y + this.height };
    return collider.contains(topLeft.x, topLeft.y)
      || collider.contains(bottomLeft.x, bottomLeft.y)
      || collider.contains(topRight.x, topRight.y)
      || collider.contains(bottomRight.x, bottomRight.y);
  }
}
