import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/leaderboard/domain/models/leaderboard_model.dart';
import 'package:ride_sharing_user_app/features/leaderboard/domain/services/leader_board_service_interface.dart';

class LeaderBoardController extends GetxController implements GetxService{
  final LeaderBoardServiceInterface leaderBoardServiceInterface;
  LeaderBoardController({required this.leaderBoardServiceInterface});

  List<String> selectedFilterType = ['today', 'this_week', 'this_month'];
  String _selectedFilterTypeName = 'today';
  String get selectedFilterTypeName => _selectedFilterTypeName;
  void setFilterTypeName(String name){
    _selectedFilterTypeName = name;
    update();
    getLeaderboardList(1, _selectedFilterTypeName);
  }


  bool isLoading = false;
  LeaderBoardModel? leaderBoardModel;
  Future<void> getLeaderboardList(int offset,String selectedFilterTypeName) async {
    isLoading = true;
    Response? response = await leaderBoardServiceInterface.getLeaderboardList(offset,selectedFilterTypeName);
    if (response!.statusCode == 200) {
      if(offset == 1){
        leaderBoardModel = LeaderBoardModel.fromJson(response.body);
      }else{
        leaderBoardModel!.data!.addAll(LeaderBoardModel.fromJson(response.body).data!);
        leaderBoardModel!.offset = LeaderBoardModel.fromJson(response.body).offset;
        leaderBoardModel!.totalSize = LeaderBoardModel.fromJson(response.body).totalSize;
      }
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  String totalIncome = '0';
  int totalTrip = 0;
  Future<Response> getDailyActivities() async {
    isLoading = true;
    Response? response = await leaderBoardServiceInterface.getDailyActivity();
    if (response!.statusCode == 200) {
      totalIncome = response.body['total_income'].toString();
      totalTrip = response.body['total_trip'];
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

}