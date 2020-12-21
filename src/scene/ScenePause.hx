package scene;

import win.WindowTitle;
import rm.scenes.Scene_Title;
import rm.managers.SceneManager;
import win.WindowConfirmMenu;
import rm.core.Graphics;
import win.WindowPauseMenu;
import rm.scenes.Scene_MenuBase;

@:native('LunaScenePause')
@:expose
class ScenePause extends Scene_MenuBase {
  public var pauseTitleWindow: WindowTitle;
  public var pauseMenuWindow: WindowPauseMenu;
  public var pauseConfirmWindow: WindowConfirmMenu;

  public override function create() {
    this.createWindowLayer();
    this.createAllWindows();
  }

  public function createAllWindows() {
    this.createTitle();
    this.createPauseWindow();
    this.createConfirmWindow();
  }

  public function createTitle() {
    var width = 175;
    var centerX = (Graphics.boxWidth / 2) - (width / 2);
    this.pauseTitleWindow = new WindowTitle(cast centerX, 70, width, 75);
    this.addWindow(this.pauseTitleWindow);
    this.pauseTitleWindow.setTitle(Main.Params.pauseText);
  }

  public function createPauseWindow() {
    var width = 150;
    var xPosition = (Graphics.boxWidth / 2) - (width / 2);
    this.pauseMenuWindow = new WindowPauseMenu(cast xPosition, cast this.pauseTitleWindow.y
      + this.pauseTitleWindow.height
      + 30, width, 250);
    this.pauseMenuWindow.setHandler('resume', untyped this.resumeHandler);
    this.pauseMenuWindow.setHandler('retry', untyped this.retryHandler);
    this.pauseMenuWindow.setHandler('returnToTitle', untyped this.returnToTitleHandler);
    this.pauseMenuWindow.activate();
    this.addWindow(this.pauseMenuWindow);
  }

  public function createConfirmWindow() {
    var win = this.pauseMenuWindow;
    this.pauseConfirmWindow = new WindowConfirmMenu(cast win.x, cast win.y, 150, 75);
    this.pauseConfirmWindow.setHandler('yes', untyped this.yesHandler);
    this.pauseConfirmWindow.setHandler('no', untyped this.noHandler);
    this.pauseConfirmWindow.hide();
    this.pauseConfirmWindow.close();
    this.addWindow(this.pauseConfirmWindow);
  }

  public override function update() {
    super.update();
  }

  public function resumeHandler() {
    this.popScene();
  }

  public function retryHandler() {
    SceneManager.goto(SceneShooter);
  }

  public function returnToTitleHandler() {
    this.pauseConfirmWindow.show();
    this.pauseConfirmWindow.open();
    this.pauseConfirmWindow.activate();
  }

  public function yesHandler() {
    SceneManager.goto(Scene_Title);
  }

  public function noHandler() {
    this.pauseConfirmWindow.close();
    this.pauseConfirmWindow.deactivate();
    this.pauseMenuWindow.activate();
  }
}
