/** ============================================================================
 *
 *  Luna_ShooterMV.js
 * 
 *  Build Date: 12/13/2020
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


@param debugCollider
@text Debug Collider
@desc Shows the colliders in the game when turned on.
@default true

@param hpColor
@text  Hp Color
@desc The color of the HP gauges(css color)
@default B33951 

@param damageFlashTime
@text Damage Flash Time
@desc The time enemies and players flash when taking damage(seconds)
@default 2.0

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
  class HxOverrides {
    static remove(a, obj) {
      let i = a.indexOf(obj);
      if (i == -1) {
        return false;
      }
      a.splice(i, 1);
      return true;
    }
    static now() {
      return Date.now();
    }
  }

  HxOverrides.__name__ = true;
  class Lambda {
    static iter(it, f) {
      let x = $getIterator(it);
      while (x.hasNext()) {
        let x1 = x.next();
        f(x1);
      }
    }
    static findIndex(it, f) {
      let i = 0;
      let v = $getIterator(it);
      while (v.hasNext()) {
        let v1 = v.next();
        if (f(v1)) {
          return i;
        }
        ++i;
      }
      return -1;
    }
  }

  Lambda.__name__ = true;
  class systems_CollisionSystem {
    static initialize() {
      systems_CollisionSystem.colliderIds.length = 100;
      Lambda.iter(systems_CollisionSystem.colliderIds, function (el) {});
    }
    static generateId() {
      let id = Lambda.findIndex(
        systems_CollisionSystem.colliderIds,
        function (el) {
          return el == null;
        }
      );
      if (id == -1) {
        systems_CollisionSystem.colliderIds.push(
          systems_CollisionSystem.colliderIds.length + 1
        );
        id = systems_CollisionSystem.colliderIds.length + 1;
      } else {
        systems_CollisionSystem.colliderIds[id] = id;
      }
      return id;
    }
    static addCollider(collider) {
      systems_CollisionSystem.colliders.push(collider);
      collider.id = systems_CollisionSystem.generateId();
    }
    static removeCollider(collider) {
      systems_CollisionSystem.colliderIds[collider.id] = null;
      collider.id = null;
      HxOverrides.remove(systems_CollisionSystem.colliders, collider);
    }
    static update() {
      Lambda.iter(systems_CollisionSystem.colliders, function (collider) {
        let _this = systems_CollisionSystem.colliders;
        let _g = [];
        let _g1 = 0;
        while (_g1 < _this.length) {
          let v = _this[_g1];
          ++_g1;
          if (collider.isCollided(v) && collider.id != v.id) {
            _g.push(v);
          }
        }
        let _g2 = 0;
        while (_g2 < _g.length) {
          let collision = _g[_g2];
          ++_g2;
          collider.addCollision(collision);
        }
      });
    }
  }

  systems_CollisionSystem.__name__ = true;
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
      let tmp = params["debugCollider"].toLowerCase() == "true";
      LunaShooter.Params = {
        backgroundPicture: params["backgroundPicture"],
        debugCollider: tmp,
        hpColor: params["hpColor"],
        damageFlashTime: parseFloat(params["damageFlashTime"]),
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
      SceneManager.push(LunaSceneShooter);
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
  class Anim extends PIXI.utils.EventEmitter {
    constructor(sprite, animFn) {
      super();
      this.sprite = sprite;
      this.animFn = animFn;
    }
    start() {
      this.isStarted = true;
      this.emit("start", this);
    }
    stop() {
      this.isStarted = false;
      this.emit("stop", this);
    }
    update(deltaTime) {
      this.animFn(this.sprite, deltaTime);
    }
  }

  Anim.__name__ = true;
  class core_Collider extends Rectangle {
    constructor(layer, x, y, width, height) {
      super(x, y, width, height);
      this.layer = layer;
      this.isOn = true;
      this.collisions = [];
    }
    isCollided(collider) {
      let topLeft_x = this.x;
      let topLeft_y = this.y;
      let bottomLeft_x = this.x;
      let bottomLeft_y = this.y + this.height;
      let topRight_x = this.x + this.width;
      let topRight_y = this.x;
      let bottomRight_x = this.x + this.width;
      let bottomRight_y = this.y + this.height;
      if (
        !(
          collider.contains(topLeft_x, topLeft_y) ||
          collider.contains(bottomLeft_x, bottomLeft_y) ||
          collider.contains(topRight_x, topRight_y)
        )
      ) {
        return collider.contains(bottomRight_x, bottomRight_y);
      } else {
        return true;
      }
    }
    addCollision(collision) {
      this.collisions.push(collision);
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
      this.pos = { x: posX, y: posY };
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
      this.speed = 200;
      this.dir = { x: 0, y: 0 };
      let _gthis = this;
      this.bulletImage.addLoadListener(function (bitmap) {
        _gthis.sprite = new Sprite(bitmap);
        _gthis.sprite.x = _gthis.pos.x;
        _gthis.sprite.y = _gthis.pos.y;
        _gthis.collider = new core_Collider(
          "bullet",
          _gthis.pos.x,
          _gthis.pos.y,
          bitmap.width,
          bitmap.height
        );
        systems_CollisionSystem.addCollider(_gthis.collider);
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
      this.processCollider();
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
    processCollider() {
      this.collider.x = this.pos.x;
      this.collider.y = this.pos.y;
    }
    destroy() {
      super.destroy();
      systems_CollisionSystem.removeCollider(this.collider);
      this.sprite.visible = false;
    }
  }

  entity_Bullet.__name__ = true;
  class entity_Character extends entity_Node2D {
    constructor(posX, posY) {
      super(posX, posY);
    }
    initialize() {
      this.damageAnimTime = 0;
    }
    takeDamage() {
      this.damageAnimTime = LunaShooter.Params.damageFlashTime;
      this.damageAnim.start();
    }
    update(deltaTime) {
      super.update(deltaTime);
      if (this.damageAnim != null && this.damageAnim.isStarted) {
        this.processDamage(deltaTime);
      }
    }
    processDamage(deltaTime) {
      if (this.damageAnimTime > 0) {
        this.damageAnim.update(deltaTime);
        this.damageAnimTime -= deltaTime;
      } else {
        this.damageAnim.stop();
      }
    }
  }

  entity_Character.__name__ = true;
  class entity_Player extends entity_Character {
    constructor(posX, posY, characterData, playerImage) {
      super(posX, posY);
      this.player = characterData;
      this.playerImg = playerImage;
      this.playerCoordTrail = [];
      this.initialize();
    }
    initialize() {
      super.initialize();
      this.bulletList = [];
      this.initialBoostCD = 2.5;
      this.boostCD = 2.5;
      this.boostFactor = 0.125;
      this.initialSpeed = 400;
      this.speed = 400;
      this.dir = { x: 0, y: 0 };
      let _gthis = this;
      this.playerImg.addLoadListener(function (bitmap) {
        _gthis.sprite = new Sprite(bitmap);
        _gthis.collider = new core_Collider(
          "player",
          _gthis.pos.x,
          _gthis.pos.y,
          bitmap.width,
          bitmap.height
        );
        systems_CollisionSystem.addCollider(_gthis.collider);
        _gthis.hpGauge = new spr_SpriteGauge(0, 0, bitmap.width, 12);
        _gthis.sprite.addChild(_gthis.hpGauge);
      });
      this.damageAnim = new Anim(this.sprite, function (sprite, dt) {
        if (Graphics.frameCount % 30 == 0) {
          _gthis.sprite.visible = true;
        } else if (Graphics.frameCount % 15 == 0) {
          _gthis.sprite.visible = false;
        }
      });
      this.damageAnim.on("stop", function (anim) {
        _gthis.sprite.visible = true;
      });
    }
    update(deltaTime) {
      super.update(deltaTime);
      this.processHp();
      this.processBullets(deltaTime);
      this.processFiring();
      this.processMovement(deltaTime);
      this.processBoosting(deltaTime);
      this.processCoordTrail();
      this.processBoundingBox();
      this.processCollider();
      this.processSprite();
    }
    processHp() {
      let char = this.player;
      this.hpGauge.updateGauge(char.hp / char.maxHp);
    }
    processBullets(deltaTime) {
      let _this = this.bulletList;
      let _g = [];
      let _g1 = 0;
      while (_g1 < _this.length) {
        let v = _this[_g1];
        ++_g1;
        if (v.sprite.visible) {
          _g.push(v);
        }
      }
      this.bulletList = _g;
      Lambda.iter(this.bulletList, function (bullet) {
        bullet.update(deltaTime);
        if (bullet.sprite.visible == false) {
          let scene = SceneManager._scene;
          scene.removeChild(bullet.sprite);
          bullet = null;
        }
      });
    }
    processCoordTrail() {
      let currentPos = { x: this.pos.x, y: this.pos.y };
      this.playerCoordTrail.push(currentPos);
      if (this.playerCoordTrail.length > 70) {
        this.playerCoordTrail.shift();
      }
    }
    processFiring() {
      if (Input.isTriggered("ok")) {
        let bulletImg = new Bitmap(12, 12);
        bulletImg.fillRect(0, 0, 12, 12, "white");
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
      if (Input.isPressed("shift")) {
        this.boosting = true;
      }
      let xMove = this.dir.x * this.speed * deltaTime;
      let yMove = this.dir.y * this.speed * deltaTime;
      let pos = this.pos;
      pos.x += xMove;
      pos.y += yMove;
    }
    processBoosting(deltaTime) {
      if (this.boosting && this.boostCD > 0) {
        this.speed =
          this.initialSpeed *
          (this.boostFactor * (this.boostCD / this.initialBoostCD));
        this.boostCD -= deltaTime;
      } else {
        this.boostCD = this.initialBoostCD;
        this.boosting = false;
      }
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
  class entity_SpiralSpawner extends entity_Node2D {
    constructor(scene, posX, posY) {
      super(posX, posY);
      this.scene = scene;
      this.spawnPoint = { x: this.pos.x + 10, y: this.pos.y + 10 };
      this.shootDirection = { x: 1, y: 1 };
      this.shootRotation = 0;
      this.bulletList = [];
    }
    start() {
      this.isStarted = true;
    }
    update(deltaTime) {
      if (this.isStarted) {
        this.spawnBullet();
        this.processBullets(deltaTime);
      }
    }
    spawnBullet() {
      let bulletImg = new Bitmap(12, 12);
      bulletImg.fillRect(0, 0, 12, 12, "white");
      let bullet = new entity_Bullet(
        this.spawnPoint.x,
        this.spawnPoint.y,
        bulletImg
      );
      bullet.speed = 200;
      this.shootRotation += 15;
      this.scene.addChild(bullet.sprite);
      this.bulletList.push(bullet);
      bullet.fire({
        x: Math.cos((this.shootRotation * Math.PI) / 180),
        y: Math.sin((this.shootRotation * Math.PI) / 180),
      });
    }
    processBullets(deltaTime) {
      let _gthis = this;
      let _this = this.bulletList;
      let _g = [];
      let _g1 = 0;
      while (_g1 < _this.length) {
        let v = _this[_g1];
        ++_g1;
        if (v.sprite.visible) {
          _g.push(v);
        }
      }
      this.bulletList = _g;
      Lambda.iter(this.bulletList, function (bullet) {
        bullet.update(deltaTime);
        if (bullet.sprite.visible == false) {
          _gthis.scene.removeChild(bullet.sprite);
          bullet = null;
        }
      });
    }
  }

  entity_SpiralSpawner.__name__ = true;
  class ext_BitmapExt {
    static lineTo(bitmap, strokeStyle, x1, y1, x2, y2) {
      let context = bitmap.context;
      context.beginPath();
      context.moveTo(x1, y1);
      context.lineTo(x2, y2);
      context.strokeStyle = strokeStyle;
      context.stroke();
      bitmap._setDirty();
    }
  }

  ext_BitmapExt.__name__ = true;
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

  class LunaScenePause extends Scene_MenuBase {
    constructor() {
      super();
    }
    create() {
      this.createAllWindows();
    }
    createAllWindows() {
      this.createTitle();
      this.createPauseWindow();
      this.createConfirmWindow();
    }
    createTitle() {
      this.pauseTitleWindow = new LNSWindowTitle(0, 70, 125, 75);
      this.addWindow(this.pauseTitleWindow);
    }
    createPauseWindow() {
      let xPosition = Graphics.boxWidth / 2;
      this.pauseMenuWindow = new WindowPauseMenu(xPosition, 120, 150, 250);
      this.pauseMenuWindow.setHandler(
        "resume",
        $bind(this, this.resumeHandler)
      );
      this.pauseMenuWindow.setHandler("retry", $bind(this, this.retryHandler));
      this.pauseMenuWindow.setHandler(
        "returnToTitle",
        $bind(this, this.returnToTitleHandler)
      );
      this.pauseMenuWindow.activate();
      this.addWindow(this.pauseMenuWindow);
    }
    createConfirmWindow() {
      let win = this.pauseMenuWindow;
      this.pauseConfirmWindow = new LNWindowConfirmMenu(win.x, win.y, 150, 75);
      this.pauseConfirmWindow.setHandler("yes", $bind(this, this.yesHandler));
      this.pauseConfirmWindow.setHandler("no", $bind(this, this.noHandler));
      this.pauseConfirmWindow.close();
      this.addWindow(this.pauseConfirmWindow);
    }
    update() {
      super.update();
    }
    resumeHandler() {
      this.popScene();
    }
    retryHandler() {
      SceneManager.goto(LunaSceneShooter);
    }
    returnToTitleHandler() {
      this.pauseConfirmWindow.open();
      this.pauseConfirmWindow.activate();
    }
    yesHandler() {
      SceneManager.goto(Scene_Title);
    }
    noHandler() {
      this.pauseConfirmWindow.close();
      this.pauseConfirmWindow.deactivate();
    }
  }

  $hx_exports["LunaScenePause"] = LunaScenePause;
  LunaScenePause.__name__ = true;
  class LunaSceneShooter extends Scene_Base {
    constructor() {
      super();
    }
    initialize() {
      super.initialize();
      this.timeStamp = LunaSceneShooter.performance.now();
      this.scriptables = [];
      systems_CollisionSystem.initialize();
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
      this.player = player;
      this.addChild(player.sprite);
      this.scriptables.push(player);
    }
    createEnemies() {
      let spawner = new entity_SpiralSpawner(this, 300, 300);
      this.spawner = spawner;
      spawner.start();
    }
    create() {
      super.create();
      this.createBackground();
      this.createParallax();
      this.createWindowLayer();
      this.createAllWindows();
      if (LunaShooter.Params.debugCollider) {
        this.createColliderDebugSprite();
        this.createScreenSprite();
      }
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
    createParallax() {
      let forestParallax = ImageManager.loadPicture("Forest", 0);
      let _gthis = this;
      forestParallax.addLoadListener(function (bitmap) {
        _gthis.backgroundParallax1 = new TilingSprite(bitmap);
        _gthis.backgroundParallax1.move(0, 0, bitmap.width, bitmap.height);
        console.log(
          "src/scene/SceneShooter.hx:98:",
          _gthis.backgroundParallax1
        );
        console.log("src/scene/SceneShooter.hx:99:", "add parallax");
        _gthis.addChildAt(_gthis.backgroundParallax1, 1);
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
    createColliderDebugSprite() {
      this.colliderDebugSprite = new Sprite();
      this.colliderDebugSprite.bitmap = new Bitmap(
        Graphics.boxWidth,
        Graphics.boxHeight
      );
      this.addChild(this.colliderDebugSprite);
    }
    createScreenSprite() {
      this.screenSprite = new Sprite();
      this.screenSprite.bitmap = new Bitmap(
        Graphics.boxWidth,
        Graphics.boxHeight
      );
      this.addChild(this.screenSprite);
    }
    update() {
      this.deltaTime =
        (LunaSceneShooter.performance.now() - this.timeStamp) / 1000;
      super.update();
      this.processScenePause();
      this.updateScriptables();
      this.updateParallax();
      this.updateBossWindow();
      systems_CollisionSystem.update();
      this.spawner.update(this.deltaTime);
      this.timeStamp = LunaSceneShooter.performance.now();
      this.paint();
    }
    processScenePause() {
      if (Input.isTriggered("menu") || TouchInput.isCancelled()) {
        SceneManager.push(LunaScenePause);
      }
    }
    updateScriptables() {
      let _gthis = this;
      Lambda.iter(this.scriptables, function (scriptable) {
        scriptable.update(_gthis.deltaTime);
      });
    }
    updateParallax() {
      if (this.backgroundParallax1 != null) {
        this.backgroundParallax1.origin.x -= 0.64;
      }
    }
    updateBossWindow() {}
    paint() {
      if (LunaShooter.Params.debugCollider) {
        this.paintColliders();
      }
      this.paintPlayerTrail();
    }
    paintPlayerTrail() {
      let bitmap = this.screenSprite.bitmap;
      bitmap.clear();
      let coords = this.player.playerCoordTrail;
      if (coords.length > 2) {
        let _g = 1;
        let _g1 = coords.length;
        while (_g < _g1) {
          let index = _g++;
          let start = coords[index - 1];
          let end = coords[index];
          ext_BitmapExt.lineTo(bitmap, "red", start.x, start.y, end.x, end.y);
        }
      }
    }
    paintColliders() {
      let colliders = systems_CollisionSystem.colliders;
      let bitmap = this.colliderDebugSprite.bitmap;
      bitmap.clear();
      Lambda.iter(colliders, function (collider) {
        if (collider.isOn) {
          bitmap.fillRect(
            collider.x,
            collider.y,
            collider.width,
            collider.height,
            "red"
          );
        } else {
          bitmap.fillRect(
            collider.x,
            collider.y,
            collider.width,
            collider.height,
            "blue"
          );
        }
        bitmap.clearRect(
          collider.x + 2,
          collider.y + 2,
          collider.width - 4,
          collider.height - 4
        );
      });
    }
  }

  $hx_exports["LunaSceneShooter"] = LunaSceneShooter;
  LunaSceneShooter.__name__ = true;
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
      super(x, y, width, height);
    }
  }

  win_WindowBoss.__name__ = true;
  class LNWindowConfirmMenu extends Window_HorzCommand {
    constructor(x, y, width, height) {
      super(x, y);
    }
    makeCommandList() {
      this.addCommand("Yes", "yes", true);
      this.addCommand("No", "no", true);
    }
  }

  LNWindowConfirmMenu.__name__ = true;
  class WindowPauseMenu extends Window_Command {
    constructor(x, y, width, height) {
      super(x, y);
    }
    makeCommandList() {
      super.makeCommandList();
      this.addCommand("Resume", "resume", true);
      this.addCommand("Return To Title", "returnToTitle", true);
    }
  }

  WindowPauseMenu.__name__ = true;
  class LNSWindowTitle extends Window_Base {
    constructor(x, y, width, height) {
      super(x, y, width, height);
    }
  }

  LNSWindowTitle.__name__ = true;
  function $getIterator(o) {
    if (o instanceof Array) return new haxe_iterators_ArrayIterator(o);
    else return o.iterator();
  }
  var $_;
  function $bind(o, m) {
    if (m == null) return null;
    if (m.__id__ == null) m.__id__ = $global.$haxeUID++;
    var f;
    if (o.hx__closures__ == null) o.hx__closures__ = {};
    else f = o.hx__closures__[m.__id__];
    if (f == null) {
      f = m.bind(o);
      o.hx__closures__[m.__id__] = f;
    }
    return f;
  }
  $global.$haxeUID |= 0;
  if (
    typeof performance != "undefined"
      ? typeof performance.now == "function"
      : false
  ) {
    HxOverrides.now = performance.now.bind(performance);
  }
  String.__name__ = true;
  Array.__name__ = true;
  js_Boot.__toStr = {}.toString;
  systems_CollisionSystem.colliders = [];
  systems_CollisionSystem.colliderIds = [];
  LunaShooter.listener = new PIXI.utils.EventEmitter();
  LunaShooter.collisionSys = systems_CollisionSystem;
  LunaSceneShooter.performance = window.performance;
  LunaShooter.main();
})(
  typeof exports != "undefined"
    ? exports
    : typeof window != "undefined"
    ? window
    : typeof self != "undefined"
    ? self
    : this,
  typeof window != "undefined"
    ? window
    : typeof global != "undefined"
    ? global
    : typeof self != "undefined"
    ? self
    : this
);

//# sourceMappingURL=Luna_ShooterMV.js.map
