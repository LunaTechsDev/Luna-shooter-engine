package ext;

class CharacterExt {
  public static inline function hpRate(char: Character) {
    return char.hp / char.maxHp;
  }

  public static inline function isAlive(char: Character) {
    return char.hp > 0;
  }
}
