import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gradient_text/gradient_text.dart';
import 'diagonal_clipper.dart';
import 'home_page.dart';
import 'User.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'requests.dart';


class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      new _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  Request request = new Request();
  TextEditingController textEditingController = new TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Color(0xfff5a36c),
    ));
    return SafeArea(
      child: Scaffold(
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
                              height: MediaQuery.of(context).size.height *.65,
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
                                  Padding(padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height*.47, 0, 0),),
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
                                                  "Welcome.",
                                                  gradient: LinearGradient(colors: [Color(0xfff5a36c), Color(0xffff5c5c)],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                  ),
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width/12),
                                                ),
                                              ),
                                              Padding(padding: EdgeInsets.symmetric(vertical: 10),),
                                              TextFormField(
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  focusColor: Colors.indigo,
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Login ID',
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
                                  child: Container(
                                    height: 50.0,
                                    child: RaisedButton(
                                      onPressed: () {
                                        login(textEditingController.text);
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
                                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*.75, minHeight: 50.0),
                                          alignment: Alignment.center,
                                          child: !isLoading ? Text(
                                            "LOGIN",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white
                                            ),
                                          ) : SpinKitThreeBounce(color: Colors.white, size: 20,),
                                        ),
                                      ),
                                    ),
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

  login(String id) async {
    if(id == "") {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Login ID empty."),
            content: Text("Please enter your Login ID."),
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
    else {
      setState(() {
        isLoading = true;
      });
      User user = await request.checkUser(id);
      //await request.addMember(id, false);
      //User user = new User(id: id, isAdmin: false, isMember: false);
      setState(() {
        isLoading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(user: user,)
          )
      );
    }
  }


  Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>> getKeyPair() {
    var helper = RsaKeyHelper();
    return helper.computeRSAKeyPair(helper.getSecureRandom());
  }

}