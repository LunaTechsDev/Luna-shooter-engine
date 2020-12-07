package spr;

import rm.core.Bitmap;
import rm.core.Sprite;

class SpriteGauge extends Sprite {
  public function new(x: Int, y: Int, width: Int, height: Int) {
    super();
    var bitmap = new Bitmap(width, height);
    this.bitmap = bitmap;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  public override function update() {
    super.update();
  }

  public function updateGauge(hpRate: Float) {
    this.paintGauge(hpRate);
  }

  public function paintGauge(rate: Float) {
    var contents = this.bitmap;
    var fillW = Math.floor(this.width * rate);
    var gaugeY = 0;
    contents.fillRect(x, gaugeY, this.width, this.height, 'black');
    contents.gradientFillRect(
      x,
      gaugeY,
      fillW,
      this.height,
      Main.Params.hpColor,
      Main.Params.hpColor
    );
  }
}
