package systems;

import core.Collider;

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
    colliderIds[collider.id] = null;
    colliders.remove(collider);
  }

  public static function update() {
    colliders.iter((collider: Collider) -> {
      var otherCollisions = colliders.filter((collision) -> collider.isCollided(collision)
        && collider.id != collision.id);
      for (collision in otherCollisions) {
        collider.addCollision(collision);
      }
    });
  }
}
