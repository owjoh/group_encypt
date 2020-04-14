import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:share/share.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'User.dart';
import 'admin_page.dart';


import 'diagonal_clipper.dart';

class HomePage extends StatefulWidget {
  User user;
  HomePage({@required this.user});
  @override
  State<StatefulWidget> createState() =>
      new _HomePageState(this.user);

}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = new TextEditingController();
  bool isLoading = false;
  User user;
  final storage = new FlutterSecureStorage();

  _HomePageState(this.user) {
    print(user.isAdmin);
  }

  @override
  void initState() {

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Color(0xfff5a36c),
    ));
    return SafeArea(
      child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: user.isAdmin ?
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FloatingActionButton.extended(
              backgroundColor: Color(0xffff5c5c),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminPage()
                      )
                  );
                },
                label: Text("Admin Panel"),
              icon: Icon(Icons.group),
            ),
          )
          :
          null
          ,
          body: ListView(
            children: <Widget> [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Hero(
                          tag: 'bg',
                          child: ClipPath(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height *.3,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Color(0xfff5a36c), Color(0xffff5c5c)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*.1),)
                                  ],
                                ),
                              ),
                              //child: ClipOval(child: Image.asset("assets/images/ADV_Dating_Logo.png", scale: 2,), clipBehavior: Clip.antiAlias,),
                            ),
                            clipper: DiagonalClipper(),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * .35,
                        ),
                        Positioned(
                          child: Stack(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height*.1, 0, 0),),
                                  Hero(
                                    tag: "box",
                                    child: Card(
                                      elevation: 4,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width* .80,
                                        child:  Padding(
                                          padding: const EdgeInsets.all(30),
                                          child: Column(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: GradientText(
                                                  "Enter Text.",
                                                  gradient: LinearGradient(colors: [Color(0xfff5a36c), Color(0xffff5c5c)],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                  ),
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width/12),
                                                ),
                                              ),
                                              Padding(padding: EdgeInsets.symmetric(vertical: 10),),
                                              TextFormField(
                                                maxLines: 10,
                                                decoration: InputDecoration(
                                                  focusColor: Colors.indigo,
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Text to Decrypt/Encrypt',
                                                ),
                                                controller: textEditingController,
                                              ),
                                              Padding(padding: EdgeInsets.symmetric(vertical: 10),),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 25,
                                  )
                                ],
                              ),
                              Positioned(
                                left: MediaQuery.of(context).size.width/8,
                                bottom: 4,
                                child: Hero(
                                  tag: "button",
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        height: 50.0,
                                        child: RaisedButton(
                                          onPressed: ()  {
                                            decryptText(textEditingController.text);
                                          },
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                          padding: EdgeInsets.all(0.0),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(colors: [Color(0xfff5a36c), Color(0xffff5c5c)],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                                borderRadius: BorderRadius.circular(30.0)
                                            ),
                                            child: Container(
                                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*.225, minHeight: 50.0),
                                              alignment: Alignment.center,
                                              child: !isLoading ? Text(
                                                "DECRYPT",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white
                                                ),
                                              ) : SpinKitThreeBounce(color: Colors.white, size: 20,),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 50.0,
                                        child: RaisedButton(
                                          onPressed: () {
                                            encryptTextAndShare(textEditingController.text);
                                          },
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                          padding: EdgeInsets.all(0.0),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(colors: [Color(0xfff5a36c), Color(0xffff5c5c)],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                                borderRadius: BorderRadius.circular(30.0)
                                            ),
                                            child: Container(
                                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*.4, minHeight: 50.0),
                                              alignment: Alignment.center,
                                              child: !isLoading ? Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "ENCRYPT & SHARE",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                  Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
                                                  Icon(Icons.share, size: 15, color: Colors.white,)
                                                ],
                                              ) : SpinKitThreeBounce(color: Colors.white, size: 20,),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 50.0,
                                        width: 50,
                                        child: RaisedButton(
                                          onPressed: () {
                                            textEditingController.clear();
                                          },
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                          padding: EdgeInsets.all(0.0),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(colors: [ Color(0xffff5c5c),Colors.redAccent],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                                borderRadius: BorderRadius.circular(30.0)
                                            ),
                                            child: Container(
                                              constraints: BoxConstraints(maxWidth:50, minHeight: 50.0),
                                              alignment: Alignment.center,
                                              child: !isLoading ? Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(Icons.close, size: 15, color: Colors.white,)
                                                ],
                                              ) : SpinKitThreeBounce(color: Colors.white, size: 20,),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height *.1,
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }

  decryptText(String text) {
    if(user.isMember) {
      String decrypted = decrypt(text, user.keyPair.privateKey);
      textEditingController.text = decrypted;
    }
    else {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text("You are not part of the group."),
            content: Text("Please request access from a group admin."),
            actions: <Widget>[
              FlatButton(
                child: Text("CLOSE"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ));
    }
  }


  encryptTextAndShare(String text) {
    if(user.isMember) {
      String cipherText = encrypt(text, user.keyPair.publicKey);
      textEditingController.text = cipherText;
      Share.share(cipherText);
    }
    else {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text("You are not part of the group."),
            content: Text("Please request access from a group admin."),
            actions: <Widget>[
              FlatButton(
                child: Text("CLOSE"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ));
    }
  }


}