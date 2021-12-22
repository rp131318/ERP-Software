import 'package:erp_software/Tab%20Pages/raw_material_page.dart';
import 'package:erp_software/Widgets/progressHud.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../globalVariable.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:http/http.dart';
import 'dart:io' as Io;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../globalVariable.dart';

class StandRawMaterials extends StatefulWidget {
  const StandRawMaterials({Key key}) : super(key: key);

  @override
  _StandRawMaterialsState createState() => _StandRawMaterialsState();
}

class _StandRawMaterialsState extends State<StandRawMaterials> {
  var title = [
    "Sr. No.",
    "Name",
    "Quantity",
    "Date",
  ];
  var name = [];
  var qnt = [];
  var partNumber = [];
  var photo = [];
  var date = [];
  var remaining = [];
  var outArray = [];
  var id = [];

  int currentPage = 0;
  int currentQty = 0;
  String currentId = "";
  bool isLoading = false;

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
          ? ProgressHUD(
              isLoading: isLoading,
              child: SingleChildScrollView(
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            // Container(
                            //   height: 26,
                            //   width: 333,
                            //   decoration: BoxDecoration(
                            //       color: Color(0xfff2f2f2),
                            //       // border: Border.all(width: 1, color: grey),
                            //       borderRadius: BorderRadius.circular(0)),
                            //   margin:
                            //   EdgeInsets.only(left: 18, right: 18, top: 6),
                            //   padding: EdgeInsets.only(left: 14),
                            //   child: DropdownButton<String>(
                            //     value: filterDropdown,
                            //     dropdownColor: colorCard,
                            //     elevation: 0,
                            //     underline: Container(),
                            //     icon: Container(),
                            //     onChanged: (String newValue) {
                            //       setState(() {
                            //         filterDropdown = newValue;
                            //       });
                            //
                            //       getData("-", filterDropdown);
                            //     },
                            //     items: filterList.map<DropdownMenuItem<String>>(
                            //             (String value) {
                            //           return DropdownMenuItem<String>(
                            //             value: value,
                            //             child: Text(
                            //               value,
                            //               style: TextStyle(
                            //                   fontSize: 18, color: Colors.black),
                            //             ),
                            //           );
                            //         }).toList(),
                            //   ),
                            // ),
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
                                  rows: List.generate(name.length,
                                      (index) => _getDataRow(index)),
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
              ),
            )
          : RawMaterialPage(),
    );
  }

  DataRow _getDataRow(index) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text("${index + 1}"), showEditIcon: true, onTap: () {
          callApi(index);
        }),
        DataCell(SizedBox(
          width: 200,
          child: Text("${name[index]}"),
        )),
        DataCell(Text("${qnt[index]}")),
        DataCell(Text("${date[index]}")),
      ],
    );
  }

  void getData() {
    name.clear();
    qnt.clear();
    partNumber.clear();
    date.clear();
    outArray.clear();
    remaining.clear();
    DateTime now = DateTime.now();
    String sendDate = "${now.day}-${now.month}-${now.year}";
    Uri url;

    url = Uri.parse(APIUrl.mainUrl + APIUrl.getStandByRaw);

    try {
      print("URL :: $url");
      get(url).then((value) {
        print("Raw Materials Stand By :: ${value.body}");
        final jsonData = jsonDecode(value.body);
        print("Len :: ${getJsonLength(value.body)}");
        for (int i = 0; i < getJsonLength(value.body); i++) {
          name.add(jsonData[i]["name"]);
          qnt.add(jsonData[i]["quantity"]);
          date.add(jsonData[i]["date"]);
          id.add(jsonData[i]["id"]);
          setState(() {});
        }
        setState(() {
          isLoading = false;
        });
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      //
    }
  }

  Future<void> callApi(index) async {
    setState(() {
      isLoading = true;
    });
    Uri url = Uri.parse(
        APIUrl.mainUrl + APIUrl.getRaw + "?type=select&name=${name[index]}");
    print("Url :: $url");
    await get(url).then((value) {
      print("Raw Materials DropDown :: ${value.body}");
      final jsonData = jsonDecode(value.body);
      print("Len :: ${getJsonLength(jsonData)}");
      currentQty = int.parse(jsonData[0]["total"].toString());
      currentId = jsonData[0]["id"].toString();

      print("currentQty :: $currentQty");
      //
      Uri url = Uri.parse(APIUrl.mainUrl +
          APIUrl.updateRawStand +
          "?id=$currentId&qty=${currentQty + int.parse(qnt[index])}");

      get(url).then((value) {
        print("updateRawStand :: ${value.body}");
        Uri url = Uri.parse(
            APIUrl.mainUrl + APIUrl.deleteStandByRaw + "?id=${id[index]}");

        get(url).then((value) {
          print("delete RawStand :: ${value.body}");
        });
        getData();
      });
    });
  }
}
