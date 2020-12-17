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

enum abstract AnimEvents(String) from String to String {
  public var START = 'start';
  public var STOP = 'stop';
}

enum abstract StateEvents(String) from String to String {
  public var ENTERSTATE = 'enterState';
  public var TRANSITION = 'transition';
  public var EXITSTATE = 'exitState';
}
