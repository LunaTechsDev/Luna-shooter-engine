package entity;

class Node2D extends Scriptable {
  public var pos: Position;

  public function new(posX: Int, posY: Int) {
    super();
    this.pos = { x: posX, y: posY };
  }
}
