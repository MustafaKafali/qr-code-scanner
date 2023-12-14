import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_generator/generator_screen.dart';
import 'package:qr_code_scanner_generator/scanner_screen.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Size size;

  @override
  Widget build(BuildContext context) {

   size= MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF7524F),
        title: Center(child: Text("QR Code Scanner & Generator",  style: TextStyle(fontWeight: FontWeight.bold),)),
      ),
      body: Container(
        color: Color(0xffEEEEEE),
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  child: Text("Scan QR Code"),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ScannerScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffF7524F),
                    textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))
                    ),
                    shadowColor: Color(0xffF7524F),
                  ),
                ),
              ),
            SizedBox(height: 20,),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                child: Text("Generate QR Code"),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> GeneratorScreen()));
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffF7524F),
                  textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))
                  ),
                  shadowColor: Color(0xffF7524F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
