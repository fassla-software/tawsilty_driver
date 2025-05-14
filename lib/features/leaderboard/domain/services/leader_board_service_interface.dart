
abstract class LeaderBoardServiceInterface {
  Future<dynamic> getLeaderboardList(int offset, String selectedFilterName);
  Future<dynamic> getDailyActivity();
}