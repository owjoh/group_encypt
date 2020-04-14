import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'User.dart';

class Request {
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  Future<http.Response> fetchAllMembers() {
    return http.get(
      "https://group-encrypt.firebaseio.com/members.json",
    );
  }

  Future<List<User>> getUsers() async {
    List<User> users = new List();
    http.Response response = await fetchAllMembers();
    print(response.body);
    Map<String, dynamic> map = jsonDecode(response.body);
    map.forEach((key, value) {
      users.add(User(id: key, isMember: value["member"], isAdmin: value["admin"]));
    });
    return users;
  }

  Future<User> checkUser(String id) async {
    http.Response response = await fetchAllMembers();
    print(response.body);
    bool isMember = false;
    bool isAdmin = false;
    Map<String, dynamic> map = jsonDecode(response.body);
    map.forEach((key, value) {
      if(key.toLowerCase() == id.toLowerCase() && value["member"] == true) {
        isMember = true;
        if(value["admin"] == true) {
          isAdmin = true;
        }
      }
    });
    print(isMember);
    return new User(id: id,isMember: isMember, isAdmin: isAdmin);
  }

  addMember(String id, bool isAdmin) {
    databaseReference.child("/members/" + "/" + id + "/").set({
      "admin" : isAdmin,
      "member" : true,
    });
  }

  removeMember(User user) {
    databaseReference.child("/members/" + "/" + user.id + "/").update({
      "admin" : user.isAdmin,
      "member" : false,
    });
  }

}
