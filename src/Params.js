/*:
@author LunaTechs - Kino
@plugindesc A plugin that adds a social system to RPGMakerMV/MZ <LunaShooter>.

@target MV MZ

@param pauseText
@text Pause Text
@desc The text used for the pause scene
@default Pause

@param debugCollider
@text Debug Collider
@desc Shows the colliders in the game when turned on.
@default true

@param godMode
@text God Mode
@desc Whether the player will die or not in game
@default false

@param playerSpeed
@text Player Speed
@desc Player movement speed
@default 350

@param playerBulletImage
@text Player Bullet Image (Picture Folder)
@desc The player bullet which is loaded from the pictures folder.
@default player_bullet

@param playerBulletSpeed
@text Player Bullet Speed
@desc The speed at which player bullets will fly
@default 400

@param enemySpeed
@text Enemy Speed
@desc The speed for enemy boss
@default 250

@param enemyBulletImage
@text Enemy Bullet Image (Picture Folder)
@desc The bullet image used for enemies on screen
@default enemy_bullet

@param enemyBulletSpeed
@text Enemy Bullet Speed
@desc The speed at which enemy bullets will fly
@default 150

@param hpColor
@text  Hp Color
@desc The color of the HP gauges(css color)
@default #B33951 

@param boostFactor
@text Boost Factor(seconds)
@desc How much of the player speed is used when boosting
@default 0.5

@param boostCD
@text Boost Cooldown(seconds)
@desc The cooldown of the player boost
@default 2.5

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




