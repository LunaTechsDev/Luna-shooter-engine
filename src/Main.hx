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

  public static function main() {
    var plugin = Globals.Plugins.filter((plugin) -> ~/<LunaShooter>/ig.match(plugin.description))[0];
    var params = plugin.parameters;
    Params = {
      backgroundPicture: params['backgroundPicture'],
      hpColor: params['hpColor']
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
}
