package spr;

import rm.core.Bitmap;
import rm.core.Sprite;

class LNSprite extends Sprite {
  public var id: Int;
  public var entity: Any;

  public function new(entity: Any, ?bitmap: Bitmap) {
    super(bitmap);
    this.entity = entity;
  }
}
