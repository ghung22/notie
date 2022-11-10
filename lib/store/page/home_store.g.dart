// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStore, Store {
  Computed<List<Note>>? _$notesComputed;

  @override
  List<Note> get notes => (_$notesComputed ??=
          Computed<List<Note>>(() => super.notes, name: '_HomeStore.notes'))
      .value;
  Computed<bool>? _$someSelectedComputed;

  @override
  bool get someSelected =>
      (_$someSelectedComputed ??= Computed<bool>(() => super.someSelected,
              name: '_HomeStore.someSelected'))
          .value;
  Computed<bool>? _$allSelectedComputed;

  @override
  bool get allSelected =>
      (_$allSelectedComputed ??= Computed<bool>(() => super.allSelected,
              name: '_HomeStore.allSelected'))
          .value;

  late final _$pathAtom = Atom(name: '_HomeStore.path', context: context);

  @override
  String get path {
    _$pathAtom.reportRead();
    return super.path;
  }

  @override
  set path(String value) {
    _$pathAtom.reportWrite(value, super.path, () {
      super.path = value;
    });
  }

  late final _$searchQueryAtom =
      Atom(name: '_HomeStore.searchQuery', context: context);

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$sortTypeAtom =
      Atom(name: '_HomeStore.sortType', context: context);

  @override
  SortType get sortType {
    _$sortTypeAtom.reportRead();
    return super.sortType;
  }

  @override
  set sortType(SortType value) {
    _$sortTypeAtom.reportWrite(value, super.sortType, () {
      super.sortType = value;
    });
  }

  late final _$sortOrderAtom =
      Atom(name: '_HomeStore.sortOrder', context: context);

  @override
  SortOrder get sortOrder {
    _$sortOrderAtom.reportRead();
    return super.sortOrder;
  }

  @override
  set sortOrder(SortOrder value) {
    _$sortOrderAtom.reportWrite(value, super.sortOrder, () {
      super.sortOrder = value;
    });
  }

  late final _$selectedNotesAtom =
      Atom(name: '_HomeStore.selectedNotes', context: context);

  @override
  ObservableMap<int, bool> get selectedNotes {
    _$selectedNotesAtom.reportRead();
    return super.selectedNotes;
  }

  @override
  set selectedNotes(ObservableMap<int, bool> value) {
    _$selectedNotesAtom.reportWrite(value, super.selectedNotes, () {
      super.selectedNotes = value;
    });
  }

  late final _$_HomeStoreActionController =
      ActionController(name: '_HomeStore', context: context);

  @override
  void setPath(String path) {
    final _$actionInfo =
        _$_HomeStoreActionController.startAction(name: '_HomeStore.setPath');
    try {
      return super.setPath(path);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void search(String query) {
    final _$actionInfo =
        _$_HomeStoreActionController.startAction(name: '_HomeStore.search');
    try {
      return super.search(query);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sort(SortType sortType) {
    final _$actionInfo =
        _$_HomeStoreActionController.startAction(name: '_HomeStore.sort');
    try {
      return super.sort(sortType);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool isSelected(Note note) {
    final _$actionInfo =
        _$_HomeStoreActionController.startAction(name: '_HomeStore.isSelected');
    try {
      return super.isSelected(note);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateNotes(Notes notes) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.updateNotes');
    try {
      return super.updateNotes(notes);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool? select(Note note) {
    final _$actionInfo =
        _$_HomeStoreActionController.startAction(name: '_HomeStore.select');
    try {
      return super.select(note);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectSome(List<Note> notes) {
    final _$actionInfo =
        _$_HomeStoreActionController.startAction(name: '_HomeStore.selectSome');
    try {
      return super.selectSome(notes);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectAll() {
    final _$actionInfo =
        _$_HomeStoreActionController.startAction(name: '_HomeStore.selectAll');
    try {
      return super.selectAll();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
path: ${path},
searchQuery: ${searchQuery},
sortType: ${sortType},
sortOrder: ${sortOrder},
selectedNotes: ${selectedNotes},
notes: ${notes},
someSelected: ${someSelected},
allSelected: ${allSelected}
    ''';
  }
}
