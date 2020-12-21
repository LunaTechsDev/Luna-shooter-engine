import scene.SceneShooter;
import rm.managers.SceneManager;
import utils.Comment;
import macros.FnMacros;
import pixi.interaction.EventEmitter;
import core.Amaryllis;
import rm.Globals;
import rm.scenes.Scene_Map as RmSceneMap;
import rm.managers.DataManager as RmDataManager;

using utils.Fn;

@:native('LunaShooter')
@:expose('LunaShooter')
class Main {
  public static var Params: Param = null;
  public static var listener: EventEmitter = Amaryllis.createEventEmitter();
  public static var collisionSys = CollisionSystem;
  public static var timeScale: Float = 1.0;

  public static function main() {
    var plugin = Globals.Plugins.filter((plugin) -> ~/<LunaShooter>/ig.match(plugin.description))[0];
    var params = plugin.parameters;
    Params = {
      backgroundPicture: params['backgroundPicture'],
      playerSpeed: Fn.parseIntJs(params['playerSpeed']),
      playerBulletImage: params['playerBulletImage'],
      playerBulletSpeed: Fn.parseIntJs(params['playerBulletSpeed']),
      enemySpeed: Fn.parseIntJs(params['enemySpeed']),
      enemyBulletImage: params['enemyBulletImage'],
      enemyBulletSpeed: Fn.parseIntJs(params['enemyBulletSpeed']),
      debugCollider: params['debugCollider'].toLowerCase() == 'true',
      godMode: params['godMode'].toLowerCase() == 'true',
      hpColor: params['hpColor'],
      boostFactor: Fn.parseFloatJs(params['boostFactor']),
      boostCD: Fn.parseFloatJs(params['boostCD']),
      damageFlashTime: Fn.parseFloatJs(params['damageFlashTime']),
      pauseText: params['pauseText']
    }

    Comment.title('Scene_Map');
    FnMacros.jsPatch(true, RmSceneMap, SceneMap);

    Comment.title('DataManager');
    FnMacros.jsPatch(false, RmDataManager, DataManager);
  }

  public static function params() {
    return Params;
  }

  public static function startGameScene() {
    SceneManager.push(SceneShooter);
  }

  public static function setTimeScale(scale: Float) {
    timeScale = scale;
  }

  public static function getTimeScale() {
    return timeScale;
  }
}
