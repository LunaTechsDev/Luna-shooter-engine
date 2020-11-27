import rm.Globals;
import rm.objects.Game_Event;
import Types.RogueInfo;
import Events.WinEvents;
import rm.scenes.Scene_Map as RmSceneMap;

using Lambda;

@:keep
class SceneMap extends RmSceneMap {
  public var _rogueInfoWindow: WindowRogueInfo;
  public var _rogueEntities: Array<Game_Event>;

  public override function initialize() {
    untyped _Scene_Map_initialize.call(this);
    this._rogueInfoWindow = null;
    this._rogueEntities = [];
  }

  public override function start() {
    untyped _Scene_Map_start.call(this);
    this.setupRogueEngine();
    this.setupRogueEvents();
  }

  public function setupRogueEngine() {
    this.setupRogueEntities();
    this.setupRogueEvents();
  }

  public function setupRogueEntities() {
    var itemLink = ~/<LREI:\s*(\d+)\s*>/ig;
    var enemyLink = ~/<LREE:\s*(\d+)\s*>/ig;
    var weaponLink = ~/<LREE:\s*(\d+)\s*>/ig;
    var armorLink = ~/<LREE:\s*(\d+)\s*>/ig;
    // Gather List of Entities/Events On the Map that are Rogue Elements
    this._rogueEntities = Globals.GameMap.events().filter((event) -> {
      return [itemLink, enemyLink, weaponLink, armorLink].exists((re) -> re.match(event.event().note));
    });
  }

  public function setupRogueEvents() {}

  public override function createAllWindows() {
    untyped _Scene_Map_createAllWindows.call(this);
    this.createRogueInfoWindow();
  }

  public function createRogueInfoWindow() {
    this._rogueInfoWindow = new WindowRogueInfo(0, 0, 200, 250);
    this.addWindow(this._rogueInfoWindow);
    this.setupRogueWindowEvents(this._rogueInfoWindow);
  }

  public function setupRogueWindowEvents(win: WindowRogueInfo) {
    this._rogueInfoWindow.on(WinEvents.STARTHOVER, (win: WindowRogueInfo) -> {});

    this._rogueInfoWindow.on(WinEvents.STOPHOVER, (win: WindowRogueInfo) -> {});

    this._rogueInfoWindow.on(WinEvents.PAINT, (win: WindowRogueInfo, info: RogueInfo) -> {});
  }

  public override function update() {
    untyped _Scene_Map_update.call(this);
    this.processRogueInfoWindow();
  }

  public function processRogueInfoWindow() {}
}
