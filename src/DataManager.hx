import rm.managers.DataManager as RMDataManager;

@:native('DMManager')
class DataManager extends RMDataManager {
  public function makeSaveContents(): Dynamic {
    var contents ={};
    untyped contents = _DataManager_makeSaveContents.call(this);
    untyped contents.allMapContacts ={};
    return contents;
  }

  public function extractSaveContents(contents: Dynamic) {
    untyped _DataManager_extractSaveContents.call(this);
  }
}
