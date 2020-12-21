package win;

import rm.core.Rectangle;
import rm.windows.Window_Command;

@:native('WindowPauseMenu')
class WindowPauseMenu extends Window_Command {
  public function new(x: Int, y: Int, width: Int, height: Int) {
    #if compileMV
    super(x, y);
    #else
    var rect = new Rectangle(x, y, width, height);
    super(rect);
    #end
  }

  #if compileMV
  // public override function initialize() {}
  #else
  public override function initialize(rect: Rectangle) {
    super.initialize(rect);
  }
  #end

  public override function makeCommandList() {
    super.makeCommandList();
    this.addCommand('Resume', 'resume', true);
    this.addCommand('Retry', 'retry', true);
    this.addCommand('Return To Title', 'returnToTitle', true);
  }
}
