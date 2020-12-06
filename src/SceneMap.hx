import rm.Globals;
import rm.objects.Game_Event;
import Events.WinEvents;
import rm.scenes.Scene_Map as RmSceneMap;

using Lambda;

@:keep
class SceneMap extends RmSceneMap {
  public override function initialize() {
    untyped _Scene_Map_initialize.call(this);
  }

  public override function onMapLoaded() {
    // super.onMapLoaded();
    untyped _Scene_Map_onMapLoaded.call(this);
    // Add Contacts to List
  }

  public override function start() {
    untyped _Scene_Map_start.call(this);
  }
}
