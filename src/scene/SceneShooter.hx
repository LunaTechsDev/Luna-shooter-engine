package scene;

import entity.VSpawner;
import entity.LineSpawner;
import entity.SpinningXSpawner;
import entity.XSpawner;
import entity.BulletSpawner;
import entity.SpiralSpawner;
import rm.core.TilingSprite;
import rm.core.Input;
import rm.managers.SceneManager;
import rm.core.TouchInput;
import systems.CollisionSystem;
import rm.core.Graphics;
import win.WindowBoss;
import rm.managers.ImageManager;
import rm.core.Bitmap;
import rm.core.Sprite;
import js.Browser;
import core.Scriptable;
import rm.scenes.Scene_Base;

using ext.BitmapExt;

@:native('LunaSceneShooter')
@:expose
class SceneShooter extends Scene_Base {
  public var timeStamp: Float;
  public var deltaTime: Float;
  public var scriptables: Array<Scriptable>;
  public var player: entity.Player;
  public var spawner: BulletSpawner;
  public var spawnerTwo: BulletSpawner;
  public var backgroundSprite: Sprite;
  public var backgroundParallax1: TilingSprite;
  public var bossWindow: WindowBoss;
  public var colliderDebugSprite: Sprite;
  public var screenSprite: Sprite;

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
    this.player = player;
    this.addChild(player.sprite);
    this.scriptables.push(player);
  }

  public function createEnemies() {
    var enemyBullet = ImageManager.loadPicture('enemy_bullet2full');
    enemyBullet.addLoadListener((bitmap) -> {
      var spawner = new SpinningXSpawner(this, bitmap, 300, 300);
      var secondSpawner = new XSpawner(this, bitmap, 300, 300);
      this.spawner = spawner;
      this.spawnerTwo = secondSpawner;
      spawner.start();
      secondSpawner.start();
    });
  }

  public override function create() {
    super.create();
    this.createBackground();
    this.createParallax();
    this.createWindowLayer();
    this.createAllWindows();
    if (Main.Params.debugCollider) {
      this.createColliderDebugSprite();
    }
    this.createScreenSprite();
  }

  public function createBackground() {
    this.backgroundSprite = new Sprite();
    var bitmap = ImageManager.loadPicture(Main.Params.backgroundPicture);
    bitmap.addLoadListener((bitmap) -> {
      this.backgroundSprite.bitmap = bitmap;
      this.addChildAt(this.backgroundSprite, 0);
    });
  }

  public function createParallax() {
    var forestParallax = ImageManager.loadPicture('Forest', 0);
    forestParallax.addLoadListener((bitmap) -> {
      this.backgroundParallax1 = new TilingSprite(bitmap);
      this.backgroundParallax1.move(0, 0, bitmap.width, bitmap.height);
      trace(this.backgroundParallax1);
      trace('add parallax');
      this.addChildAt(this.backgroundParallax1, 1);
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

  public function createScreenSprite() {
    this.screenSprite = new Sprite();
    this.screenSprite.bitmap = new Bitmap(Graphics.boxWidth, Graphics.boxHeight);
    this.addChild(this.screenSprite);
  }

  public override function update() {
    this.deltaTime = (performance.now() - timeStamp) / 1000;
    super.update();
    this.processScenePause();
    this.updateScriptables();
    this.updateParallax();
    this.updateBossWindow();
    CollisionSystem.update();
    this.spawner.update(this.deltaTime);
    this.spawnerTwo.update(this.deltaTime);
    timeStamp = performance.now();
    this.paint();
  }

  public function processScenePause() {
    if (Input.isTriggered(MENU) || TouchInput.isCancelled()) {
      SceneManager.push(ScenePause);
    }
  }

  public function updateScriptables() {
    scriptables.iter((scriptable) -> {
      scriptable.update(deltaTime);
    });
  }

  public function updateParallax() {
    if (this.backgroundParallax1 != null) {
      this.backgroundParallax1.origin.x -= 0.64;
    }
  }

  public function updateBossWindow() {
    if (this.bossWindow.boss == null) {}
  }

  public function paint() {
    if (Main.Params.debugCollider) {
      this.paintColliders();
    }
    this.paintPlayerTrail();
  }

  public function paintPlayerTrail() {
    var bitmap = this.screenSprite.bitmap;
    bitmap.clear();
    var coords = this.player.playerCoordTrail;
    if (coords.length > 2) {
      for (index in 1...coords.length) {
        var start = coords[index - 1];
        var end = coords[index];
        bitmap.lineTo('red', start.x, start.y, end.x, end.y);
      }
    }
  }

  public function paintColliders() {
    var colliders = CollisionSystem.colliders;
    var bitmap = this.colliderDebugSprite.bitmap;

    bitmap.clear();
    colliders.iter((collider) -> {
      var borderWidth = 2;
      if (collider.isOn) {
        bitmap.fillRect(collider.x, collider.y, collider.width, collider.height, 'red');
      } else {
        bitmap.fillRect(collider.x, collider.y, collider.width, collider.height, 'blue');
      }

      bitmap.clearRect(collider.x
        + borderWidth, collider.y
        + borderWidth, collider.width
        - borderWidth * 2, collider.height
        - borderWidth * 2);
    });
  }
}
