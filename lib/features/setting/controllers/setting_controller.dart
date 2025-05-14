import 'package:get/get.dart';

class SettingController extends GetxController implements GetxService{



  bool rideAssistantStatus = false;
  void toggleRideAssistant(){
    rideAssistantStatus = !rideAssistantStatus;
    update();
}

  bool notificationSoundStatus = false;
  void toggleNotificationSoundStatus(){
    notificationSoundStatus = !notificationSoundStatus;
    update();
  }


}