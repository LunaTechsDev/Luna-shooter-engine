/** ============================================================================
 *
 *  Luna_Shooter.js
 * 
 *  Build Date: 12/6/2020
 * 
 *  Made with LunaTea -- Haxe
 *
 * =============================================================================
*/
// Generated by Haxe 4.1.3
/*:
@author LunaTechs - Kino
@plugindesc A plugin that adds a social system to RPGMakerMV/MZ <LunaShooter>.

@target MV MZ


@param hpColor
@text  Hp Color
@desc The color of the HP gauges(css color)
@default B33951 


@param backgroundPicture
@text Background Picture
@desc The name of the background image in the social system scene.
@default Translucent



@help
==== How To Use ====

 Note: contactId is the same as the eventId on that map.
 
 LunaSocialSys.setContactDescription(contactName, description)
  - Update/change the contact description you entered.
  
 LunaSocialSys.getContactDescription(contactName)
  - Returns the contact description (can store in a game variable).
  
 LunaSocialSys.setContactSocialRate(contactName, rate) 
 - Adjusts the socialMeter 0 - 100
 
 LunaSocialSys.updateContactSocialRate(contactName, value)
 - Add/Subtract the social rate by some value (converted to decimal).
 - You can enter negative or positive numbers.
    
 LunaSocialSys.getContactSocialRate(contactName)
 - Returns the contact social rate (can store this in a game variable).
  Note: It will be between 0 - 100; it won't be in decimal format.

 LunaSocialSys.startSocialSystemScene()
  - Starts the social System scene.
MIT License
Copyright (c) 2020 LunaTechsDev
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE
*/

(function ($hx_exports, $global) {
  "use strict";
  var $estr = function () {
      return js_Boot.__string_rec(this, "");
    },
    $hxEnums = $hxEnums || {};
  class DMManager extends DataManager {}

  DMManager.__name__ = true;
  class EReg {
    constructor(r, opt) {
      this.r = new RegExp(r, opt.split("u").join(""));
    }
    match(s) {
      if (this.r.global) {
        this.r.lastIndex = 0;
      }
      this.r.m = this.r.exec(s);
      this.r.s = s;
      return this.r.m != null;
    }
  }

  EReg.__name__ = true;
  class Lambda {
    static iter(it, f) {
      let x = $getIterator(it);
      while (x.hasNext()) {
        let x1 = x.next();
        f(x1);
      }
    }
  }

  Lambda.__name__ = true;
  class LunaShooter {
    static main() {
      let _g = [];
      let _g1 = 0;
      let _g2 = $plugins;
      while (_g1 < _g2.length) {
        let v = _g2[_g1];
        ++_g1;
        if (new EReg("<LunaShooter>", "ig").match(v.description)) {
          _g.push(v);
        }
      }
      let plugin = _g[0];
      let params = plugin.parameters;
      LunaShooter.Params = {
        backgroundPicture: params["backgroundPicture"],
        hpColor: params["hpColor"],
      };

      //=============================================================================
      // Scene_Map
      //=============================================================================
      let _Scene_Map_initialize = Scene_Map.prototype.initialize;
      Scene_Map.prototype.initialize = function () {
        _Scene_Map_initialize.call(this);
      };
      let _Scene_Map_onMapLoaded = Scene_Map.prototype.onMapLoaded;
      Scene_Map.prototype.onMapLoaded = function () {
        _Scene_Map_onMapLoaded.call(this);
      };
      let _Scene_Map_start = Scene_Map.prototype.start;
      Scene_Map.prototype.start = function () {
        _Scene_Map_start.call(this);
      };

      //=============================================================================
      // DataManager
      //=============================================================================
      let _DataManager_makeSaveContents = DataManager.makeSaveContents;
      DataManager.makeSaveContents = function () {
        let contents = {};
        contents = _DataManager_makeSaveContents.call(this);
        contents.allMapContacts = {};
        return contents;
      };
      let _DataManager_extractSaveContents = DataManager.extractSaveContents;
      DataManager.extractSaveContents = function (contents) {
        _DataManager_extractSaveContents.call(this);
      };
    }
    static params() {
      return LunaShooter.Params;
    }
    static startGameScene() {
      SceneManager.push(SceneShooter);
    }
  }

  $hx_exports["LunaShooter"] = LunaShooter;
  LunaShooter.__name__ = true;
  Math.__name__ = true;
  class SceneMap extends Scene_Map {
    constructor() {
      super();
    }
    initialize() {
      _Scene_Map_initialize.call(this);
    }
    onMapLoaded() {
      _Scene_Map_onMapLoaded.call(this);
    }
    start() {
      _Scene_Map_start.call(this);
    }
  }

  SceneMap.__name__ = true;
  class core_Collider extends Rectangle {
    constructor(x, y, width, height) {
      super(x, y, width, height);
    }
  }

  core_Collider.__name__ = true;
  class Scriptable extends PIXI.utils.EventEmitter {
    constructor() {
      super();
    }
    initialize() {
      this.emit("init");
    }
    update(deltaTime) {
      this.emit("update");
    }
    destroy() {
      this.emit("destroy");
    }
  }

  Scriptable.__name__ = true;
  class entity_Node2D extends Scriptable {
    constructor(posX, posY) {
      super();
      this.pos = { x: 0, y: 0 };
      this.pos.x = posX;
      this.pos.y = posY;
    }
  }

  entity_Node2D.__name__ = true;
  class entity_Bullet extends entity_Node2D {
    constructor(posX, posY, bulletImage) {
      super(posX, posY);
      this.bulletImage = bulletImage;
      this.initialize();
    }
    initialize() {
      super.initialize();
      this.speed = 400;
      this.dir = { x: 0, y: 0 };
      let _gthis = this;
      this.bulletImage.addLoadListener(function (bitmap) {
        _gthis.sprite = new Sprite(bitmap);
        _gthis.collider = new core_Collider(
          _gthis.pos.x,
          _gthis.pos.y,
          bitmap.width,
          bitmap.height
        );
      });
    }
    fire(direction) {
      this.dir.x = direction.x;
      this.dir.y = direction.y;
    }
    update(deltaTime) {
      super.update(deltaTime);
      this.processMovement(deltaTime);
      this.processSprite();
      this.processDeletion();
    }
    processMovement(deltaTime) {
      let xMove = this.dir.x * this.speed * deltaTime;
      let yMove = this.dir.y * this.speed * deltaTime;
      let pos = this.pos;
      pos.x += xMove;
      pos.y += yMove;
    }
    processSprite() {
      this.sprite.x = this.pos.x;
      this.sprite.y = this.pos.y;
    }
    processDeletion() {
      if (
        this.pos.x < 0 ||
        this.collider.width + this.pos.x > Graphics.boxWidth
      ) {
        this.destroy();
      }
      if (
        this.pos.y < 0 ||
        this.collider.height + this.pos.y > Graphics.boxHeight
      ) {
        this.destroy();
      }
    }
    destroy() {
      super.destroy();
      this.sprite.visible = false;
    }
  }

  entity_Bullet.__name__ = true;
  class entity_Player extends entity_Node2D {
    constructor(posX, posY, characterData, playerImage) {
      super(posX, posY);
      this.player = characterData;
      this.playerImg = playerImage;
      this.initialize();
    }
    initialize() {
      super.initialize();
      this.bulletList = [];
      this.speed = 400;
      this.dir = { x: 0, y: 0 };
      let _gthis = this;
      this.playerImg.addLoadListener(function (bitmap) {
        _gthis.sprite = new Sprite(bitmap);
        _gthis.collider = new core_Collider(
          _gthis.pos.x,
          _gthis.pos.y,
          bitmap.width,
          bitmap.height
        );
        _gthis.hpGauge = new spr_SpriteGauge(0, 0, bitmap.width, 12);
        _gthis.sprite.addChild(_gthis.hpGauge);
      });
    }
    update(deltaTime) {
      super.update(deltaTime);
      let char = this.player;
      this.hpGauge.updateGauge(char.hp / char.maxHp);
      Lambda.iter(this.bulletList, function (bullet) {
        bullet.update(deltaTime);
        if (bullet.sprite.visible == false) {
          let scene = SceneManager._scene;
          scene.removeChild(bullet.sprite);
          bullet = null;
        }
      });
      this.processFiring();
      this.processMovement(deltaTime);
      this.processBoundingBox();
      this.processCollider();
      this.processSprite();
    }
    processFiring() {
      if (Input.isTriggered("ok")) {
        let bulletImg = new Bitmap(4, 4);
        bulletImg.fillRect(0, 0, 4, 4, "white");
        let bullet = new entity_Bullet(this.pos.x, this.pos.y - 12, bulletImg);
        let scene = SceneManager._scene;
        scene.addChild(bullet.sprite);
        this.bulletList.push(bullet);
        bullet.fire({ x: 0, y: -1 });
      }
    }
    processMovement(deltaTime) {
      this.dir.x = 0;
      this.dir.y = 0;
      if (Input.isPressed("right")) {
        this.dir.x = 1;
      }
      if (Input.isPressed("left")) {
        this.dir.x = -1;
      }
      if (Input.isPressed("down")) {
        this.dir.y = 1;
      }
      if (Input.isPressed("up")) {
        this.dir.y = -1;
      }
      let xMove = this.dir.x * this.speed * deltaTime;
      let yMove = this.dir.y * this.speed * deltaTime;
      let pos = this.pos;
      pos.x += xMove;
      pos.y += yMove;
    }
    processBoundingBox() {
      this.pos.x = Math.min(
        Math.max(this.pos.x, 0),
        Graphics.boxWidth - this.collider.width
      );
      this.pos.y = Math.min(
        Math.max(this.pos.y, 0),
        Graphics.boxHeight - this.collider.height
      );
    }
    processCollider() {
      this.collider.x = this.pos.x;
      this.collider.y = this.pos.y;
    }
    processSprite() {
      this.sprite.x = this.pos.x;
      this.sprite.y = this.pos.y;
    }
    destroy() {
      super.destroy();
      this.sprite.visible = false;
    }
  }

  entity_Player.__name__ = true;
  class haxe_iterators_ArrayIterator {
    constructor(array) {
      this.current = 0;
      this.array = array;
    }
    hasNext() {
      return this.current < this.array.length;
    }
    next() {
      return this.array[this.current++];
    }
  }

  haxe_iterators_ArrayIterator.__name__ = true;
  class js_Boot {
    static __string_rec(o, s) {
      if (o == null) {
        return "null";
      }
      if (s.length >= 5) {
        return "<...>";
      }
      let t = typeof o;
      if (t == "function" && (o.__name__ || o.__ename__)) {
        t = "object";
      }
      switch (t) {
        case "function":
          return "<function>";
        case "object":
          if (o.__enum__) {
            let e = $hxEnums[o.__enum__];
            let n = e.__constructs__[o._hx_index];
            let con = e[n];
            if (con.__params__) {
              s = s + "\t";
              return (
                n +
                "(" +
                (function ($this) {
                  var $r;
                  let _g = [];
                  {
                    let _g1 = 0;
                    let _g2 = con.__params__;
                    while (true) {
                      if (!(_g1 < _g2.length)) {
                        break;
                      }
                      let p = _g2[_g1];
                      _g1 = _g1 + 1;
                      _g.push(js_Boot.__string_rec(o[p], s));
                    }
                  }
                  $r = _g;
                  return $r;
                })(this).join(",") +
                ")"
              );
            } else {
              return n;
            }
          }
          if (o instanceof Array) {
            let str = "[";
            s += "\t";
            let _g = 0;
            let _g1 = o.length;
            while (_g < _g1) {
              let i = _g++;
              str += (i > 0 ? "," : "") + js_Boot.__string_rec(o[i], s);
            }
            str += "]";
            return str;
          }
          let tostr;
          try {
            tostr = o.toString;
          } catch (_g) {
            return "???";
          }
          if (
            tostr != null &&
            tostr != Object.toString &&
            typeof tostr == "function"
          ) {
            let s2 = o.toString();
            if (s2 != "[object Object]") {
              return s2;
            }
          }
          let str = "{\n";
          s += "\t";
          let hasp = o.hasOwnProperty != null;
          let k = null;
          for (k in o) {
            if (hasp && !o.hasOwnProperty(k)) {
              continue;
            }
            if (
              k == "prototype" ||
              k == "__class__" ||
              k == "__super__" ||
              k == "__interfaces__" ||
              k == "__properties__"
            ) {
              continue;
            }
            if (str.length != 2) {
              str += ", \n";
            }
            str += s + k + " : " + js_Boot.__string_rec(o[k], s);
          }
          s = s.substring(1);
          str += "\n" + s + "}";
          return str;
        case "string":
          return o;
        default:
          return String(o);
      }
    }
  }

  js_Boot.__name__ = true;

  class SceneShooter extends Scene_Base {
    constructor() {
      super();
    }
    initialize() {
      super.initialize();
      this.timeStamp = SceneShooter.performance.now();
      this.scriptables = [];
      this.createScriptables();
    }
    createScriptables() {
      this.createPlayer();
      this.createEnemies();
    }
    createPlayer() {
      let playerData = {
        atk: 3,
        def: 3,
        hp: 100,
        maxHp: 100,
        isPlayer: true,
        name: "Koizumi",
      };
      let playerImage = new Bitmap(100, 100);
      playerImage.fillRect(0, 0, 100, 100, "white");
      let player = new entity_Player(100, 100, playerData, playerImage);
      this.addChild(player.sprite);
      this.scriptables.push(player);
    }
    createEnemies() {}
    create() {
      super.create();
      this.createBackground();
      this.createWindowLayer();
      this.createAllWindows();
    }
    createBackground() {
      this.backgroundSprite = new Sprite();
      let bitmap = ImageManager.loadPicture(
        LunaShooter.Params.backgroundPicture
      );
      let _gthis = this;
      bitmap.addLoadListener(function (bitmap) {
        _gthis.backgroundSprite.bitmap = bitmap;
        _gthis.addChildAt(_gthis.backgroundSprite, 0);
      });
    }
    createAllWindows() {
      this.createBossWindow();
    }
    createBossWindow() {
      this.bossWindow = new win_WindowBoss(0, 0, Graphics.boxWidth, 75);
      this.addWindow(this.bossWindow);
      this.bossWindow.hide();
    }
    update() {
      this.deltaTime = (SceneShooter.performance.now() - this.timeStamp) / 1000;
      super.update();
      this.updateScriptables();
      this.timeStamp = SceneShooter.performance.now();
    }
    updateScriptables() {
      let _gthis = this;
      Lambda.iter(this.scriptables, function (scriptable) {
        scriptable.update(_gthis.deltaTime);
      });
    }
    updateBossWindow() {}
  }

  $hx_exports["SceneShooter"] = SceneShooter;
  SceneShooter.__name__ = true;
  class spr_SpriteGauge extends Sprite {
    constructor(x, y, width, height) {
      super();
      let bitmap = new Bitmap(width, height);
      this.bitmap = bitmap;
      this.x = x;
      this.y = y;
      this.width = width;
      this.height = height;
    }
    update() {
      super.update();
    }
    updateGauge(hpRate) {
      this.paintGauge(hpRate);
    }
    paintGauge(rate) {
      let contents = this.bitmap;
      let fillW = Math.floor(this.width * rate);
      contents.fillRect(this.x, 0, this.width, this.height, "black");
      contents.gradientFillRect(
        this.x,
        0,
        fillW,
        this.height,
        LunaShooter.Params.hpColor,
        LunaShooter.Params.hpColor
      );
    }
  }

  spr_SpriteGauge.__name__ = true;
  class win_WindowBoss extends Window_Base {
    constructor(x, y, width, height) {
      let rect = new Rectangle(x, y, width, height);
      super(rect);
    }
  }

  win_WindowBoss.__name__ = true;
  function $getIterator(o) {
    if (o instanceof Array) return new haxe_iterators_ArrayIterator(o);
    else return o.iterator();
  }
  String.__name__ = true;
  Array.__name__ = true;
  js_Boot.__toStr = {}.toString;
  LunaShooter.listener = new PIXI.utils.EventEmitter();
  SceneShooter.performance = window.performance;
  LunaShooter.main();
})(
  typeof exports != "undefined"
    ? exports
    : typeof window != "undefined"
    ? window
    : typeof self != "undefined"
    ? self
    : this,
  {}
);

//# sourceMappingURL=Luna_Shooter.js.map
