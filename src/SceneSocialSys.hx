import rm.managers.SceneManager;
import rm.core.TouchInput;
import rm.core.Input;
import rm.core.Graphics;
import rm.core.Sprite;
import rm.managers.ImageManager;
import rm.scenes.Scene_MenuBase;

class SceneSocialSys extends Scene_MenuBase {
  public var _socialBackSprite: rm.core.Sprite;
  public var _titleWindow: WindowTitle;
  public var _mapListWindow: WindowMapList;
  public var _contactsWindow: WindowContacts;

  public override function create() {
    super.create();
    this.createBackground();
    this.createWindowLayer();
    this.createAllWindows();
  }

  public override function createBackground() {
    this._socialBackSprite = new Sprite();
    this._socialBackSprite.bitmap = ImageManager.loadPicture(Main.Params.backgroundPicture);
    this.addChild(this._socialBackSprite);
  }

  public function createAllWindows() {
    this.createTitleWindow();
    this.createMapListWindow();
    this.createContactsWindow();
  }

  public function createTitleWindow() {
    this._titleWindow = new WindowTitle(0, 0, cast Graphics.boxWidth, 75);
    this.addWindow(this._titleWindow);
  }

  public function createMapListWindow() {
    this._mapListWindow = new WindowMapList(0, 76, cast Graphics.boxWidth, 75);
    this.addWindow(this._mapListWindow);
  }

  public function createContactsWindow() {
    this._contactsWindow = new WindowContacts(0, 151, cast Graphics.boxWidth, cast Graphics.boxHeight - 150);
    this.addWindow(this._contactsWindow);
  }

  public override function start() {
    super.start();
    this.setupHandlers();
    this._mapListWindow.activate();
    this._mapListWindow.select(0);
  }

  public function setupHandlers() {
    untyped this._mapListWindow.setHandler('ok', untyped this.updateContactWindow.bind(this));
    untyped this._contactsWindow.setHandler('cancel', untyped this.updateMapListWindow.bind(this));
    untyped this._contactsWindow.setHandler('ok', untyped this.viewContactDetails.bind(this));
  }

  public override function update() {
    super.update();
    this.processExit();
  }

  public function processExit() {
    if (Input.isTriggered('cancel') || TouchInput.isCancelled()) {
      this.popScene();
    }
  }

  public function updateContactWindow() {
    this._mapListWindow.deactivate();
    this._contactsWindow.updateContactList(this._mapListWindow.index());
    this._contactsWindow.open();
    this._contactsWindow.activate();
    this._contactsWindow.select(0);
  }

  public function updateMapListWindow() {
    this._contactsWindow.deactivate();
    this._mapListWindow.activate();
  }

  public function viewContactDetails() {
    var contact = this._contactsWindow.getCurrentContact();
    if (contact != null) {
      SceneManager.push(SceneSocialDetails);
      SocialRequester.setCurrentContact(contact);
    }
  }
}
