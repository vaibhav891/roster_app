import 'package:flutter/material.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/domain/NotificationBloc/Models/notification_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationListAdapter extends StatelessWidget {
  Notifications notification;
  NotificationListAdapter({this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width,
      color: AppColor.sandGrey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(color: AppColor.lightBlue, shape: BoxShape.circle),
            child: Center(
                child: Text(
              (notification?.from ?? " ")[0],
              style: TextStyle(fontSize: 20, color: AppColor.white, fontFamily: "Product Sans"),
            )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 10),
                width: MediaQuery.of(context).size.width - 100,
                child: RichText(
                  text: TextSpan(
                      text: notification.title + " : ",
                      style: TextStyle(
                          color: AppColor.textDark,
                          fontSize: 16,
                          fontFamily: "Product Sans",
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: notification.message,
                          style: TextStyle(color: AppColor.textLight, fontSize: 15, fontFamily: "Product Sans"),
                        )
                      ]),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.access_time,
                    color: AppColor.textLight,
                    size: 15,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    timeago.format(DateTime.fromMillisecondsSinceEpoch(notification.timestamp * 1000)),
                    style: TextStyle(fontSize: 12, color: AppColor.textLight, fontFamily: "Product Sans"),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
