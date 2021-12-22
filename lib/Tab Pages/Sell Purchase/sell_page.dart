import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../globalVariable.dart';
import 'package:http/http.dart';

import '../sell_purchase_page.dart';

class SellPage extends StatefulWidget {
  const SellPage({Key key}) : super(key: key);

  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  int currentPage = 0;
  var title = [
    "Sr. No.",
    "Customer Name",
    "Total Price",
    "Payment Status",
    "Bank Details",
    "Remark",
    "Date",
    "Bill Photo"
  ];
  var customerName = [];
  var paymentStatus = [];
  var bankDetails = [];
  var date = [];
  var photo = [];
  var remark = [];
  var total = [];

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
    getPakkaBillDetails();
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
                                "Sold Products Details",
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
                                getPakkaBillDetails(newValue.toString());
                                setState(() {
                                  filterDropdown = newValue;
                                });
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
                  customerName.length > 0
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 22, left: 0, right: 14),
                            child: DataTable(
                              columnSpacing: 28.0,
                              columns: List.generate(title.length, (index) {
                                return DataColumn(
                                    label: Text(title[index].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)));
                              }),
                              rows: List.generate(customerName.length,
                                  (index) => _getDataRow(index, 0)),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 111),
                          child: loadingWidget(),
                        ),
                ],
              ),
            )
          : SellPurchasePage(),
    );
  }

  DataRow _getDataRow(index, int mm) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text("${index + 1}")),
        DataCell(Text("${customerName[index]}")),
        DataCell(Text("${total[index]}")),
        DataCell(Text("${paymentStatus[index]}")),
        DataCell(Text("${bankDetails[index]}")),
        DataCell(Text(
          "${addNextLine(remark[index])}",
        )),
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

  addNextLine(String text) {
    final value = text.replaceAllMapped(
        RegExp(r".{15}"), (match) => "${match.group(0)}\n");
    print("value: $value");
    return value;
  }

  void getPakkaBillDetails([String month = ""]) {
    customerName.clear();
    paymentStatus.clear();
    bankDetails.clear();
    total.clear();
    date.clear();
    photo.clear();
    remark.clear();
    Uri url;
    if (month != "") {
      url = Uri.parse(
          APIUrl.mainUrl + APIUrl.getPakkaBill + "?type=month&month=$month");
    } else {
      url = Uri.parse(APIUrl.mainUrl + APIUrl.getPakkaBill);
    }

    get(url).then((value) {
      print("Raw Materials :: ${value.body}");
      final jsonData = jsonDecode(value.body);
      print("Len :: ${getJsonLength(value.body)}");
      for (int i = 0; i < getJsonLength(value.body); i++) {
        date.add(jsonData[i]["date"]);
        customerName.add(jsonData[i]["customer_name"]);
        bankDetails.add("${jsonData[i]["bank"]}\n${jsonData[i]["number"]}");
        paymentStatus
            .add("${jsonData[i]["payment_method"]}\n${jsonData[i]["type"]}");
        photo.add(jsonData[i]["bill_photo"]);
        remark.add(jsonData[i]["remark"]);
        total.add(jsonData[i]["total"]);
        setState(() {});
      }
      setState(() {});
    });
  }
}
