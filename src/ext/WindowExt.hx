package ext;

import rm.windows.Window_Base;

class WindowExt {
  #if compileMV
  #else
  public static function drawGauge(win: Window_Base, x: Float, y: Float, width: Float, rate: Float, color1: String,
      color2: String) {
    var fillW = Math.floor(width * rate);
    var gaugeY = y + win.lineHeight() - 8;
    win.contents.fillRect(x, gaugeY, width, 6, 'black');
    win.contents.gradientFillRect(x, gaugeY, fillW, 6, color1, color2);
  }
  #end
}
