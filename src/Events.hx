enum abstract WinEvents(String) from String to String {
  public var PAINT = 'paint';
  public var STARTHOVER = 'startHover';
  public var STOPHOVER = 'stopHover';
  public var CLOSE = 'close';
  public var OPEN = 'open';
}

enum abstract ScriptEvents(String) from String to String {
  public var UPDATE = 'update';
  public var INIT = 'init';
  public var DESTROY = 'destroy';
}
