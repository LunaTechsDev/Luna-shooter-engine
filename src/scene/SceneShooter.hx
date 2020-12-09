package scene;

import utils.Fn;
import core.Amaryllis;
import systems.CollisionSystem;
import rm.core.Graphics;
import win.WindowBoss;
import rm.managers.ImageManager;
import rm.core.Bitmap;
import rm.core.Sprite;
import js.Browser;
import core.Scriptable;
import rm.scenes.Scene_Base;

@:native('SceneShooter')
@:expose
class SceneShooter extends Scene_Base {
  public var timeStamp: Float;
  public var deltaTime: Float;
  public var scriptables: Array<Scriptable>;
  public var backgroundSprite: Sprite;
  public var bossWindow: WindowBoss;
  public var colliderDebugSprite: Sprite;

  public static var performance = Browser.window.performance;

  public override function initialize() {
    super.initialize();
    this.timeStamp = performance.now();
    this.scriptables = [];
    CollisionSystem.initialize();
    this.createScriptables();
  }

  public function createScriptables() {
    this.createPlayer();
    this.createEnemies();
  }

  public function createPlayer() {
    var playerData: Player = {
      atk: 3,
      def: 3,
      hp: 100,
      maxHp: 100,
      isPlayer: true,
      name: 'Koizumi'
    };
    var playerImage = new Bitmap(100, 100);
    playerImage.fillRect(0, 0, 100, 100, 'white');
    var player = new entity.Player(100, 100, playerData, playerImage);

    this.addChild(player.sprite);
    this.scriptables.push(player);
  }

  public function createEnemies() {}

  public override function create() {
    super.create();
    this.createBackground();
    this.createWindowLayer();
    this.createAllWindows();
    if (Main.Params.debugCollider) {
      this.createColliderDebugSprite();
    }
  }

  public function createBackground() {
    this.backgroundSprite = new Sprite();
    var bitmap = ImageManager.loadPicture(Main.Params.backgroundPicture);
    bitmap.addLoadListener((bitmap) -> {
      this.backgroundSprite.bitmap = bitmap;
      this.addChildAt(this.backgroundSprite, 0);
    });
  }

  public function createAllWindows() {
    this.createBossWindow();
  }

  public function createBossWindow() {
    this.bossWindow = new WindowBoss(0, 0, cast Graphics.boxWidth, 75);
    this.addWindow(this.bossWindow);
    this.bossWindow.hide();
  }

  public function createColliderDebugSprite() {
    this.colliderDebugSprite = new Sprite();
    this.colliderDebugSprite.bitmap = new Bitmap(Graphics.boxWidth, Graphics.boxHeight);
    this.addChild(this.colliderDebugSprite);
  }

  public override function update() {
    this.deltaTime = (performance.now() - timeStamp) / 1000;
    super.update();
    this.updateScriptables();
    CollisionSystem.update();
    timeStamp = performance.now();
    this.paint();
  }

  public function updateScriptables() {
    scriptables.iter((scriptable) -> {
      scriptable.update(deltaTime);
    });
  }

  public function updateBossWindow() {
    if (this.bossWindow.boss == null) {}
  }

  public function paint() {
    if (Main.Params.debugCollider) {
      this.drawColliders();
    }
  }

  public function drawColliders() {
    var colliders = CollisionSystem.colliders;
    var bitmap = this.colliderDebugSprite.bitmap;

    bitmap.clear();
    colliders.iter((collider) -> {
      var borderWidth = 2;
      bitmap.fillRect(collider.x, collider.y, collider.width, collider.height, 'red');

      bitmap.clearRect(collider.x
        + borderWidth, collider.y
        + borderWidth, collider.width
        - borderWidth * 2, collider.height
        - borderWidth * 2);
    });
  }
}
