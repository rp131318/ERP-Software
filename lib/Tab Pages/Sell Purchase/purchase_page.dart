import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../globalVariable.dart';
import 'dart:convert';
import 'package:http/http.dart';

import '../sell_purchase_page.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({Key key}) : super(key: key);

  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  var title = [
    "Sr. No.",
    "Name",
    "Remaining",
    "Part Number",
    "Payment Method",
    "Date",
    "Bill Photo"
  ];
  int currentPage = 0;
  var name = [];
  var qnt = [];
  var partNumber = [];
  var photo = [];
  var date = [];
  var remaining = [];
  var outArray = [];
  var paymentMethod = [];

  String filterDropdown = "Select";

  var filterList = [
    "Select",
    "january",
    "february",
    "march",
    "april",
    "may",
    "june",
    "july",
    "august",
    "september",
    "october",
    "november",
    "december"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage == 0
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 22, bottom: 22, top: 22),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentPage = 1;
                              });
                            },
                            child: Icon(
                              Icons.arrow_back,
                              size: 33,
                              color: colorBlack5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 18, bottom: 18, left: 18),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Purchase Details",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            height: 26,
                            width: 333,
                            decoration: BoxDecoration(
                                color: Color(0xfff2f2f2),
                                // border: Border.all(width: 1, color: grey),
                                borderRadius: BorderRadius.circular(0)),
                            margin:
                                EdgeInsets.only(left: 18, right: 18, top: 6),
                            padding: EdgeInsets.only(left: 14),
                            child: DropdownButton<String>(
                              value: filterDropdown,
                              dropdownColor: colorCard,
                              elevation: 0,
                              underline: Container(),
                              icon: Container(),
                              onChanged: (String newValue) {
                                setState(() {
                                  filterDropdown = newValue;
                                });

                                getData("-", filterDropdown);
                              },
                              items: filterList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20),
                  //   child: Align(
                  //     alignment: Alignment.topLeft,
                  //     child: Text(
                  //       "Sold Products Details",
                  //       style: TextStyle(
                  //           fontSize: 18,
                  //           color: colorBlack5,
                  //           fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                  name.length > 0
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 22, left: 0, right: 14),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 46.0,
                                columns: List.generate(title.length, (index) {
                                  return DataColumn(
                                      label: Text(title[index].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)));
                                }),
                                rows: List.generate(
                                    name.length, (index) => _getDataRow(index)),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 111),
                          child: loadingWidget(),
                        ),

                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            )
          : SellPurchasePage(),
    );
  }

  DataRow _getDataRow(index) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text("${index + 1}")),
        DataCell(SizedBox(
          width: 200,
          child: Text("${name[index]}"),
        )),
        // DataCell(Text("${qnt[index]}")),
        // DataCell(Text("${outArray[index]}")),
        DataCell(Text("${remaining[index]}")),
        DataCell(Text("${partNumber[index]}")),
        DataCell(Text("${paymentMethod[index]}")),
        DataCell(Text("${date[index]}")),
        DataCell(
          InkWell(
            onTap: () {
              launch(photo[index].toString());
            },
            child: Image.asset(
              "images/pdf.png",
              width: 33,
              height: 33,
            ),
          ),
        ),
      ],
    );
  }

  void getData([String type = "all", String _name = "no"]) {
    name.clear();
    qnt.clear();
    partNumber.clear();
    date.clear();
    outArray.clear();
    remaining.clear();
    paymentMethod.clear();
    photo.clear();
    DateTime now = DateTime.now();
    String sendDate = "${now.day}-${now.month}-${now.year}";
    Uri url;
    // if (type == "select") {
    //   url =
    //       Uri.parse(APIUrl.mainUrl + APIUrl.getRaw + "?type=$type&name=$_name");
    // } else if (type == "all") {
    //   url = Uri.parse(APIUrl.mainUrl + APIUrl.getRaw + "?type=$type");
    // } else {
    //   url = Uri.parse(
    //       APIUrl.mainUrl + APIUrl.getRaw + "?type=$type&date=$sendDate");
    // }

    if (type != "all") {
      url = Uri.parse(
          APIUrl.mainUrl + APIUrl.getRaw + "?type=month&month=$_name");
    } else {
      url = Uri.parse(APIUrl.mainUrl + APIUrl.getRaw + "?type=$type");
    }

    try {
      print("URL :: $url");
      get(url).then((value) {
        print("Raw Materials :: ${value.body}");
        final jsonData = jsonDecode(value.body);
        print("Len :: ${getJsonLength(value.body)}");
        for (int i = 0; i < getJsonLength(value.body); i++) {
          name.add(jsonData[i]["name"]);
          qnt.add(jsonData[i]["quantity"]);
          partNumber.add(jsonData[i]["part_number"]);
          date.add(jsonData[i]["in_date"]);
          photo.add(jsonData[i]["bill_photo"]);
          outArray.add(jsonData[i]["out"]);
          remaining.add(jsonData[i]["total"]);
          paymentMethod.add(jsonData[i]["payment"]);
          setState(() {
            // isLoading = false;
          });
        }
        setState(() {});
      });
      // Uri url1 = Uri.parse(APIUrl.mainUrl + APIUrl.getRaw + "?type=all");
      // get(url1).then((value) {
      //   print("Raw Materials :: ${value.body}");
      //   int len = getJsonLength(jsonDecode(value.body));
      //   final jsonData = jsonDecode(value.body);
      //   print("Len :: $len");
      //   for (int i = 0; i < len; i++) {
      //     setState(() {
      //       if (!(filterList.contains("${jsonData[i]["name"]}"))) {
      //         filterList.add(jsonData[i]["name"]);
      //       }
      //
      //       if (!(rawNameList.contains("${jsonData[i]["name"]}"))) {
      //         rawNameList.add(jsonData[i]["name"]);
      //       }
      //     });
      //   }
      // });
    } catch (e) {
      //
    }
  }
}
