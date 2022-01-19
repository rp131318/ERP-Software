import 'dart:convert';
import 'package:erp_software/Widgets/button_widget.dart';
import 'package:erp_software/Widgets/delete_button_widget.dart';
import 'package:erp_software/Widgets/progressHud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../globalVariable.dart';
import 'package:http/http.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key key}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final dateController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final gstNUmberController = TextEditingController();
  final designationController = TextEditingController();
  final remarkController = TextEditingController();

  var title = [
    "Sr. No.",
    "Name",
    "In Time",
    "Out Time",
    "Date",
    "Remark",
  ];
  String nameDropdown = "Select";

  List<String> nameList = [
    "Select",
  ];
  String filterDropdown = "Today";
  List<String> filterList = ["All", "Today"];
  var name = [];
  var inDate = [];
  var outDate = [];
  var remark = [];
  var date = [];
  var id = [];

  bool isLoading = false;

  String inDateString = "HH:MM";
  String outDateString = "HH:MM";

  String todayDate = "DD:MM:YYYY";

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  int incre = 0;
  bool apiCall = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todayDate =
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
    getAttendance();
    _scrollController = ScrollController()
      ..addListener(() {
        // customPrint("offset = ${_scrollController.offset}");
        double defrence = _scrollController.position.maxScrollExtent -
            _scrollController.offset.toDouble();
        print("defrence = $defrence");
        // customPrint("lunchVideoId = ${lunchVideoId.length}");
        if (defrence.toDouble() < 300.0 && apiCall) {
          apiCall = false;
          setState(() {});
          print("offset = ${_scrollController.offset}");
          incre = incre + 20;
          if (filterDropdown == "Today") {
            getAttendance("date", "", false);
          } else if (filterDropdown == "All") {
            getAttendance(filterDropdown.toLowerCase(), "", false);
          } else {
            getAttendance("select", filterDropdown, false);
          }
        }
      });
  }

  var _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: ProgressHUD(
        isLoading: isLoading,
        child: DraggableScrollbar.rrect(
          controller: _scrollController,
          child: ListView(
            controller: _scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18, bottom: 18, left: 18),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Employee Attendance",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                "Select Employee Name",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: colorBlack5,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
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
                                value: nameDropdown,
                                dropdownColor: colorCard,
                                elevation: 0,
                                underline: Container(),
                                icon: Container(),
                                onChanged: (String newValue) {
                                  setState(() {
                                    nameDropdown = newValue;
                                  });
                                },
                                items: nameList.map<DropdownMenuItem<String>>(
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
                            margin:
                                EdgeInsets.only(left: 18, right: 18, top: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 14),
                                    child: Text(
                                      todayDate,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: InkWell(
                                      splashColor: Colors.white,
                                      onTap: () {
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true,
                                            theme: DatePickerTheme(
                                                headerColor: colorDark,
                                                containerHeight: 333,
                                                // backgroundColor: colorCardWhite,
                                                itemStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                                doneStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                                cancelStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16)),
                                            minTime: DateTime(
                                                DateTime.now().year - 2),
                                            maxTime: DateTime(
                                                DateTime.now().year + 2),
                                            onChanged: (date) {
                                          print('change $date');
                                          setState(() {
                                            todayDate =
                                                "${date.day}-${date.month}-${date.year}";
                                            // dateString = date.toString().split(" ")[0].toString();
                                          });
                                        }, onConfirm: (date) {
                                          print('confirm $date');
                                          setState(() {
                                            todayDate =
                                                "${date.day}-${date.month}-${date.year}";
                                          });
                                        },
                                            currentTime: DateTime.now(),
                                            locale: LocaleType.en);
                                      },
                                      child: Container(
                                          width: double.infinity,
                                          height: 46,
                                          decoration: BoxDecoration(
                                              color: colorBlack5,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(0),
                                                  bottomRight:
                                                      Radius.circular(0))),
                                          margin: EdgeInsets.only(
                                              left: 0, right: 0),
                                          child: Center(
                                              child: Text(
                                            "Add Time",
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
                      padding: const EdgeInsets.only(right: 177),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Text(
                                "In Time",
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
                            margin:
                                EdgeInsets.only(left: 18, right: 18, top: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 14),
                                    child: Text(
                                      inDateString,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: InkWell(
                                      splashColor: Colors.white,
                                      onTap: () {
                                        Datefunction(1);
                                      },
                                      child: Container(
                                          width: double.infinity,
                                          height: 46,
                                          decoration: BoxDecoration(
                                              color: colorBlack5,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(0),
                                                  bottomRight:
                                                      Radius.circular(0))),
                                          margin: EdgeInsets.only(
                                              left: 0, right: 0),
                                          child: Center(
                                              child: Text(
                                            "Add Time",
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 144),
                      child:
                          titleTextField("Remark (Optional)", remarkController),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 44,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 166),
                child: Align(
                  alignment: Alignment.topRight,
                  child: ButtonWidget(
                    widget: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    isIcon: true,
                    context: context,
                    buttonText: "Add",
                    function: () async {
                      name.add(nameDropdown);
                      inDate.add(inDateString);
                      outDate.add("-");
                      date.add(todayDate);
                      remark.add(remarkController.text);
                      setState(() {});

                      final body = {
                        "name": "$nameDropdown",
                        "date": "$todayDate",
                        "in_time": "$inDateString",
                        "remark": "${remarkController.text}"
                      };

                      print("Body :: $body");

                      // {
                      //   "name":"sohaib",
                      // "in_time":"12",
                      // "date":"fdfdsfd",
                      // "remark":"dsfd"
                      // }
                      remarkController.clear();
                      Uri url =
                          Uri.parse(APIUrl.mainUrl + APIUrl.postAttendance);
                      print("Link :: $url");
                      await post(url, body: jsonEncode(body)).then((value) {
                        print("Value :: ${value.body}");
                      });
                      // https://breathemedicalsystems.com/inventory_management/attendence_post.php
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
                        "Employee Attendance",
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
                      margin: EdgeInsets.only(left: 18, right: 18, top: 6),
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
                            getAttendance();
                          } else if (filterDropdown == "All") {
                            getAttendance(filterDropdown.toLowerCase());
                          } else {
                            getAttendance("select", filterDropdown);
                          }
                        },
                        items: filterList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              name.length > 0
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 22, left: 0, right: 14),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 28.0,
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
            ],
          ),
        ),
      ),
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
                await deleteApi("attendence", "${id[index]}");
                showSnackbar(_scaffoldkey.currentContext, "Delete successfully",
                    Colors.green);
                getAttendance();
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  DataRow _getDataRow(index) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text("${index + 1}")),
        DataCell(Row(
          children: [
            DeleteButton(
              function: () {
                showDeleteDialog(index);
              },
            ),
            Text("${name[index]}"),
          ],
        )),
        DataCell(Text("${inDate[index]}")),
        DataCell(InkWell(
          onTap: () {
            Datefunction(3, index);
          },
          child: outDate[index].toString().isEmpty
              ? Icon(
                  Icons.edit,
                  size: 22,
                )
              : Text("${outDate[index]}"),
        )),
        DataCell(Text("${date[index]}")),
        DataCell(Text("${remark[index]}")),
      ],
    );
  }

  Datefunction(int isInDate, [int ii = 0]) async {
    print("Call");
    DatePicker.showTimePicker(context,
        showTitleActions: true,
        showSecondsColumn: false,
        theme: DatePickerTheme(
            headerColor: colorDark,
            containerHeight: 333,
            // backgroundColor: colorCardWhite,
            itemStyle: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16),
            cancelStyle: TextStyle(color: Colors.white, fontSize: 16)),
        onChanged: (_date) {
      print('change $_date');
      setState(() {
        if (isInDate == 1) {
          inDateString = "${_date.hour}:${_date.minute}";
        } else if (isInDate == 2) {
          outDateString = "${_date.hour}:${_date.minute}";
        } else {
          outDate[ii] = "${_date.hour}:${_date.minute}";
          Uri url = Uri.parse(APIUrl.mainUrl +
              APIUrl.updateAttendance +
              "?name=${name[ii]}&date=${date[ii]}&out_time=${outDate[ii]}");
          get(url).then((value) {
            print("Out Time :: ${value.body}");
          });
        }

        // dateString = date.toString().split(" ")[0].toString();
      });
    }, onConfirm: (_date) {
      print('confirm $_date');
      setState(() {
        if (isInDate == 1) {
          inDateString = "${_date.hour}:${_date.minute}";
        } else if (isInDate == 2) {
          outDateString = "${_date.hour}:${_date.minute}";
        } else {
          outDate[ii] = "${_date.hour}:${_date.minute}";
          Uri url = Uri.parse(APIUrl.mainUrl +
              APIUrl.updateAttendance +
              "?name=${name[ii]}&date=${date[ii]}&out_time=${outDate[ii]}");
          get(url).then((value) {
            print("Out Time :: ${value.body}");
            // final jsonData = jsonDecode(value.body);
            // print("Len :: ${getJsonLength(value.body)}");
            // setState(() {});
          });
        }
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  void getAttendance(
      [String type = "date", String _name = "", bool condition = true]) {
    if (condition) {
      name.clear();
      date.clear();
      inDate.clear();
      outDate.clear();
      remark.clear();
      id.clear();
    }
    setState(() {});
    DateTime now = DateTime.now();
    String sendDate = "${now.day}-${now.month}-${now.year}";
    Uri url;
    // if (type == "date") {
    //   url = Uri.parse(
    //       APIUrl.mainUrl + APIUrl.getAttendance + "?type=$type&date=$sendDate");
    // } else {
    //   url = Uri.parse(APIUrl.mainUrl + APIUrl.getAttendance + "?type=$type");
    // }

    if (type == "select") {
      url = Uri.parse(APIUrl.mainUrl +
          APIUrl.getAttendance +
          "?type=$type&name=$_name&start=${incre + 0}&end=${incre + 20}");
    } else if (type == "all") {
      url = Uri.parse(APIUrl.mainUrl +
          APIUrl.getAttendance +
          "?type=$type&start=${incre + 0}&end=${incre + 20}");
    } else {
      url = Uri.parse(APIUrl.mainUrl +
          APIUrl.getAttendance +
          "?type=$type&date=$sendDate&start=${incre + 0}&end=${incre + 20}");
    }

    get(url).then((value) {
      print("Raw Materials :: ${value.body}");
      final jsonData = jsonDecode(value.body);
      print("Len :: ${getJsonLength(value.body)}");
      for (int i = 0; i < getJsonLength(value.body); i++) {
        name.add(jsonData[i]["name"]);
        date.add(jsonData[i]["date"]);
        inDate.add(jsonData[i]["in_time"]);
        outDate.add(jsonData[i]["out_time"]);
        remark.add(jsonData[i]["remark"]);
        id.add(jsonData[i]["id"]);
        setState(() {
          apiCall = true;
        });
      }
      setState(() {
        apiCall = true;
      });
    });
    url = Uri.parse(APIUrl.mainUrl + APIUrl.getEmployee);
    get(url).then((value) {
      print("Raw Materials :: ${value.body}");
      final jsonData = jsonDecode(value.body);
      print("Len :: ${getJsonLength(value.body)}");
      for (int i = 0; i < getJsonLength(value.body); i++) {
        if (!filterList.contains(jsonData[i]["name"])) {
          filterList.add(jsonData[i]["name"]);
        }
        if (!nameList.contains(jsonData[i]["name"])) {
          nameList.add(jsonData[i]["name"]);
        }
        setState(() {
          apiCall = true;
        });
      }
      setState(() {
        apiCall = true;
      });
    });
  }
}
