import 'package:dustbin/Widgets/button_widget.dart';
import 'package:dustbin/Widgets/progressHud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../globalVariable.dart';

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
    "Remark",
  ];
  String nameDropdown = "Select";
  List<String> nameList = [
    "Select",
    "Rahul",
    "Dhruval",
    "Mohit",
    "Manish",
    "Adarsh"
  ];
  var name = ["Rahul"];
  var inDate = ["10:15"];
  var outDate = ["-"];
  var remark = ["-"];

  bool isLoading = false;

  String inDateString = "HH:MM";
  String outDateString = "HH:MM";

  String todayDate = "DD:MM:YYYY";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todayDate =
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        isLoading: isLoading,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 18, left: 18),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Employee Attendance",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                margin: EdgeInsets.only(
                                    left: 18, right: 18, top: 6),
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                    topRight:
                                                        Radius.circular(0),
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
                                                    topRight:
                                                        Radius.circular(0),
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
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: Text(
                                  "Out Time",
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
                                        outDateString,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        splashColor: Colors.white,
                                        onTap: () {
                                          Datefunction(2);
                                        },
                                        child: Container(
                                            width: double.infinity,
                                            height: 46,
                                            decoration: BoxDecoration(
                                                color: colorBlack5,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(0),
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
                        child: titleTextField(
                            "Remark (Optional)", remarkController),
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
                      function: () {
                        //
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
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Employee Attendance",
                      style: TextStyle(
                          fontSize: 18,
                          color: colorBlack5,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 22, left: 0, right: 14),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 28.0,
                        columns: List.generate(title.length, (index) {
                          return DataColumn(
                              label: Text(title[index].toString()));
                        }),
                        rows: List.generate(
                            name.length, (index) => _getDataRow(index)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 44, right: 111),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ButtonWidget(
                  widget: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "images/submit.png",
                      width: 20,
                      height: 20,
                      color: Colors.white,
                    ),
                  ),
                  isIcon: true,
                  context: context,
                  buttonText: "Submit",
                  function: () async {
                    setState(() {
                      isLoading = true;
                    });
                  },
                  left: 0,
                  right: 0,
                  width: 133,
                  height: 33,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _getDataRow(index) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text("${index + 1}")),
        DataCell(Text("${name[index]}")),
        DataCell(Text("${inDate[index]}")),
        DataCell(InkWell(
          onTap: () {
            Datefunction(3, index);
          },
          child: outDate[index] == "-"
              ? Icon(
                  Icons.edit,
                  size: 22,
                )
              : Text("${outDate[index]}"),
        )),
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
        onChanged: (date) {
      print('change $date');
      setState(() {
        if (isInDate == 1) {
          inDateString = "${date.hour}:${date.minute}";
        } else if (isInDate == 2) {
          outDateString = "${date.hour}:${date.minute}";
        } else {
          outDate[ii] = "${date.hour}:${date.minute}";
        }

        // dateString = date.toString().split(" ")[0].toString();
      });
    }, onConfirm: (date) {
      print('confirm $date');
      setState(() {
        if (isInDate == 1) {
          inDateString = "${date.hour}:${date.minute}";
        } else if (isInDate == 2) {
          outDateString = "${date.hour}:${date.minute}";
        } else {
          outDate[ii] = "${date.hour}:${date.minute}";
        }
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }
}
