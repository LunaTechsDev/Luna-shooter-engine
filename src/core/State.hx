package core;

import pixi.interaction.EventEmitter;

@:native('LNState')
@:expose('LNState')
class State extends EventEmitter {
  public var currentState: String;

  public function new(state: String) {
    super();
    this.currentState = state;
    this.emit(ENTERSTATE + this.currentState);
  }

  public static function create(state: String) {
    var stateMachine = new State(state);
    return stateMachine;
  }

  public function transitionTo(state: String) {
    this.emit(EXITSTATE + this.currentState);
    this.currentState = state;
    this.emit(ENTERSTATE + this.currentState);
  }

  public function update() {
    this.emit(this.currentState);
  }
}
