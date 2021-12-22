import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../globalVariable.dart';

class MarketingDetails extends StatefulWidget {
  const MarketingDetails({Key key}) : super(key: key);

  @override
  _MarketingDetailsState createState() => _MarketingDetailsState();
}

class _MarketingDetailsState extends State<MarketingDetails> {
  var name = [];
  var date = [];
  var remark = [];
  var location = [];
  var customerName = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 18, left: 18),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Employee Marketing Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, top: 22, right: 18),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: name.length + 1,
                itemBuilder: (context, index) {
                  return index == 0
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Employee",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Text(
                                    "Customer",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  flex: 1,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    "Date",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Text(
                                    "Location",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Text(
                                    "Remark",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  flex: 4,
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(name[index - 1]),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Text(customerName[index - 1]),
                                  flex: 1,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(date[index - 1]),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Text(location[index - 1]),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Text(remark[index - 1]),
                                  flex: 4,
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        );
                }),
          ),
        ],
      ),
    );
  }

  void getData() {
    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.getMarketing);
    print("Url :: $url");
    get(url).then((value) {
      print("Value :: ${value.body}");
      final jsonData = jsonDecode(value.body);
      int len = getJsonLength(jsonData);
      print("Len :: $len");
      for (int i = 0; i < len; i++) {
        name.add(jsonData[i]["employe"]);
        date.add(jsonData[i]["date"]);
        remark.add(jsonData[i]["remark"]);
        location.add(jsonData[i]["location"]);
        customerName.add(jsonData[i]["customer"]);
        setState(() {});
      }
    });
  }
}
