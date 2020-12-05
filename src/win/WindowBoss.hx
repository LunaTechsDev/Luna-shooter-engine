package win;

import Types.Character;
import rm.windows.Window_Base;
import rm.core.Rectangle;

class WindowBoss extends Window_Base {
  public var boss: Character;

  public function new(x: Int, y: Int, width: Int, height: Int) {
    #if compileMV
    super(x, y, width, height);
    #else
    var rect = new Rectangle(x, y, width, height);
    super(rect);
    #end
  }

  public function setBoss(boss: Character) {
    this.boss = boss;
  }

  public function paint() {
    if (this.contents != null) {
      this.contents.clear();
      this.paintName(0, 0);
      this.paintHp(0, 12);
    }
  }

  public function paintName(x: Int, y: Int) {
    this.drawText(boss.name, x, y, this.contentsWidth(), 'center');
  }

  public function paintHp(x: Int, y: Int) {
    this.drawGauge(
      x,
      y,
      this.contentsWidth(),
      boss.hpRate(),
      Main.Params.hpColor,
      Main.Params.hpColor
    );
  }
}
