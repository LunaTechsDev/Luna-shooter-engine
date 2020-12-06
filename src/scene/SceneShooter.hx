package scene;

import js.html.Performance;
import core.Scriptable;
import Types.Player;
import Types.Enemy;
import js.html.Performance;
import rm.scenes.Scene_Base;

class SceneShooter extends Scene_Base {
  public var enemies: Array<Enemy>;
  public var player: Player;
  public var timeStamp: Float;
  public var deltaTime: Float;
  public var scriptables: Array<Scriptable>;

  public override function initialize() {
    super.initialize();
    this.timeStamp = Performance.now();
  }

  public override function create() {
    super.create();
    this.createAllEntities();
    this.createAllWindows();
  }

  public function createAllEntities() {}

  public function createSprites() {}

  public function createAllWindows() {}

  public override function update() {
    this.deltaTime = Performance.now() - timeStamp;
    super.update();
    scriptables.each((scriptable) -> {
      scriptable.update(deltaTime);
    });
    timeStamp = Performance.now();
  }

  public function updateEnemies() {
    this.enemies.iter((enemy) -> {});
  }
}
