package entity;

class Node2D extends Scriptable {
  public var pos: Position;

  public function new(posX: Int, posY: Int) {
    super();
    this.pos = { x: 0, y: 0 };
    this.pos.x = posX;
    this.pos.y = posY;
  }
}
