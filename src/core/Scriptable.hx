package core;

import pixi.interaction.EventEmitter;

/**
 * A class used to add scriptable enemies and objects to your game.
 */
@:native('Scriptable')
class Scriptable extends EventEmitter {
  public function initialize() {
    this.emit(INIT);
  }

  public function update(?deltaTime: Float) {
    this.emit(UPDATE);
  }

  public function destroy() {
    this.emit(DESTROY);
    this = null;
  }
}
