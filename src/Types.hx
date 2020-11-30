typedef Param = {
  public var socialSystemTitle: String;
  public var backgroundPicture: String;
  public var maxColumns: Int;
  public var guageHeight: Int;
  public var gaugeColor1: Int;
  public var gaugeColor2: Int;
  public var negativeGaugeColor1: Int;
  public var negativeGaugeColor2: Int;
}

typedef RogueInfo = {
  public var name: String;
  public var ?hp: Int;
  public var description: String;
}

typedef Contact = {
  public var characterName: String;
  public var characterIndex: Int;
  public var id: Int;
  public var name: String;
  public var description: String;
  public var longDescription: String;
  public var socialRate: Float;
}
