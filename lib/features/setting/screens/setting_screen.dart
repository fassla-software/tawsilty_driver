import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/localization/language_model.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/setting/controllers/setting_controller.dart';
import 'package:ride_sharing_user_app/features/setting/widgets/theme_change_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'setting'.tr, regularAppbar: true),
      body: GetBuilder<SettingController>(builder: (settingController) {
        return Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,
              vertical: Dimensions.paddingSize,
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Image.asset(Images.languageIcon,scale: 2),

                const SizedBox(width: Dimensions.paddingSizeLarge),
                Text('language'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
              ]),

              GetBuilder<LocalizationController>(builder: (localizationController){
                return DropdownButton<Locale>(
                  isDense: true,
                  style: textMedium.copyWith(color: Theme.of(context).primaryColor),
                  value: localizationController.locale,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down_sharp),
                  elevation: 1,
                  selectedItemBuilder: (context) {
                    return AppConstants.languages.map<Widget>((LanguageModel language) {
                      return Center(child: Text(
                        language.languageName,
                        style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                      ));
                    }).toList();
                  },
                  items:AppConstants.languages.map((LanguageModel language) {
                    return DropdownMenuItem<Locale>(
                      value: Locale(language.languageCode, language.countryCode),
                      child: Text(language.languageName.tr, style: textRegular.copyWith(
                        color: localizationController.locale.languageCode == language.languageCode
                            ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium!.color,
                      )),
                    );
                  }).toList(),
                  onChanged: (Locale? newValue) {
                    Get.find<LocalizationController>().setLanguage(newValue!);
                  },
                );
              })
            ]),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Row(children: [
              SizedBox(width: Dimensions.iconSizeMedium, child: Image.asset(Images.themeIcon)),

              SizedBox(width: Get.find<LocalizationController>().isLtr? 0: Dimensions.paddingSizeSmall),
              Padding(padding:  const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                child: Text('theme'.tr),
              )
            ]),
          ),

          const ThemeChangeWidget(),

        ]);
      }),
    );
  }
}
