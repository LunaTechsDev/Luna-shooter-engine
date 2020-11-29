import Types.Param;
import utils.Comment;
import macros.FnMacros;
import pixi.interaction.EventEmitter;
import core.Amaryllis;
import rm.Globals;
import rm.scenes.Scene_Map as RmSceneMap;

using Lambda;
using core.StringExtensions;
using core.NumberExtensions;
using StringTools;
using utils.Fn;

@:native('LunaSocialSys')
@:expose('LunaSocialSys')
class Main {
  public static var Params: Param = null;
  public static var listener: EventEmitter = Amaryllis.createEventEmitter();

  public static function main() {
    var plugin = Globals.Plugins.filter((plugin) -> ~/<LunaSocialSys>/ig.match(plugin.description))[0];
    var params = plugin.parameters;
    Params = {
      socialSystemTitle: params['socialSystemTitle'],
      backgroundPicture: params['backgroundPicture'],
      maxColumns: Fn.parseIntJs(params['maxColumns']),
      guageHeight: Fn.parseIntJs(params['gaugeHeight']),
      gaugeColor1: Fn.parseIntJs(params['gaugeColor1']),
      gaugeColor2: Fn.parseIntJs(params['gaugeColor2']),
      negativeGaugeColor1: Fn.parseIntJs(params['guageColor1']),
      negativeGaugeColor2: Fn.parseIntJs(params['gaugeColor2']),
    }

    Comment.title('Scene_Map');
    FnMacros.jsPatch(true, RmSceneMap, SceneMap);
  }

  public static function params() {
    return Params;
  }
}
