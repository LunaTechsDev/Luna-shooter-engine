import rm.types.RM.TextState;
import Types.RogueInfo;
import rm.types.RPG.Enemy;
import rm.types.RPG.Item;
import rm.core.Rectangle;
import rm.windows.Window_Base;

using Lambda;
using StringTools;

/**
 * Rogue Informational window.
 * This window will float near an enemy, monster, or item
 * to display information on that entity to the user via consolidated information.
 * By default should be 1:1.5
 */
@:keep
@:native('WindowRogueInfo')
class WindowRogueInfo extends Window_Base {
  public var _info: RogueInfo;

  public function new(x: Int, y: Int, width: Int, height: Int) {
    #if compileMV
    super(x, y, width, height);
    #else
    var rect = new Rectangle(x, y, width, height);
    super(rect);
    #end
    this._info = null;
  }

  public function setRogueInfo(info: RogueInfo) {
    this._info = info;
  }

  #if compileMV
  public override function drawTextEx(text: String, x: Float, y: Float): Float {
    return super.drawTextEx(text, x, y);
  }
  #else
  public override function drawTextEx(text: String, x: Float, y: Float, width: Float): Float {
    this.resetFontSettings();
    final textState = untyped this.createTextState(text, x, y, width);
    this.updateTextState(textState);
    this.processAllText(textState);
    return textState.outputWidth;
  }
  #end

  public function paintItemBlock(item: Item) {
    if (this.contents != null) {
      this.contents.clear();
      this.paintName(0, 0);
      this.paintDescription(0, 40);
    }
  }

  public function paintMonsterBlock(monster: Enemy) {
    if (this.contents != null) {
      this.contents.clear();
      this.paintName(0, 0);
      this.paintDescription(0, 40);
    }
  }

  public function paintName(x: Int, y: Int) {
    #if compileMV
    this.drawTextEx(this._info.name, x, y);
    #else
    this.drawTextEx(this._info.name, x, y, this.contentsWidth());
    #end
  }

  public function paintDescription(x: Int, y: Int) {
    #if compileMV
    this.drawTextEx(this._info.name, x, y);
    #else
    this.drawTextEx(this._info.name, x, y, this.contentsWidth());
    #end
  }

  // Word Wrap Support
  public function updateTextState(originalTextState: TextState) {
    // if (Main.Params.removeManualLineBreaks) {
    //   originalTextState.text = originalTextState.text.replace('\n', ' ');
    // }
    var textState = originalTextState;

    var length = originalTextState.text.length;
    while (originalTextState.index < length) {
      var currentLines = textState.text.substring(0, textState.index + 1).split('\n');
      var latestLine = currentLines[currentLines.length - 1];
      var textUpToIndex = latestLine.substring(0, latestLine.length);
      if (untyped textWidth(textUpToIndex) > this.contentsWidth()) {
        // Look for last space on the latestLine to break on word
        var spaceOffset = 1;
        while (!textUpToIndex.isSpace(textUpToIndex.length - spaceOffset)) {
          spaceOffset += 1;
          trace('Processing Text Offset', spaceOffset);
        }
        // Adjusting for the initial space offset
        var textWithBreak = textState.text.substring(0, textState.index - (spaceOffset - 1));
        // Adjusting for the space we found
        var textAfterBreak = textState.text.substring(textState.index - (spaceOffset - 2), textState.text.length);
        textState.text = textWithBreak + '\n' + textAfterBreak;
      }
      originalTextState.index++;
    }
    originalTextState.index = 0;
  }
}
