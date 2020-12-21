package win;

import rm.core.Rectangle;
import rm.windows.Window_HorzCommand;

@:native('LNWindowConfirmMenu')
class WindowConfirmMenu extends Window_HorzCommand {
  public function new(x: Int, y: Int, width: Int, height: Int) {
    #if compileMV
    super(x, y);
    #else
    var rect = new Rectangle(x, y, width, height);
    super(rect);
    #end
  }

  public override function makeCommandList() {
    this.addCommand('Yes', 'yes', true);
    this.addCommand('No', 'no', true);
  }

  @:keep
  public override function maxCols() {
    return 2;
  }

  public override function maxItems(): Float {
    return 2;
  }
}
