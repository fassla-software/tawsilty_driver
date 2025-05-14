import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/localization/language_model.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationController extends GetxController  implements GetxService{
  final SharedPreferences sharedPreferences;

  LocalizationController({required this.sharedPreferences}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[1].languageCode, AppConstants.languages[1].countryCode);
  bool _isLtr = true;
  int _selectIndex = 0;
  List<LanguageModel> _languages = [];

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  int get selectIndex => _selectIndex;
  List<LanguageModel> get languages => _languages;

  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    _isLtr = !intl.Bidi.isRtlLanguage(_locale.languageCode);
    saveLanguage(_locale);
    update();
    Get.find<ApiClient>().updateHeader(sharedPreferences.getString(AppConstants.token)??'', sharedPreferences.getString(AppConstants.languageCode), 'latitude', 'longitude', sharedPreferences.getString(AppConstants.zoneId)??'');
    backendLanguageUpdate();
  }

  void loadCurrentLanguage() async {
    _locale = Locale(sharedPreferences.getString(AppConstants.languageCode) ?? AppConstants.languages[1].languageCode,
        sharedPreferences.getString(AppConstants.countryCode) ?? AppConstants.languages[1].countryCode);
    _isLtr = !intl.Bidi.isRtlLanguage(_locale.languageCode);
    update();
  }

  void saveLanguage(Locale locale) async {
    sharedPreferences.setString(AppConstants.languageCode, locale.languageCode);
    sharedPreferences.setString(AppConstants.countryCode, locale.countryCode!);
  }

  void setSelectIndex(int index) {
    _selectIndex = index;
    update();
  }

  void searchLanguage(String query, BuildContext context) {
    if (query.isEmpty) {
      _languages.clear();
      _languages = AppConstants.languages;
      update();
    } else {
      _selectIndex = -1;
      _languages = [];
      for (LanguageModel language in AppConstants.languages) {
        if (language.languageName.toLowerCase().contains(query.toLowerCase())) {
          _languages.add(language);
        }
      }
      update();
    }
  }

  void initializeAllLanguages(BuildContext context) {
    if (_languages.isEmpty) {
      _languages.clear();
      _languages = AppConstants.languages;
    }
  }

  void backendLanguageUpdate(){
    Get.find<ApiClient>().postData(AppConstants.changeLanguage, {});
  }

}
