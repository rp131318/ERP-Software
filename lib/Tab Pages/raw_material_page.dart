import 'dart:convert';
import 'package:erp_software/Tab%20Pages/stand_raw_materials.dart';
import 'package:erp_software/Widgets/button_widget.dart';
import 'package:erp_software/Widgets/progressHud.dart';
import 'package:flutter/material.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:http/http.dart';
import 'dart:io' as Io;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../globalVariable.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class RawMaterialPage extends StatefulWidget {
  @override
  _RawMaterialPageState createState() => _RawMaterialPageState();
}

class _RawMaterialPageState extends State<RawMaterialPage> {
  final controller = TextEditingController();
  final nameController = TextEditingController();
  final qntController = TextEditingController();
  final partNumberController = TextEditingController();
  final dateController = TextEditingController();
  final popUpController = TextEditingController();
  final paymentController = TextEditingController();
  var a = ["a", "b", "c", "d", "e"];
  var title = [
    "Sr. No.",
    "Name",
    "In",
    "Out",
    "Remaining",
    "Part Number",
    "Date",
    "Bill Photo"
  ];
  var name = [];
  var qnt = [];
  var partNumber = [];
  var photo = [];
  var date = [];
  var remaining = [];
  var outArray = [];
  var id = [];
  String filePath = " ";
  Io.File result;
  bool isLoading = false;
  String dateString = "DD-MM-YYYY";
  String filterDropdown = "Today";
  String rawNameDropdown = "Select";
  List<String> filterList = ["All", "Today"];
  List<String> rawNameList = ["Select"];
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  int currentQty = 0;

  int nextPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: nextPage == 0
          ? ProgressHUD(
              isLoading: isLoading,
              child: DraggableScrollbar.rrect(
                controller: _scrollController,
                child: ListView(
                  controller: _scrollController,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 18, bottom: 18, left: 18),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Upload Raw Materials",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 144),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 18),
                                    child: Text(
                                      "Select raw name",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: colorBlack5,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 26,
                                        width: 333,
                                        decoration: BoxDecoration(
                                            color: Color(0xfff2f2f2),
                                            // border: Border.all(width: 1, color: grey),
                                            borderRadius:
                                                BorderRadius.circular(0)),
                                        margin: EdgeInsets.only(
                                            left: 18, right: 6, top: 6),
                                        padding: EdgeInsets.only(left: 14),
                                        child: DropdownButton<String>(
                                          value: rawNameDropdown,
                                          dropdownColor: colorCard,
                                          elevation: 0,
                                          underline: Container(),
                                          icon: Container(),
                                          onChanged: (String newValue) async {
                                            Uri url = Uri.parse(APIUrl.mainUrl +
                                                APIUrl.getRaw +
                                                "?type=select&name=$newValue");
                                            print("Url :: $url");
                                            await get(url).then((value) {
                                              print(
                                                  "Raw Materials DropDown :: ${value.body}");
                                              final jsonData =
                                                  jsonDecode(value.body);
                                              print(
                                                  "Len :: ${getJsonLength(jsonData)}");
                                              currentQty = int.parse(jsonData[0]
                                                      ["total"]
                                                  .toString());

                                              print(
                                                  "currentQty :: $currentQty");
                                            });
                                            setState(() {
                                              rawNameDropdown = newValue;
                                            });
                                          },
                                          items: rawNameList
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 6),
                                        decoration: BoxDecoration(
                                            color: colorBlack5,
                                            // border: Border.all(width: 1, color: grey),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: InkWell(
                                          onTap: () {
                                            AlertDialog alert = AlertDialog(
                                              // title: Text("Simple Alert"),
                                              content: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  titleTextField(
                                                      "Name", popUpController),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 22, top: 12),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        if (validateField(
                                                            context,
                                                            popUpController)) {
                                                          rawNameList.add(
                                                              popUpController
                                                                  .text);
                                                          rawNameDropdown =
                                                              popUpController
                                                                  .text;
                                                          popUpController
                                                              .clear();
                                                          setState(() {});
                                                        }
                                                      },
                                                      child: Text("Ok"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );

                                            // show the dialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              },
                                            );
                                          },
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 144),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 18),
                                    child: Text(
                                      "Date",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: colorBlack5,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 26,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Color(0xfff0f0f0),
                                      borderRadius: BorderRadius.circular(0)),
                                  margin: EdgeInsets.only(
                                      left: 18, right: 18, top: 6),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 14),
                                          child: Text(
                                            dateString,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: InkWell(
                                            splashColor: Colors.white,
                                            onTap: () {
                                              Datefunction();
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                height: 46,
                                                decoration: BoxDecoration(
                                                    color: colorBlack5,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight: Radius
                                                                .circular(0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    0))),
                                                margin: EdgeInsets.only(
                                                    left: 0, right: 0),
                                                child: Center(
                                                    child: Text(
                                                  "Add Date",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ))),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 144),
                            child: titleTextField("Quantity", qntController),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 144),
                            child: titleTextField(
                                "Part Number", partNumberController),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 144),
                            child: titleTextField(
                                "Payment Method", paymentController),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 0, left: 20),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ButtonWidget(
                              context: context,
                              buttonText: "Upload Bill",
                              isIcon: true,
                              widget: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "images/pdf.png",
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              function: () {
                                final file = OpenFilePicker()
                                  ..filterSpecification = {
                                    'PDF Document (*.pdf)': '*.pdf',
                                    // 'Word Document (*.doc)': '*.doc',
                                    // 'All Files': '*.*'
                                  }
                                  ..defaultFilterIndex = 0
                                  ..defaultExtension = 'doc'
                                  ..title = 'Select a document';

                                result = file.getFile();
                                if (result != null) {
                                  print(result.path);
                                  setState(() {
                                    filePath = result.path;
                                  });
                                }
                              },
                              left: 0,
                              right: 0,
                              width: 133,
                              height: 33,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 22,
                        ),
                        Text(
                          filePath,
                          style: TextStyle(
                            fontSize: 14,
                            color: colorBlack5,
                            decoration: TextDecoration.underline,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 166),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: ButtonWidget(
                          context: context,
                          widget: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          isIcon: true,
                          buttonText: "Add",
                          function: () {
                            if (rawNameDropdown == "Select") {
                              showSnackbar(context, "Select raw material name",
                                  Colors.red);
                              return;
                            }

                            if (dateString == "DD-MM-YYYY") {
                              showSnackbar(context, "Select date", Colors.red);
                              return;
                            }

                            if (qntController.text.isEmpty) {
                              showSnackbar(context,
                                  "Enter raw material quantity", Colors.red);
                              return;
                            }

                            if (partNumberController.text.isEmpty) {
                              showSnackbar(context,
                                  "Enter raw material quantity", Colors.red);
                              return;
                            }

                            if (partNumberController.text.isEmpty) {
                              showSnackbar(context,
                                  "Enter raw material quantity", Colors.red);
                              return;
                            }

                            if (filePath.trim().isEmpty) {
                              showSnackbar(context, "Please upload bill photo",
                                  Colors.red);
                              return;
                            }

                            showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Final Submit !',
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                  content: Text(
                                      "Are you sure that you have enter details are correct ?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("No"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        uploadFunction();
                                      },
                                      child: Text("Yes"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          left: 0,
                          right: 0,
                          width: 100,
                          height: 26,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: colorBlack5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Raw Materials Details",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: colorBlack5,
                                  fontWeight: FontWeight.bold),
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
                                if (filterDropdown == "Today") {
                                  getData();
                                } else if (filterDropdown == "All") {
                                  getData(filterDropdown.toLowerCase());
                                } else {
                                  getData("select", filterDropdown);
                                }
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
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 22),
                            child: ButtonWidget(
                                context: context,
                                isIcon: false,
                                width: 166,
                                height: 26,
                                widget: Container(),
                                buttonText: "Stand by raw mt.",
                                function: () {
                                  setState(() {
                                    nextPage = 1;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
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
                  ],
                ),
              ),
            )
          : StandRawMaterials(),
    );
  }

  DataRow _getDataRow(index) {
    return DataRow(
      cells: <DataCell>[
        DataCell(
            Row(
              children: [
                Icon(
                  Icons.home_repair_service_rounded,
                  color: Colors.deepOrangeAccent,
                ),
                SizedBox(
                  width: 12,
                ),
                Text("${index + 1}"),
              ],
            ), onTap: () {
          AlertDialog alert = AlertDialog(
            // title: Text("Simple Alert"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name[index],
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 12,
                ),
                titleTextField("Quantity", popUpController),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 22, top: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        if (validateField(context, popUpController)) {
                          setState(() {
                            isLoading = true;
                          });
                          Uri url = Uri.parse(APIUrl.mainUrl +
                              APIUrl.sendRawStandBy +
                              "?name=${name[index]}&qty=${popUpController.text}");

                          get(url).then((value) {
                            print("sendRawStandBy Raw :: ${value.body}");
                            Uri url = Uri.parse(APIUrl.mainUrl +
                                APIUrl.updateRawStand +
                                "?id=${id[index]}&qty=${int.parse(remaining[index]) - int.parse(popUpController.text)}");

                            get(url).then((value) {
                              print("updateRawStand :: ${value.body}");
                              popUpController.clear();
                              getData("all");
                              filterDropdown = "All";
                            });
                          });
                        }
                        print("Id :: ${id[index]}");
                      },
                      child: Text("Submit"),
                    ),
                  ),
                ),
              ],
            ),
          );

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
        }),
        DataCell(SizedBox(
          width: 200,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  showDeleteDialog(index);
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Text("${name[index]}"),
            ],
          ),
        )),
        DataCell(
          Text("${qnt[index]}"),
        ),
        DataCell(Text("${outArray[index]}")),
        DataCell(Text("${remaining[index]}")),
        DataCell(Text("${partNumber[index]}")),
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

  void showDeleteDialog(int index) {
    print("Index :: $index");
    print("Index :: ${id[index]}");
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Delete !',
            style: TextStyle(color: Colors.red),
          ),
          content: Text("Do you really want to delete?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await deleteApi("raw", "${id[index]}");
                showSnackbar(_scaffoldkey.currentContext, "Delete successfully",
                    Colors.green);
                getData();
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  uploadFunction() async {
    if (rawNameDropdown != "Select" &&
        validateField(context, qntController) &&
        validateField(context, partNumberController)) {
      setState(() {
        isLoading = true;
      });
      final bytes = Io.File('$filePath').readAsBytesSync();

      print("Total :: ${int.parse(qntController.text) + currentQty}");

      String img64 = base64Encode(bytes);
      //upload to Database
      final body = {
        "name": "$rawNameDropdown",
        "part_number": "${partNumberController.text}",
        "quantity": "${qntController.text}",
        "in_date": "$dateString",
        "out": "0",
        "total": "${int.parse(qntController.text) + currentQty}",
        "bill_photo": "$img64",
        "payment": "${paymentController.text}",
      };

      print("Raw Body :: $body");
      Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.uploadRaw);
      print("URL :: $url");

      await post(url, body: jsonEncode(body)).then((value) {
        print("Value :: ${value.body}");
      });
      nameController.clear();
      qntController.clear();
      partNumberController.clear();
      dateController.clear();
      // filterDropdown = "Today";
      setState(() {});
      getData();
    }
  }

  void getData([String type = "date", String _name = "no"]) {
    name.clear();
    qnt.clear();
    partNumber.clear();
    date.clear();
    outArray.clear();
    remaining.clear();
    id.clear();
    setState(() {});
    DateTime now = DateTime.now();
    String sendDate = "${now.day}-${now.month}-${now.year}";
    Uri url;
    if (type == "select") {
      url =
          Uri.parse(APIUrl.mainUrl + APIUrl.getRaw + "?type=$type&name=$_name");
    } else if (type == "all") {
      url = Uri.parse(APIUrl.mainUrl + APIUrl.getRaw + "?type=$type");
    } else {
      url = Uri.parse(
          APIUrl.mainUrl + APIUrl.getRaw + "?type=$type&date=$sendDate");
    }
    try {
      print("URL :: $url");
      get(url).then((value) {
        print("Raw Materials :: ${value.body}");
        final jsonData = jsonDecode(value.body);
        print("Len :: ${getJsonLength(value.body)}");
        for (int i = 0; i < getJsonLength(value.body); i++) {
          if (type != "select") {
            if (!name.contains(jsonData[i]["name"])) {
              name.add(jsonData[i]["name"]);
              qnt.add(jsonData[i]["quantity"]);
              partNumber.add(jsonData[i]["part_number"]);
              date.add(jsonData[i]["in_date"]);
              photo.add(jsonData[i]["bill_photo"]);
              outArray.add(jsonData[i]["out"]);
              remaining.add(jsonData[i]["total"]);
              id.add(jsonData[i]["id"]);
            }
          } else {
            name.add(jsonData[i]["name"]);
            qnt.add(jsonData[i]["quantity"]);
            partNumber.add(jsonData[i]["part_number"]);
            date.add(jsonData[i]["in_date"]);
            photo.add(jsonData[i]["bill_photo"]);
            outArray.add(jsonData[i]["out"]);
            remaining.add(jsonData[i]["total"]);
            id.add(jsonData[i]["id"]);
          }

          setState(() {
            isLoading = false;
          });
        }
        setState(() {});
      });
      Uri url1 = Uri.parse(APIUrl.mainUrl + APIUrl.getRaw + "?type=all");
      get(url1).then((value) {
        print("Raw Materials :: ${value.body}");
        int len = getJsonLength(jsonDecode(value.body));
        final jsonData = jsonDecode(value.body);
        print("Len :: $len");
        for (int i = 0; i < len; i++) {
          setState(() {
            if (!(filterList.contains("${jsonData[i]["name"]}"))) {
              filterList.add(jsonData[i]["name"]);
            }

            if (!(rawNameList.contains("${jsonData[i]["name"]}"))) {
              rawNameList.add(jsonData[i]["name"]);
            }
          });
        }
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      //
    }
  }

  Datefunction() async {
    print("Call");
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        theme: DatePickerTheme(
            headerColor: colorDark,
            containerHeight: 333,
            // backgroundColor: colorCardWhite,
            itemStyle: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16),
            cancelStyle: TextStyle(color: Colors.white, fontSize: 16)),
        minTime: DateTime(DateTime.now().year - 2),
        maxTime: DateTime(DateTime.now().year + 2), onChanged: (date) {
      print('change $date');
      setState(() {
        dateString = "${date.day}-${date.month}-${date.year}";
        // dateString = date.toString().split(" ")[0].toString();
      });
    }, onConfirm: (date) {
      print('confirm $date');
      setState(() {
        dateString = "${date.day}-${date.month}-${date.year}";
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }
}
