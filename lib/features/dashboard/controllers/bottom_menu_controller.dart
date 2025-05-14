import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/common_widgets/confirmation_dialog_widget.dart';


class BottomMenuController extends GetxController implements GetxService{
  int _currentTab = 0;
  int get currentTab => _currentTab;


  resetNavBar(){
    _currentTab = 0;
  }
  void setTabIndex(int index) {
    _currentTab = index;
    update();
  }

  void exitApp() {
    Get.dialog(ConfirmationDialogWidget(
      icon: Images.logOutIcon,
      description: 'do_you_want_to_exit_the_app'.tr,
      onYesPressed:() {
        SystemNavigator.pop();
        exit(0);
      },
    ), barrierDismissible: false);
  }

}
