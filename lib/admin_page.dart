import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'requests.dart';
import 'package:random_string/random_string.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:group_encypt/User.dart';
import 'remove_button.dart';

class AdminPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      new _AdminPageState();

}

class _AdminPageState extends State<AdminPage> {
  Request request = new Request();
  bool isLoading = false;
  List<ListTile> usersList = new List();

  @override
  void initState() {
    getUsersAsync();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width,56),
        child: Hero(
          tag: "bg",
          child: AppBar(
            title: Text("Admin Panel"),
            backgroundColor: Color(0xfff5a36c),
          ),
        ),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 50.0,
                        child: RaisedButton(
                          onPressed: ()  {
                            addMember(false);

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
                              child: !isLoading? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "ADD MEMBER",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                  Icon(Icons.person, color: Colors.white,),
                                ],
                              ) :
                              SpinKitThreeBounce(color: Colors.white, size: 20,),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50.0,
                        child: RaisedButton(
                          onPressed: ()  {
                            addMember(true);

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
                              child: !isLoading? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "ADD ADMIN",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                  Icon(Icons.person, color: Colors.white,),
                                ],
                              ) :
                              SpinKitThreeBounce(color: Colors.white, size: 20,),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10),),
            Padding(
              padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.08),
              child: Row(
                children: <Widget>[
                  Text(
                    "Users",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  Divider(height: 10, thickness: 1,),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.05),
              child: Column(
                children: usersList.isNotEmpty ? usersList : <Widget> [
                  Padding(
                    padding:  EdgeInsets.fromLTRB(0,MediaQuery.of(context).size.height*.3,0,0),
                    child: SpinKitThreeBounce(color:  Color(0xffff5c5c), size: 30,),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  addMember(bool isAdmin) {
    setState(() {
      isLoading = true;
    });
    String loginId = generateLoginId();
    request.addMember(loginId, isAdmin);
    String copy = "";
    showDialog(
        context: context,
        child: AlertDialog(
          title: isAdmin? Text("Added Admin to the Group."): Text("Added Member to the Group."),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Please send Login ID to the person you would like to add."),
              Padding(padding: EdgeInsets.symmetric(vertical: 10),),
              InkWell(
                splashColor: Colors.grey,
                onTap: () {
                  ClipboardManager.copyToClipBoard(loginId);
                  setState(() {
                    copy = "Copied to clipboard.";
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(loginId),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                        Icon(Icons.content_copy),
                        Text(copy),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("CLOSE"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        )
    );
    setState(() {
      isLoading = false;
    });
    getUsersAsync();
  }

  String generateLoginId() {
    String ret = randomAlpha(5) + "-" + randomAlpha(5);
    print(ret);
    return ret;
  }


  getUsersAsync() async {
    usersList = new List();
    List<User> users = await request.getUsers();
    for(int i = 0; i < users.length; i++) {
      usersList.add(ListTile(title: Text(users[i].id), trailing: RemoveButton(user: users[i]),));
    }
    setState(() {

    });
  }

}