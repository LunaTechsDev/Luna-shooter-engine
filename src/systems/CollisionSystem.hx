package systems;

import utils.Fn;
import entity.Node2D;
import core.Collider;

/**
 * Handles adding and removing colllisions
 * from the colliders, which are handled
 * internally by the individually entity
 * with the collider.
 */
@:keep
@:native('CollisionSystem')
@:expose('CollisionSystem')
class CollisionSystem {
  public static var colliders: Array<Collider> = [];
  public static var colliderIds: Array<Int> = [];

  public static function initialize() {
    colliderIds.resize(100);
    colliderIds.iter((el) -> {
      el = null;
    });
  }

  public static function generateId() {
    var id = colliderIds.findIndex((el) -> el == null);
    // Collider IDs are full
    if (id == -1) {
      colliderIds.push(colliderIds.length + 1);
      id = colliderIds.length + 1;
    } else {
      colliderIds[id] = id;
    }
    return id;
  }

  public static function addCollider(collider: Collider) {
    colliders.push(collider);
    collider.id = generateId();
  }

  public static function removeCollider(collider: Collider) {
    // Remove collider ID and set to null to prevent off screen elements
    // From affect collider ID list

    colliderIds[collider.id] = null;
    collider.id = null;
    colliders.remove(collider);
    // Remove from all other colliders collision list
    colliders.iter((otherColliders) -> {
      otherColliders.collisions.remove(collider);
    });
  }

  public static function update() {
    colliders.iter((collider: Collider) -> {
      updateColliderPos(collider);
      handleCollisions(collider);
      handleNonCollisions(collider);
    });
  }

  public static function updateColliderPos(collider: Collider) {
    var parent: Node2D = collider.parent;
    if (parent != null && Fn.hasProperty(parent, 'pos')) {
      collider.x = parent.pos.x;
      collider.y = parent.pos.y;
    }
  }

  public static function handleCollisions(collider: Collider) {
    // Iterate through each collider individually and get collision colliders
    var otherCollisions = colliders.filter((collision) -> (collider.isCollided(collision)
      || collision.isCollided(collider))
      && collider.id != collision.id);
    for (collision in otherCollisions) {
      collider.addCollision(collision);
    }
  }

  public static function handleNonCollisions(collider: Collider) {
    // Iterate through each collider individually and get collision colliders
    var otherNonCollisions = colliders.filter((collision) -> (!collider.isCollided(collision)
      || !collision.isCollided(collider))
      && collider.id != collision.id);
    for (collision in otherNonCollisions) {
      collider.removeCollision(collision);
    }
  }

  public static function clear() {
    colliderIds = [];
    colliders = [];
  }
}
