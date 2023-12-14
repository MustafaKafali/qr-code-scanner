import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScannerScreen extends StatefulWidget {

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {

  late Size size;
  final GlobalKey _grKey = GlobalKey(debugLabel: "QR");

  QRViewController? _controller;
  Barcode? result;

  bool _isBuild = false;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    if(!_isBuild && _controller != null){
      _controller?.pauseCamera();
      _controller?.resumeCamera();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF7524F),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("QR Code Scanner", style: TextStyle(fontWeight: FontWeight.bold),),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(flex:9, child: _buildQrView(context)),
            Expanded(flex:1, child: Container(
              color: Color(0xffe3dfdf),
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: ()async{
                        await _controller?.toggleFlash();
                      },
                      child: Icon(Icons.flash_on, size :24, color: Color(0xffF7524F),)),
                  GestureDetector(
                      onTap: ()async{
                        await _controller?.flipCamera();
                      },

                    child: Icon(Icons.flip_camera_ios, size :24, color: Color(0xffF7524F),)),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
  Widget _buildQrView(BuildContext context){

    var scanArea = 250.0;
    return QRView(
        key: _grKey,
        onQRViewCreated: _onQRViewCreated,
      onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
      overlay:  QrScannerOverlayShape(
        cutOutSize: scanArea,
        borderWidth: 10,
        borderLength: 40,
        borderRadius: 5.0,
        borderColor: Color(0xffF7524F),
      ),
    );
  }

  void _onQRViewCreated(QRViewController _qrController){
    setState(() {
      this._controller = _qrController;
    });

    _controller?.scannedDataStream.listen((event) {
      setState(() {
        result = event;
        _controller?.pauseCamera();
      });
      if(result?.code!=null){
        print("QR code Scanned and showing Result");
        _showResult();
      }
    });
  }
  void onPermissionSet(BuildContext context, QRViewController _ctrl, bool _permission){
    if(!_permission){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No Permission!"))
      );
    }
  }

  Widget _showResult(){

    bool _validURL = Uri.parse(result!.code.toString()).isAbsolute;
    return Center(
      child: FutureBuilder<dynamic>(
        future: showDialog(
            context: context,
            builder: (BuildContext context){
              return WillPopScope(
                  child: AlertDialog(
                    title: Text("Scan Result!", style: TextStyle(fontWeight: FontWeight.bold),),
                    content: SizedBox(
                      height: 140,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _validURL?
                              SelectableText.rich(
                                TextSpan(
                                  text: result!.code.toString(),
                                  style: TextStyle(
                                    color: Color(0xffF7524F),
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap=(){
                                    launchUrl(Uri.parse(result!.code.toString()));
                                  }
                                ),
                              ):
                          Text(result!.code.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                          ElevatedButton(
                              onPressed: (){
                                Navigator.pop(context);
                                _controller?.resumeCamera();
                              },
                              child: Text("Close"),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xffF7524F),
                              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(4.0))
                              ),
                              shadowColor: Color(0xffF7524F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onWillPop: ()async => false,);
        }),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          throw UnimplementedError;
        },
      ),
    );
  }
}
