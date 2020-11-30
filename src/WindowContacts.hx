import Types.Contact;
import rm.core.Graphics;
import utils.Fn;
import haxe.display.Display.Package;
import rm.core.Rectangle;
import rm.windows.Window_Selectable;

@:keep
@:native('WindowContacts')
class WindowContacts extends Window_Selectable {
  public var _keyList: Array<Dynamic>; // TODO: Contact List
  public var _currentContactList: Array<Contact>;

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
    this._keyList = ContactBook.getKeyList();
    super.initialize(x, y, width, height);
    this.close();
  }
  #else
  public override function initialize(rect: Rectangle) {
    this._keyList = ContactBook.getKeyList();
    this._currentContactList = ContactBook.getContactList(this._keyList[0]);
    super.initialize(rect);
    this.close();
  }
  #end

  public override function maxItems(): Int {
    var length = this._currentContactList.length;
    return (length > 0) ? length : 0;
  }

  public override function itemHeight(): Float {
    return 80;
  }

  public override function lineHeight(height: Int): Int {
    return (Fn.typeof(height) == 'undefined') ? 36 : height;
  }

  public override function update() {
    super.update();
    this.refresh();
  }

  public override function refresh() {
    super.refresh();
  }

  public override function drawItem(index: Int): Void {
    this.drawInformationBlock(index);
  }

  public function drawInformationBlock(index) {
    this.drawContactName(index, this.faceAreaRect(index));
    this.drawContactCharacter(index, this.faceAreaRect(index));
    this.drawContactDescription(index, this.descriptionAreaRect(index));
    this.drawContactSocialMeter(index, this.socialMeterAreaRect(index));
  }

  public function drawContactName(index: Int, rect: Rectangle) {
    this.contents.fontSize = 18;
    var contactName = this._currentContactList[index].name;
    var x = (rect.width / 2) - (this.textWidth(contactName) / 2);
    this.drawText(contactName, x, rect.y, this.contentsWidth(), 'left');
    this.resetFontSettings();
  }

  public function drawContactCharacter(index: Int, rect: Rectangle) {
    var character = this._currentContactList[index].characterName;
    var characterIndex = this._currentContactList[index].characterIndex;
    var x = (rect.width / 2);
    this.drawCharacter(character, characterIndex, x, rect.y + 76);
  }

  public function drawContactDescription(index: Int, rect: Rectangle) {
    var description = this._currentContactList[index].description;
    if (description != null) {
      this.drawTextEx('\\}${description}', Graphics.width - (rect.width + 250), rect.y + 10, rect.width);
    }
  }

  public function drawContactSocialMeter(index: Int, rect: Rectangle) {
    var socialRate = this._currentContactList[index].socialRate;
    var color1 = this.textColor(Main.Params.gaugeColor1);
    var color2 = this.textColor(Main.Params.gaugeColor2);
    #if compileMV
    this.drawGauge(
      Graphics.width - (rect.width + 40),
      rect.y - 10,
      rect.width - 20,
      Main.Params.gaugeHeight,
      socialRate,
      color1,
      color2
    );
    #else
    // No gauge height in MZ
    this.drawGauge(
      Graphics.width - (rect.width + 40),
      rect.y - 10,
      rect.width - 20,
      // Main.Params.gaugeHeight,
      socialRate,
      color1,
      color2
    );
    #end
  }

  public function faceAreaRect(index) {
    var rect = this.itemRect(index);
    rect.width = 80;
    rect.height = 80;
    return rect;
  }

  public function descriptionAreaRect(index) {
    var rect = this.itemRect(index);
    rect.height = 80;
    rect.width = 400;
    return rect;
  }

  public function socialMeterAreaRect(index) {
    var rect = this.itemRect(index);
    rect.width = 250;
    rect.height = 80;
    return rect;
  }

  public function updateContactList(indexNumber: Int) {
    var keyList = this._keyList;
    this._currentContactList = ContactBook.getContactList(keyList[indexNumber]);
  }
}
