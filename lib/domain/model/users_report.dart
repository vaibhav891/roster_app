class UsersReport {
  int startDateTs;
  int endDateTs;
  int totalWorkTimeInHrs;
  int remainingWorkTimeInHrs;
  List<WorkSummary> workSummary;

  UsersReport({
    this.startDateTs,
    this.endDateTs,
    this.totalWorkTimeInHrs,
    this.remainingWorkTimeInHrs,
    this.workSummary,
  });

  UsersReport.fromJson(Map<String, dynamic> json) {
    startDateTs = json['startDateTs'];
    endDateTs = json['endDateTs'];
    totalWorkTimeInHrs = json['totalWorkTimeInHrs'];
    remainingWorkTimeInHrs = json['remainingWorkTimeInHrs'];
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
    data['remainingWorkTimeInHrs'] = this.remainingWorkTimeInHrs;
    if (this.workSummary != null) {
      data['workSummary'] = this.workSummary.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkSummary {
  int siteId;
  String siteName;
  String company;
  List<DailyReport> dailyReport;

  WorkSummary({
    this.siteId,
    this.siteName,
    this.company,
    this.dailyReport,
  });

  WorkSummary.fromJson(Map<String, dynamic> json) {
    siteId = json['siteId'];
    siteName = json['siteName'];
    company = json['company'];
    if (json['dailyReport'] != null) {
      dailyReport = new List<DailyReport>();
      json['dailyReport'].forEach((v) {
        dailyReport.add(new DailyReport.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['siteId'] = this.siteId;
    data['siteName'] = this.siteName;
    data['company'] = this.company;
    if (this.dailyReport != null) {
      data['dailyReport'] = this.dailyReport.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyReport {
  String name;
  String userId;
  int dateTs;
  int signInTimeTs;
  int signOutTimeTs;
  int durationInHrs;
  int extra;
  int lateInMins;
  String leaveType;

  DailyReport(
      {this.name,
      this.userId,
      this.dateTs,
      this.signInTimeTs,
      this.signOutTimeTs,
      this.durationInHrs,
      this.extra,
      this.lateInMins,
      this.leaveType});

  DailyReport.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    userId = json['userId'];
    dateTs = json['dateTs'];
    signInTimeTs = json['signInTimeTs'];
    signOutTimeTs = json['signOutTimeTs'];
    durationInHrs = json['durationInHrs'];
    extra = json['extra'];
    lateInMins = json['lateInMins'];
    leaveType = json['leaveType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['userId'] = this.userId;
    data['dateTs'] = this.dateTs;
    data['signInTimeTs'] = this.signInTimeTs;
    data['signOutTimeTs'] = this.signOutTimeTs;
    data['durationInHrs'] = this.durationInHrs;
    data['extra'] = this.extra;
    data['lateInMins'] = this.lateInMins;
    data['leaveType'] = this.leaveType;
    return data;
  }
}
