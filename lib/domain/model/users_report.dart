class UsersReport {
  int startDateTs;
  int endDateTs;
  int totalWorkTimeInHrs;
  List<WorkSummary> workSummary;

  UsersReport({this.startDateTs, this.endDateTs, this.totalWorkTimeInHrs, this.workSummary});

  UsersReport.fromJson(Map<String, dynamic> json) {
    startDateTs = json['startDateTs'];
    endDateTs = json['endDateTs'];
    totalWorkTimeInHrs = json['totalWorkTimeInHrs'];
    if (json['workSummary'] != null) {
      workSummary = new List<WorkSummary>();
      json['workSummary'].forEach((v) {
        workSummary.add(new WorkSummary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startDateTs'] = this.startDateTs;
    data['endDateTs'] = this.endDateTs;
    data['totalWorkTimeInHrs'] = this.totalWorkTimeInHrs;
    if (this.workSummary != null) {
      data['workSummary'] = this.workSummary.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkSummary {
  int locationId;
  String locationName;
  List<DailyReport> dailyReport;

  WorkSummary({this.locationId, this.locationName, this.dailyReport});

  WorkSummary.fromJson(Map<String, dynamic> json) {
    locationId = json['locationId'];
    locationName = json['locationName'];
    if (json['dailyReport'] != null) {
      dailyReport = new List<DailyReport>();
      json['dailyReport'].forEach((v) {
        dailyReport.add(new DailyReport.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationId'] = this.locationId;
    data['locationName'] = this.locationName;
    if (this.dailyReport != null) {
      data['dailyReport'] = this.dailyReport.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyReport {
  String name;
  int userId;
  int dateTs;
  int checkInTimeTs;
  int checkOutTimeTs;
  int durationInHrs;
  int lateInMins;

  DailyReport(
      {this.name,
      this.userId,
      this.dateTs,
      this.checkInTimeTs,
      this.checkOutTimeTs,
      this.durationInHrs,
      this.lateInMins});

  DailyReport.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    userId = json['userId'];
    dateTs = json['dateTs'];
    checkInTimeTs = json['checkInTimeTs'];
    checkOutTimeTs = json['checkOutTimeTs'];
    durationInHrs = json['durationInHrs'];
    lateInMins = json['lateInMins'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['userId'] = this.userId;
    data['dateTs'] = this.dateTs;
    data['checkInTimeTs'] = this.checkInTimeTs;
    data['checkOutTimeTs'] = this.checkOutTimeTs;
    data['durationInHrs'] = this.durationInHrs;
    data['lateInMins'] = this.lateInMins;
    return data;
  }
}
