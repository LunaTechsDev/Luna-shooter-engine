package systems;

import spr.LNSprite;
import utils.Fn;
import entity.Node2D;

/**
 * Handles adding and removing colllisions
 * from the sprites, which are handled
 * internally by the individually entity
 * with the collider.
 */
class SpriteSystem {
  public static var sprites: Array<LNSprite> = [];
  public static var spriteIds: Array<Int> = [];

  public static function initialize() {
    spriteIds.resize(100);
    spriteIds.iter((el) -> {
      el = null;
    });
  }

  public static function generateId() {
    var id = spriteIds.findIndex((el) -> el == null);
    // Collider IDs are full
    if (id == -1) {
      spriteIds.push(spriteIds.length + 1);
      id = spriteIds.length + 1;
    } else {
      spriteIds[id] = id;
    }
    return id;
  }

  public static function add(sprite: LNSprite) {
    sprites.push(sprite);
    sprite.id = generateId();
  }

  public static function remove(sprite: LNSprite) {
    // Remove collider ID and set to null to prevent off screen elements
    // From affect collider ID list
    spriteIds[sprite.id] = null;
    sprite.id = null;
    sprites.remove(sprite);
  }

  public static function update() {
    sprites.iter((sprite: LNSprite) -> {
      updateSpritePos(sprite);
    });
  }

  public static function updateSpritePos(sprite: LNSprite) {
    var parent: Node2D = sprite.entity;
    if (parent != null && Fn.hasProperty(parent, 'pos')) {
      sprite.x = parent.pos.x;
      sprite.y = parent.pos.y;
    }
  }
}
