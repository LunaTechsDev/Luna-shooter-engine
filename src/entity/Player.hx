package entity;

import core.Scriptable;
import Types.Character;

class Player extends Scriptable {
  public var player: Character;

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
