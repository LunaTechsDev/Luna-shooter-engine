import Types.Contact;
import haxe.DynamicAccess;

class ContactBook {
  public static var areaList: DynamicAccess<Dynamic>;

  public static function initialize() {
    areaList = new DynamicAccess<Dynamic>();
  }

  public static function addContactList(mapId, contactList: Array<Contact>) {
    var contacts = areaList.get(mapId);
    if (contacts != null) {
      areaList[mapId] = contactList;
    }
  }

  public static function getContactById(mapId: Int, contactId: Int) {
    var contacts = getContactList(mapId).filter((currentContact) -> currentContact.id == contactId);
    if (contacts.length > 0) {
      return contacts[0];
    } else {
      return null;
    }
  }

  public static function getContactByName(name: String) {
    var contact = null;
    for (mapId => contactList in areaList) {
      if (contact == null) {
        var list: Array<Contact> = contactList;
        var contacts = list.filter((currentContact) -> currentContact.name.contains(name));
        if (contacts.length > 0) {
          contact = contacts[0];
        }
      }
    }
    return contact;
  }

  public static function getContactList(mapId: Int): Array<Contact> {
    return areaList.get(cast mapId);
  }

  public static function getAreaList(): Array<String> {
    return areaList.keys();
  }
}
