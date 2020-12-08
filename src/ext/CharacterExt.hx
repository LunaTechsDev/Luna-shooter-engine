package ext;

class CharacterExt {
  public static inline function hpRate(char: Character) {
    return char.hp / char.maxHp;
  }

  public static inline function isAlive(char: Character) {
    return char.hp > 0;
  }

  public static inline function addHp(char: Character, hp: Int) {
    char.hp += hp;
  }

  public static inline function addAtk(char: Character, atk: Int) {
    char.atk += atk;
  }

  public static inline function addDef(char: Character, def: Int) {
    char.def += def;
  }
}
