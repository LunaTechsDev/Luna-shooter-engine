import rm.core.Rectangle;
import rm.windows.Window_Base;

@:keep
@:native('WindowTitle')
class WindowTitle extends Window_Base {
  public var _title: String;

  public function new(x: Int, y: Int, width: Int, height: Int) {
    #if compileMV
    super(x, y, width, height);
    #else
    var rect = new Rectangle(x, y, width, height);
    super(rect);
    #end
  }

  #if compileMV
  public override function initialize(x: Int, y: Int, width: Int, height: Int) {
    super.initialize(x, y, width, height);
    this._title = Main.Params.socialSystemTitle;
  }
  #else
  public override function initialize(rect: Rectangle) {
    super.initialize(rect);
    this._title = Main.Params.socialSystemTitle;
  }
  #end

  public override function update() {
    super.update();
    this.refresh();
  }

  public function refresh() {
    if (this.contents != null) {
      this.contents.clear();
      this.paintTitle();
    }
  }

  public function paintTitle() {
    this.contents.fontSize = 28;
    var xPosition = (this.contentsWidth() / 2) - (this.textWidth(this._title) / 2);
    #if compileMV
    this.drawTextEx(this._title, xPosition, 0);
    #else
    this.drawTextEx(this._title, xPosition, 0, this.contentsWidth());
    #end
    this.resetFontSettings();
  }
}
