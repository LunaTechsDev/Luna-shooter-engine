package ext;

class PositionExt {
  public static inline function moveTo(pos: Position, x: Float, y: Float) {
    pos.x = x;
    pos.y = y;
  }

  public static inline function moveBy(pos: Position, x: Float, y: Float) {
    pos.x += x;
    pos.y += y;
  }

  public static inline function rotate(pos: Position, degrees: Float) {
    pos.x = pos.x * Math.cos(degrees.degToRad());
    pos.y = pos.y * Math.sin(degrees.degToRad());
    return pos;
  }
}
