import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_demo/DataModel/NewsItem.dart';
import 'package:url_launcher/url_launcher.dart';



// For DisplayEach News feed Row Item
class ItemRow extends StatelessWidget {
  final Item item;
  ItemRow({Key key, this.item}) : super(key: key);

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(item.time * 1000);
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(right: 6.0),
                  child: Text(
                    item.title,
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 17.0),
                  ),
                )),
                // GestureDetector(
                //     onTap: () {
                //       Navigator.of(context).push(CupertinoPageRoute(
                //           builder: (context) => CommentPage(item: item)));
                //     },
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: <Widget>[
                //         Icon(
                //           Icons.comment,
                //           color: const Color(0xFFFF6600),
                //         ),
                //         Container(
                //           padding: EdgeInsets.only(left: 4.0),
                //           child: Text(
                //             "${item.descendants != null ? item.descendants : 0}",
                //             style: TextStyle(
                //                 color: const Color(0xFFFF6600),
                //                 fontWeight: FontWeight.w700,
                //                 fontSize: 18.0),
                //           ),
                //         )
                //       ],
                //     ))
              ],
            )),
            Container(
              padding: EdgeInsets.only(top: 6.0),
              child: Text(
                "${item.by != null ? item.by : 'unknown'} - ${new DateFormat('dd/MM/yyyy').format(new DateTime.fromMillisecondsSinceEpoch(item.time*1000))}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 4.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          child: Text(
                        item.url != null ? item.url : "-",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                          color: Colors.blue,
                          decoration: TextDecoration.underline
                        
                        ),
                      )),
                    ),
                  ],
                ))
          ],
        ),
      ),
      onTap: () {
        launchURL(item.url);
      },
    );
  }
}