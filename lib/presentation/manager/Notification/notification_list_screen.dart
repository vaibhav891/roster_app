import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/domain/NotificationBloc/notification_bloc.dart';
import 'package:roster_app/presentation/manager/Notification/notification_list_adapter.dart';

class NotificationListScreen extends StatefulWidget {
  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  NotificationBloc _bloc;

  StreamSubscription notificationSubscription;

  @override
  void initState() {
    _bloc = NotificationBloc();

    Future.delayed(Duration(milliseconds: 300), () {
      getNotificationData();
    });

    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    if (notificationSubscription != null) notificationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: AppColor.lightBlue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColor.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Notifications", style: TextStyle(fontSize: 18, color: AppColor.white, fontFamily: "Product Sans"),
        ),
      ),
      body: Container(
          color: AppColor.white,
          child: (this._bloc.isApiResponseReceived)
              ? RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                      itemCount:this._bloc.listLength,
                      padding: EdgeInsets.only(top:this._bloc.notifications.length == 0?0: 20, bottom:this._bloc.notifications.length == 0 ?0: 20),
                      itemBuilder: (ctx, index) {

                        if(this._bloc.notifications.length == 0 && index ==0 ) {
                          return Container(
                            height: MediaQuery.of(context).size.height - 80 ,
                            child: Center(
                              child: Text("No Notifications", style: TextStyle(fontSize: 18, color: AppColor.textDark, fontFamily: "Product Sans"),
                            ),
                          ));
                        }
                        return NotificationListAdapter(notification: this._bloc.notifications[index],);
                      }),
                )
              : Container(
                  height: MediaQuery.of(context).size.height - 80,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )),
    );
  }

  Future<void> _onRefresh() async {
    this._bloc.isApiResponseReceived = false;
   int i = await this._bloc.fetchNotification(_key);
  }

  getNotificationData() {
    //Listening to stream
    notificationSubscription = this._bloc.notificationStream.listen((event) {
      setState(() {});
    });

    this._bloc.fetchNotification(_key);
  }
}
