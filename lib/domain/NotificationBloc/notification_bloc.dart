import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roster_app/data/data_sources/remote_data_src.dart';
import 'package:roster_app/di/get_it.dart';
import 'package:roster_app/domain/NotificationBloc/Models/notification_model.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';
import 'package:rxdart/rxdart.dart';

class NotificationBloc{

  final RemoteDataSrc _remoteDataSrc = getIt<RemoteDataSrc>();

  PublishSubject<NotificationList> _getNotificationSubject = PublishSubject<NotificationList>();

  Stream<NotificationList>  get notificationStream => _getNotificationSubject.stream;

  bool isApiResponseReceived = false;
  List<Notifications> notifications = [];
  int get listLength =>  this.notifications.length==0 ? 1 : this.notifications.length;

  Future<int> fetchNotification(GlobalKey<ScaffoldState> _scaffoldKey) async {
    Either<AuthFailure, NotificationList> successOrFailure;
    successOrFailure = await _remoteDataSrc.fetchNotifications();

    successOrFailure.fold(
          (l){
             isApiResponseReceived = true;
            _getNotificationSubject.sink.add(NotificationList(status: 400));
            _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(l.message)));
          },
          (r){
            isApiResponseReceived = true;
            notifications = r.notifications;
            _getNotificationSubject.sink.add(NotificationList(status: 200));
            },
        );

    return 1;

  }

  dispose(){
    _getNotificationSubject.close();
  }

}