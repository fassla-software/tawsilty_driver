import 'dart:async';
import 'package:get/get.dart';

class OtpTimeCountController extends GetxController implements GetxService {
  int min = 0, sec = 0;
  double remainingPercent = 0;
  int currentState = 0;
  int duration = 120;
  Timer? _animationTimer;
  int totalTimeSecond = 363;

  void startCountingState() {
    _animationTimer?.cancel();
    _animationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      totalTimeSecond--;
      if (totalTimeSecond > 0) {
        if (duration >= 0) {
          if (duration >= 60) {
            min = ((duration % 3600) / 60).floor();
          }else{
            min = 0;
          }
          sec = (duration % 60);
        } else {
          currentState = 1;
          duration = 240;
        }
        duration--;
        update();
      } else {
        _animationTimer?.cancel();
        min = 0;
        sec = 0;
        update();
      }
    });
  }

  void initialCounter(){
   min = 0; sec = 0;
   remainingPercent = 0;
   currentState = 0;
   duration = 120;
   _animationTimer?.cancel();
   totalTimeSecond = 363;
   update();
  }

  void resumeCountingTime(int oldTime){
    totalTimeSecond = 363 - oldTime;
    if(totalTimeSecond > 360){
      totalTimeSecond = 0;
      currentState = 1;
      update();
    }else if(totalTimeSecond<= 360 && totalTimeSecond >240){
      currentState = 0;
      duration = totalTimeSecond - 240;
    }else{
      currentState = 1;
      duration = totalTimeSecond;
    }
    startCountingState();
  }

}
