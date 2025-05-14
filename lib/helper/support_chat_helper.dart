import 'package:intl/intl.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';

class SupportChatHelper{
  static List<String> days = ['','MON','TUE','WED','THU','FRI','SAT','SUN'];

  static String chatTimeCalculation(String dateTime){
    DateTime messageTime = DateFormat('yyyy-MM-dd').parse(dateTime,false).toLocal();
    int daysDifference = DateTime.now().difference(messageTime).inDays;
    if(daysDifference > 7){
      return DateConverter.isoStringToDateTimeString(dateTime);
    }else{
      return '${days[messageTime.weekday]} AT ${DateConverter.isoDateTimeStringToLocalTime(dateTime)}';
    }
  }


  static bool isMessageSameDate(String dateTime1, String? dateTIme2){
    if(dateTIme2 != null){
      DateTime messageTime = DateFormat('yyyy-MM-dd').parse(dateTime1,false).toLocal();
      DateTime preMessageTime = DateFormat('yyyy-MM-dd').parse(dateTIme2,false).toLocal();
      return messageTime == preMessageTime;
    }else{
      return true;
    }
  }

}