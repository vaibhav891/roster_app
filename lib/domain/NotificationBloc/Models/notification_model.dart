class NotificationList {
  int status;
  List<Notifications> notifications;

  NotificationList({this.notifications,this.status});

  NotificationList.fromJson(Map<String, dynamic> json) {
    notifications = new List<Notifications>();
    if (json['notifications'] != null) {
      json['notifications'].forEach((v) {
        notifications.add(new Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  String from;
  String to;
  String title;
  String message;
  String type;
  int timestamp;

  Notifications(
      {this.from,
        this.to,
        this.title,
        this.message,
        this.type,
        this.timestamp});

  Notifications.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    title = json['title'];
    message = json['message'];
    type = json['type'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    data['title'] = this.title;
    data['message'] = this.message;
    data['type'] = this.type;
    data['timestamp'] = this.timestamp;
    return data;
  }
}