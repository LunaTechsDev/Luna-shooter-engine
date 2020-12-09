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
    this.createAllWindows();
  }

  public function createAllWindows() {
    this.createTitle();
    this.createPauseWindow();
    this.createConfirmWindow();
  }

  public function createTitle() {
    this.pauseTitleWindow = new WindowTitle(0, 70, 125, 75);
    this.addWindow(this.pauseTitleWindow);
  }

  public function createPauseWindow() {
    var xPosition = Graphics.boxWidth / 2;
    this.pauseMenuWindow = new WindowPauseMenu(cast xPosition, 120, 150, 250);
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
    this.pauseConfirmWindow.close();
    this.addWindow(this.pauseConfirmWindow);
  }

  public function resumeHandler() {
    this.popScene();
  }

  public function retryHandler() {
    SceneManager.goto(SceneShooter);
  }

  public function returnToTitleHandler() {
    this.pauseConfirmWindow.open();
    this.pauseConfirmWindow.activate();
  }

  public function yesHandler() {
    SceneManager.goto(Scene_Title);
  }

  public function noHandler() {
    this.pauseConfirmWindow.close();
    this.pauseConfirmWindow.deactivate();
  }
}
