import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_demo/DataModel/NewsItem.dart';
import 'package:new_demo/DataModel/Stories.dart';
import 'package:new_demo/HackerNewsClient/HackerNewsClient.dart';

import 'RowItem.dart';

// For News Feed Page to Load Top Stories News
class NewsPage extends StatefulWidget {
  NewsPage({Key key, this.story}) : super(key: key);
  Stories story;

  @override
  State<StatefulWidget> createState() {
    return _NewsPageState();
  }
}

class _NewsPageState extends State<NewsPage> {
  HackerNewsClient hackerClient = HackerNewsClient();
  bool _isLoading = false;
  String _errorLoadingFeed;
  List<dynamic> _id = [];
  Map<int, Item> items = Map();
   FlatButton _flatButton=new FlatButton(onPressed: null, child: null);

  @override
  void initState() {
    super.initState();
    loadFeed();
  }

  void loadFeed() async {
    setState(() {
      this._id = [];
      this.items = Map();
      this._isLoading = true;
      this._errorLoadingFeed = null;
    });
    try {
      var id = await hackerClient.getFeed(widget.story);
      setState(() {
        this._isLoading = false;
        this._id = id.toList();
      });
    } catch (e) {
      setState(() {
        this._isLoading = false;
        this._errorLoadingFeed = "Failed to load feed";
      });
    }
  }

  void refresh() {
    loadFeed();
  }

  String title() {
    switch (widget.story) {
      case Stories.top:
        return "Top Stories";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(builder: (BuildContext context) {
      return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white,
        navigationBar: CupertinoNavigationBar(
          middle: Text(title()),
          // trailing: _isLoading
          //     ? null
          //     : CupertinoButton(
          //         padding: EdgeInsets.zero,
          //         child: const Tooltip(
          //           message: "Refresh",
          //           child: Icon(
          //             CupertinoIcons.refresh,
          //             color: const Color(0xFFFF6600),
          //           ),
          //           excludeFromSemantics: true,
          //         ),
          //         onPressed: () {
          //           this.refresh();
          //         },
          //       ),
        ),
        child: this._errorLoadingFeed != null
            ? Container(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    this._errorLoadingFeed,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                ))
            : this._isLoading
                ? Container(
                    child: Center(
                      child: CupertinoActivityIndicator(
                        animating: true,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: this._id.length,
                    itemBuilder: (BuildContext context, int position) {
                      return FutureBuilder(
                          future: hackerClient.getItem(this._id[position]),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (items[position] != null) {
                              var item = items[position];
                              return ItemRow(
                                  item: item, key: Key(item.id.toString()));
                            }
                            if (snapshot.hasData && snapshot.data != null) {
                              var item = snapshot.data;
                              items[position] = item;
                              return ItemRow(
                                  item: item, key: Key(item.id.toString()));
                            } else if (snapshot.hasError) {
                              return Container(
                                padding: EdgeInsets.all(32.0),
                                child: Center(
                                    child: Text(
                                  "Error loading story ${this._id[position]}",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w300),
                                )),
                              );
                            } else {
                              return Container(
                                padding: EdgeInsets.all(32.0),
                                child: Center(
                                  child: CupertinoActivityIndicator(
                                    animating: true,
                                  ),
                                ),
                              );
                            }
                          });
                    },
                  ),
      );
    });
  }
}