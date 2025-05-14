
class RewardModel{
  final String title;
  final double? amount;
  final String image;
  final bool step;
  final int? targetStep;
  final int? filUpStep;
  final double? todayTargetAmount;
  final double? todayTargetFilUpAmount;
  final double? todayTargetPoint;

  RewardModel(
      {required this.title,
      this.amount,
      required this.image,
      this.step = false,
      this.targetStep,
      this.filUpStep,
      this.todayTargetAmount,
      this.todayTargetFilUpAmount,
      this.todayTargetPoint});
}