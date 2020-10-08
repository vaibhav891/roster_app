import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:roster_app/common/screenutils/screen_utils.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/presentation/common/myappbar.dart';
import 'package:roster_app/common/size_extension.dart';

class QrScanScreen extends StatefulWidget {
  @override
  _QrScanScreenState createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final _qrKey = GlobalKey(debugLabel: 'QR');
  //QRViewController _controller;
  String qrText;

  void _onQRViewCreated(QRViewController controller) {
    //_controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
      print(qrText);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MyAppBar(myTitle: Text('Scan & Check-in')),
      body: Stack(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FractionallySizedBox(
            heightFactor: 0.9,
            child: QRView(
              key: _qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Sizes.dimen_40),
                ),
                color: AppColor.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: Sizes.dimen_24.w, top: Sizes.dimen_24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Task Info'),
                    Text('• Your working hours'),
                    Text('10:00 am - 7:00pm'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
