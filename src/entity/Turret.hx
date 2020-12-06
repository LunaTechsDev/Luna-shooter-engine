package entity;

import core.Scriptable;

/**
 * A turret enemy that fires shots periodically.
 */
@:native('Turret')
class Turret extends Scriptable {
  public override function initialize() {
    super.initialize();
  }

  public override function update(?deltaTime: Float) {
    super.update(deltaTime);
  }

  public override function destroy() {
    super.destroy();
  }
}
