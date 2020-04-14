import 'package:flutter/material.dart';
import "package:group_encypt/User.dart";
import 'requests.dart';

class RemoveButton extends StatefulWidget {
  User user;
  RemoveButton({@required this.user});
  @override
  State<StatefulWidget> createState() =>
      _RemoveButtonState(this.user);

}

class _RemoveButtonState extends State<RemoveButton> {
  User user;
  Request request = new Request();
  _RemoveButtonState(this.user);
  @override
  Widget build(BuildContext context) {
    return user.isMember ? Container(
      width: MediaQuery.of(context).size.width*.3,
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(100.0),
        ),
        onPressed: () {
          remove();
        },
        color: Color(0xffff5c5c),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("REMOVE", style: TextStyle(color: Colors.white),),
            Icon(Icons.delete,color: Colors.white,),
          ],
        ),
      ),
    ) : Container(
      width: MediaQuery.of(context).size.width*.3,
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(100.0),
        ),
        onPressed: () {
          remove();
        },
        color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("REMOVED", style: TextStyle(color: Colors.white),),
            Icon(Icons.close,color: Colors.white,),
          ],
        ),
      ),
    );
  }

  remove() {
    setState(() {
      user.isMember = false;
    });
    request.removeMember(user);

  }

}