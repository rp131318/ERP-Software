import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../globalVariable.dart';
import 'package:url_launcher/url_launcher.dart';

class SalesDetailsPage extends StatefulWidget {
  @override
  _SalesDetailsPageState createState() => _SalesDetailsPageState();
}

class _SalesDetailsPageState extends State<SalesDetailsPage> {
  int currentPage = 0;
  var title = [
    "Sr. No.",
    "Product Name",
    "Customer Name",
    "GST Number",
    "Date",
    "Bill Photo"
  ];
  var name = [];
  var customerName = [];
  var gstNumber = [];
  var date = [];
  var photo = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.clear();
    customerName.clear();
    gstNumber.clear();
    date.clear();
    photo.clear();
    // getPakkaBillDetails();
    // getKacchaBillDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          currentPage == 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: 155,
                        height: 155,
                        margin: EdgeInsets.only(top: 111),
                        padding: EdgeInsets.all(12),
                        color: Color(0xfff2f2f2),
                        child: InkWell(
                          onTap: () {
                            getPakkaBillDetails();
                            setState(() {
                              currentPage = 1;
                            });
                          },
                          child: Column(
                            children: [
                              Icon(Icons.sell_rounded,
                                  size: 66, color: colorBlack5),
                              Text(
                                "Sold Products",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 155,
                        height: 155,
                        margin: EdgeInsets.only(top: 44),
                        padding: EdgeInsets.all(12),
                        color: Color(0xfff2f2f2),
                        child: InkWell(
                          onTap: () {
                            getKacchaBillDetails();
                            setState(() {
                              currentPage = 2;
                            });
                          },
                          child: Column(
                            children: [
                              Icon(Icons.mode_standby_rounded,
                                  size: 66, color: colorBlack5),
                              Text(
                                "Standby Products",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : currentPage == 1
                  ? soldProducts()
                  : standByProducts(),
        ],
      ),
    );
  }

  soldProducts() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 22, bottom: 22, top: 22),
          child: Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      currentPage = 0;
                    });
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 33,
                    color: colorBlack5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 18, left: 18),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Sold Products Details",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
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
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 22, left: 0, right: 14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 28.0,
                columns: List.generate(title.length, (index) {
                  return DataColumn(label: Text(title[index].toString()));
                }),
                rows: List.generate(name.length, (index) => _getDataRow(index)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  standByProducts() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 22, bottom: 22, top: 22),
          child: Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      currentPage = 0;
                    });
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 33,
                    color: colorBlack5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 18, left: 18),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Standby Products Details",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
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
        //       "Standby Products Details",
        //       style: TextStyle(
        //           fontSize: 18,
        //           color: colorBlack5,
        //           fontWeight: FontWeight.bold),
        //     ),
        //   ),
        // ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 22, left: 0, right: 14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 28.0,
                columns: List.generate(title.length, (index) {
                  return DataColumn(label: Text(title[index].toString()));
                }),
                rows: List.generate(name.length, (index) => _getDataRow(index)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // "Product Name","Customer Name","GST Number","Date","Bill Photo"

  DataRow _getDataRow(index) {
    return DataRow(cells: <DataCell>[
      DataCell(Text("${index + 1}")),
      DataCell(Text("${name[index]}")),
      DataCell(Text("${customerName[index]}")),
      DataCell(Text("${gstNumber[index]}")),
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
    ]);
  }

  void getPakkaBillDetails() {
    name.clear();
    customerName.clear();
    gstNumber.clear();
    date.clear();
    photo.clear();
    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.getPakkaBill);
    get(url).then((value) {
      print("Raw Materials :: ${value.body}");
      final jsonData = jsonDecode(value.body);
      print("Len :: ${getJsonLength(value.body)}");
      for (int i = 0; i < getJsonLength(value.body); i++) {
        name.add(jsonData[i]["name"]);
        date.add(jsonData[i]["date"]);
        customerName.add(jsonData[i]["customer_name"]);
        gstNumber.add(jsonData[i]["gst_num"]);
        photo.add(jsonData[i]["bill_photo"]);
        setState(() {});
      }
      setState(() {});
    });
  }

  void getKacchaBillDetails() {
    name.clear();
    customerName.clear();
    gstNumber.clear();
    date.clear();
    photo.clear();
    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.getKacchaBill);
    get(url).then((value) {
      print("Raw Materials :: ${value.body}");
      final jsonData = jsonDecode(value.body);
      print("Len :: ${getJsonLength(value.body)}");
      for (int i = 0; i < getJsonLength(value.body); i++) {
        name.add(jsonData[i]["name"]);
        date.add(jsonData[i]["date"]);
        customerName.add(jsonData[i]["customer_name"]);
        gstNumber.add(jsonData[i]["gst_num"]);
        photo.add(jsonData[i]["bill_photo"]);
        setState(() {});
      }
      setState(() {});
    });
  }
}
