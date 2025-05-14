class TripOverView {
  double? successRate;
  int? totalTrips;
  double? totalEarn;
  int? totalCancel;
  int? totalReviews;
  IncomeStat? incomeStat;

  TripOverView(
      {this.successRate,
        this.totalTrips,
        this.totalEarn,
        this.totalCancel,
        this.totalReviews,
        this.incomeStat});

  TripOverView.fromJson(Map<String, dynamic> json) {
    successRate = json['success_rate'].toDouble();
    totalTrips = json['total_trips'];
    totalEarn = json['total_earn'].toDouble();
    totalCancel = json['total_cancel'];
    totalReviews = json['total_reviews'];
    incomeStat = json['income_stat'] != null
        ? IncomeStat.fromJson(json['income_stat'])
        : null;
  }
}

class IncomeStat {
  double? sun;
  double? mon;
  double? tues;
  double? wed;
  double? thu;
  double? fri;
  double? sat;
  double? sixAm;
  double? temAM;
  double? twoPm;
  double? sixPm;
  double? temPm;
  double? twoAm;


  IncomeStat(
      {this.sun, this.mon, this.tues, this.wed, this.thu, this.fri, this.sat,this.sixAm,this.sixPm,this.temAM,this.temPm,this.twoAm,this.twoPm});

  IncomeStat.fromJson(Map<String, dynamic> json) {
    sun = json['Sun'] != null ? json['Sun'].toDouble() : 0;
    mon = json['Mon'] != null ? json['Mon'].toDouble() : 0;
    tues = json['Tues'] != null ? json['Tues'].toDouble() : 0;
    wed = json['Wed'] != null ? json['Wed'].toDouble() : 0;
    thu = json['Thu'] != null ? json['Thu'].toDouble() : 0;
    fri = json['Fri'] != null ? json['Fri'].toDouble() : 0;
    sat = json['Sat'] != null ? json['Sat'].toDouble() : 0;
    sixAm = json['6:00 am'] != null ? json['6:00 am'].toDouble() : 0;
    temAM = json['10:00 am'] != null ? json['10:00 am'].toDouble() : 0;
    twoPm = json['2:00 pm'] != null ? json['2:00 pm'].toDouble() : 0;
    sixPm = json['6:00 pm'] != null ? json['6:00 pm'].toDouble() : 0;
    temPm = json['10:00 pm'] != null ? json['10:00 pm'].toDouble() : 0;
    twoAm = json['2:00 am'] != null ? json['2:00 am'].toDouble() : 0;
  }
}
