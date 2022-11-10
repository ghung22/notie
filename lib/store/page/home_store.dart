import 'package:mobx/mobx.dart';
import 'package:notie/data/model/folder.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/global/vars.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  // region observable
  @observable
  String path = FolderPaths.root;

  @observable
  String searchQuery = '';

  @observable
  SortType sortType = SortType.byDefault;

  @observable
  SortOrder sortOrder = SortOrder.descending;

  @observable
  ObservableMap<int, bool> selectedNotes = ObservableMap();

  // endregion

  // region computed

  @computed
  List<Note> get notes {
    var notes = <Note>[];
    switch (sortType) {
      case SortType.byDefault:
        notes = _notes.value;
        break;
      case SortType.byName:
        notes = _notes.byName;
        break;
      case SortType.byColor:
        notes = _notes.byColor;
        break;
      case SortType.byCreateTime:
        notes = _notes.byCreateTime;
        break;
      case SortType.byUpdateTime:
        notes = _notes.byUpdateTime;
        break;
      case SortType.byDeleteTime:
        if (path != FolderPaths.trash) {
          sort(SortType.byDefault);
          notes = _notes.value;
        } else {
          notes = _notes.byDeleteTime;
        }
        break;
    }
    switch (sortOrder) {
      case SortOrder.ascending:
        break;
      case SortOrder.descending:
        notes = notes.reversed.toList();
        break;
    }
    return notes;
  }

  @computed
  bool get someSelected => selectedNotes.values.contains(true);

  @computed
  bool get allSelected =>
      selectedNotes.values.where((e) => e).toList().length !=
      selectedNotes.length;

  // endregion

  // region actions

  @action
  void setPath(String path) => this.path = path;

  @action
  void search(String query) => searchQuery = query;

  @action
  void sort(SortType sortType) => this.sortType = sortType;

  // endregion

  // region Select notes actions

  @action
  bool isSelected(Note note) => selectedNotes[note.createdTimestamp] ?? false;

  @action
  void updateNotes(Notes notes) {
    selectedNotes.clear();
    _notes = notes;
    for (var note in _notes.value) {
      selectedNotes[note.createdTimestamp] = false;
    }
  }

  @action
  bool? select(Note note) {
    final nid = note.createdTimestamp;
    if (selectedNotes[nid] == null) return null;
    selectedNotes[nid] = !selectedNotes[nid]!;
    return selectedNotes[nid];
  }

  @action
  void selectSome(List<Note> notes) {
    for (var note in notes) {
      select(note);
    }
  }

  @action
  void selectAll() {
    final sel = allSelected;
    for (var nid in selectedNotes.keys) {
      selectedNotes[nid] = sel;
    }
  }

  // endregion

  // region Private vars

  Notes _notes = Notes();

// endregion
}