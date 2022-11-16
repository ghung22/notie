import 'package:mobx/mobx.dart';
import 'package:notie/data/shared_pref/shared_pref.dart';
import 'package:notie/global/debug.dart';
import 'package:notie/global/strings.dart';
import 'package:notie/global/vars.dart';

part 'language_store.g.dart';

class LanguageStore = _LanguageStore with _$LanguageStore;

abstract class _LanguageStore with Store {
  @observable
  Language activeLanguage = Language.system;

  @observable
  bool changingLanguage = false;

  @action
  Future<void> getActiveLanguage() async =>
      activeLanguage = await SharedPref.getLanguage();

  @action
  Future<void> setActiveLanguage(Language language) async {
    changingLanguage = true;
    await Future.delayed(Vars.animationFast);
    if (await SharedPref.setLanguage(language)) {
      activeLanguage = language;
    } else {
      Debug.log(null, 'Failed to set language');
    }
    await Future.delayed(Vars.animationFast);
    changingLanguage = false;
  }
}