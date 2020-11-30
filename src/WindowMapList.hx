import rm.core.Rectangle;
import rm.windows.Window_Selectable;

@:keep
@:native('WindowMapList')
class WindowMapList extends Window_Selectable {
  public var _mapList: Array<String>;

  public function new(x: Int, y: Int, width: Int, height: Int) {
    #if compileMV
    super(x, y, width, height);
    #else
    var rect = new Rectangle(x, y, width, height);
    super(rect);
    #end
  }

  public override function maxCols(): Int {
    var length = this._mapList.length;

    return (length > 0) ? length.clamp(1, Main.Params.maxColumns) : 1;
  }

  public override function maxPageRows() {
    return 1;
  }

  public override function maxRows() {
    return 1;
  }

  public override function maxTopRow() {
    return 1;
  }

  public override function maxItems() {
    var length = this._mapList.length;
    return (length > 0) ? length : 0;
  }

  public override function update() {
    super.update();
    this.refresh();
  }

  public override function refresh() {
    super.refresh();
    // TODO: Set current Map Name
  }

  public override function drawItem(index) {
    this.drawMapName(index);
  }

  public function drawMapName(index) {
    #if compileMV
    var rect = this.itemRectForText(index);
    #else
    var rect = this.itemRect(index);
    #end
    this.drawText(this._mapList[index], rect.x, rect.y, rect.width, 'left');
  }
}
