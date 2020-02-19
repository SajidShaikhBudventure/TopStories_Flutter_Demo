import 'package:firebase/firebase_io.dart';
import 'dart:async';
import 'package:new_demo/DataModel/NewsItem.dart';
import 'package:new_demo/DataModel/Stories.dart';


// For FireBase Http Client to call Top Stories News
class HackerNewsClient {
  FirebaseClient _client = FirebaseClient.anonymous();
  String _rootAPIPath = "https://hacker-news.firebaseio.com/v0/";

  static final HackerNewsClient _singleton =
      HackerNewsClient._internal();
  HackerNewsClient._internal();

  factory HackerNewsClient() {
    return _singleton;
  }

  Future<List<Item>> getComments(Item item) async {
    if (item.kids.length == 0) {
      return List();
    } else {
      var comments = await Future.wait(item.kids.map((id) => getItem(id)));
      var nestedComments =
          await Future.wait(comments.map((comment) => getComments(comment)));
      for (var i = 0; i < nestedComments.length; i++) {
        comments[i].comments = nestedComments[i];
      }
      return comments;
    }
  }

  Future<Item> getItem(int id) async {
    var itemPath = "$_rootAPIPath/item/$id.json";
    var response = await _client.get(itemPath);
    return Item.fromJson(response);
  }

  Future<List<dynamic>> getFeed(Stories story) async {
    var path = '';
    switch (story) {
      case Stories.top:
        path = 'topstories';
        break;
    }
    var fullPath = "$_rootAPIPath$path.json";
    var response = await _client.get(fullPath);
    return response;
  }
}