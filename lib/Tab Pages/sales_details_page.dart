import 'dart:convert';
import 'package:erp_software/Widgets/progressHud.dart';
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
    "Customer Name",
    "Total Price",
    "Payment Status",
    "Bank Details",
    "Remark",
    "Date",
    "Bill Photo"
  ];

  // var name = [];
  var customerName = [];
  var paymentStatus = [];
  var bankDetails = [];
  var date = [];
  var photo = [];
  var remark = [];
  var total = [];
  var id = [];

  bool isLoading = false;

  int idOfAdvance = 1;
  String radioButtonItemOfAdvance = "Check";

  final bankNameController = TextEditingController();
  final bankDetailsNumberController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerName.clear();
    paymentStatus.clear();
    bankDetails.clear();
    total.clear();
    date.clear();
    photo.clear();
    remark.clear();
    id.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        isLoading: isLoading,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Stack(
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
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
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
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
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
          ),
        ),
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
        customerName.length > 0
            ? Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 22, left: 0, right: 14),
                  child: DataTable(
                    columnSpacing: 28.0,
                    columns: List.generate(title.length, (index) {
                      return DataColumn(
                          label: Text(title[index].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold)));
                    }),
                    rows: List.generate(
                        customerName.length, (index) => _getDataRow(index, 0)),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 88),
                child: loadingWidget(),
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
        Row(
          children: [
            Expanded(
              child: customerName.length > 0
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 22, left: 0, right: 14),
                        child: DataTable(
                          columnSpacing: 28.0,
                          columns: List.generate(title.length, (index) {
                            return DataColumn(
                                label: Text(title[index].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)));
                          }),
                          rows: List.generate(customerName.length,
                              (index) => _getDataRow(index, 1)),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 88),
                      child: loadingWidget(),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  // "Product Name","Customer Name","GST Number","Date","Bill Photo"

  DataRow _getDataRow(index, int mm) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text("${index + 1}"),
            showEditIcon: (paymentStatus[index].toString().contains("Advance"))
                ? false
                : true, onTap: () {
          // 1 april 2020 31 march 2021
          if (mm == 1) {
            // setState(() {
            //   isLoading = true;
            // });
            // sendToFinalBill(index);
          } else {
            if (!(paymentStatus[index].toString().contains("Advance"))) {
              showPopUp(index);
            }
          }
        }),
        // "Sr. No.",
        // "Customer Name",
        // "Total Price",
        // "Payment Status",
        // "Bank Details",
        // "Remark",
        // "Date",
        // "Bill Photo"
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

  void getPakkaBillDetails() {
    customerName.clear();
    paymentStatus.clear();
    bankDetails.clear();
    total.clear();
    date.clear();
    photo.clear();
    remark.clear();
    id.clear();
    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.getPakkaBill);
    get(url).then((value) {
      print("Raw Materials :: ${value.body}");
      final jsonData = jsonDecode(value.body);
      print("Len :: ${getJsonLength(value.body)}");
      for (int i = 0; i < getJsonLength(value.body); i++) {
        date.add(jsonData[i]["date"]);
        id.add(jsonData[i]["id"]);
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

  void getKacchaBillDetails() {
    customerName.clear();
    date.clear();
    photo.clear();
    remark.clear();
    customerName.clear();
    paymentStatus.clear();
    bankDetails.clear();
    total.clear();
    date.clear();
    photo.clear();
    remark.clear();
    id.clear();
    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.getKacchaBill);
    get(url).then((value) {
      print("Raw Materials :: ${value.body}");
      final jsonData = jsonDecode(value.body);
      print("Len :: ${getJsonLength(value.body)}");
      for (int i = 0; i < getJsonLength(value.body); i++) {
        // name.add(jsonData[i]["name"]);
        date.add(jsonData[i]["date"]);
        id.add(jsonData[i]["id"]);
        customerName.add(jsonData[i]["customer_name"]);
        bankDetails.add("${jsonData[i]["bank"]}\n${jsonData[i]["number"]}");
        paymentStatus
            .add("${jsonData[i]["payment_method"]}\n${jsonData[i]["type"]}");
        photo.add(jsonData[i]["bill_photo"]);
        remark.add(jsonData[i]["remark"]);
        total.add(jsonData[i]["total"]);
        setState(() {});
      }
      setState(() {
        isLoading = false;
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  void sendToFinalBill(index) {
    // send
    final body = {
      "customer_name": "${customerName[index]}",
      "date": "${date[index]}",
      "photo": "${photo[index]}",
      "total": "${total[index]}",
      "remark": "${remark[index]}",
      "payment_method": paymentStatus[index].toString().split("\n")[0],
      "type": radioButtonItemOfAdvance,
      "bank": bankDetails[index].toString().split("\n")[0],
      "number": bankDetails[index].toString().split("\n")[1],
    };

    print("Body :: $body");
    Uri url = Uri.parse(APIUrl.mainUrl + "send_to_pakka.php");
    post(url, body: jsonEncode(body)).then((value) {
      print("postPakkaBill :: ${value.body}");
      // delete
      Uri url = Uri.parse(
          APIUrl.mainUrl + APIUrl.deleteKachaBill + "?id=${id[index]}");
      get(url).then((value) {
        print("postPakkaBill Delete :: ${value.body}");
        getKacchaBillDetails();
      });
    });
  }

  void showPopUp(int index1) {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, _setState) {
              return AlertDialog(
                // title: Text("Simple Alert"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 18, bottom: 0, left: 18),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Payment Method",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        // height: 46,
                        width: 600,
                        decoration: BoxDecoration(
                            color: colorCardWhite,
                            border: Border.all(width: 0.5, color: grey),
                            borderRadius: BorderRadius.circular(8)),
                        margin: EdgeInsets.only(left: 18, right: 18, top: 18),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Radio(
                                  activeColor: colorDark,
                                  value: 1,
                                  groupValue: idOfAdvance,
                                  onChanged: (val) {
                                    _setState(() {
                                      radioButtonItemOfAdvance = 'Check';
                                      idOfAdvance = 1;
                                      // cusPriceV = false;
                                    });
                                  },
                                ),
                                Text(
                                  'Check',
                                  style: new TextStyle(
                                      fontSize: 17.0, color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 22,
                            ),
                            Row(
                              children: [
                                Radio(
                                  activeColor: colorDark,
                                  value: 2,
                                  groupValue: idOfAdvance,
                                  onChanged: (val) {
                                    _setState(() {
                                      radioButtonItemOfAdvance = 'NEFT';
                                      idOfAdvance = 2;
                                      // cusPriceV = false;
                                    });
                                  },
                                ),
                                Text(
                                  'NEFT',
                                  style: new TextStyle(
                                      fontSize: 17.0, color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 22,
                            ),
                            Row(
                              children: [
                                Radio(
                                  activeColor: colorDark,
                                  value: 3,
                                  groupValue: idOfAdvance,
                                  onChanged: (val) {
                                    _setState(() {
                                      radioButtonItemOfAdvance = 'UPI';
                                      idOfAdvance = 3;
                                      // cusPriceV = true;
                                    });
                                  },
                                ),
                                Text(
                                  'UPI',
                                  style: new TextStyle(
                                      fontSize: 17.0, color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 22,
                            ),
                            Row(
                              children: [
                                Radio(
                                  activeColor: colorDark,
                                  value: 4,
                                  groupValue: idOfAdvance,
                                  onChanged: (val) {
                                    _setState(() {
                                      radioButtonItemOfAdvance = 'Cash';
                                      idOfAdvance = 4;
                                      // cusPriceV = true;
                                    });
                                  },
                                ),
                                Text(
                                  'Cash',
                                  style: new TextStyle(
                                      fontSize: 17.0, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 22),
                            child:
                                titleTextField("Bank Name", bankNameController),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 22),
                            child: titleTextField(
                                "$radioButtonItemOfAdvance Number",
                                bankDetailsNumberController),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(22),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Uri url = Uri.parse(APIUrl.mainUrl +
                                  APIUrl.updatePaymentMode +
                                  "?payment_type=$radioButtonItemOfAdvance&bank=${bankNameController.text}&number=${bankDetailsNumberController.text}&id=${id[index1]}");

                              get(url).then((value) {
                                print("Update Payment Mode :: ${value.body}");
                              });
                            },
                            child: Text("Submit")),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
