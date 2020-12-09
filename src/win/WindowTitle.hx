package win;

import rm.core.Rectangle;
import rm.windows.Window_Base;

@:native('LNSWindowTitle')
class WindowTitle extends Window_Base {
  public var text: String;

  public function new(x: Int, y: Int, width: Int, height: Int) {
    #if compileMV
    super(x, y, width, height);
    #else
    var rect = new Rectangle(x, y, width, height);
    super(rect);
    #end
  }

  public function setTitle(text: String) {
    this.text = text;
  }

  public function paint() {
    if (this.contents != null) {
      this.contents.clear();
      this.paintTitle();
    }
  }

  public function paintTitle() {
    this.drawText(this.text, 0, 0, this.contentsWidth(), 'center');
  }
}
