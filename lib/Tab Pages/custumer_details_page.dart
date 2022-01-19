import 'dart:convert';
import 'dart:developer';
import 'package:erp_software/Widgets/button_widget.dart';
import 'package:erp_software/Widgets/delete_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../globalVariable.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustumerDetailsPage extends StatefulWidget {
  @override
  _CustumerDetailsPageState createState() => _CustumerDetailsPageState();
}

class _CustumerDetailsPageState extends State<CustumerDetailsPage> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final dateController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final gstNUmberController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final companyNameController = TextEditingController();
  final updateDataController = TextEditingController();
  String dateString = "DD-MM-YYYY";
  String totalCustomer = "0";
  var id = [];
  var name = [];
  var address = [];
  var date = [];
  var phoneNumber = [];
  var email = [];
  var gst = [];
  var state = [];
  var city = [];
  var company = [];
  var title = [
    "Sr. No.",
    "Name",
    "Address",
    "Phone Number",
    "Email",
    "GST",
    "State",
    "City",
    "Company",
    "Date"
  ];
  var _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  int incre = 0;
  bool apiCall = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomer();

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
          getCustomer(false);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: DraggableScrollbar.rrect(
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 18, left: 18),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Customer Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 144),
                    child: titleTextField("Customer Name", nameController),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 144),
                    child: titleTextField("Address", addressController),
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
                          margin: EdgeInsets.only(left: 18, right: 18, top: 6),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 14),
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
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(0),
                                                bottomRight:
                                                    Radius.circular(0))),
                                        margin:
                                            EdgeInsets.only(left: 0, right: 0),
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 144),
                    child:
                        titleTextField("Phone Number", phoneNumberController),
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
                    child: titleTextField("Email", emailController),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 144),
                    child: titleTextField("GST Number", gstNUmberController),
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
                    child: titleTextField("State", stateController),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 144),
                    child: titleTextField("City", cityController),
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
                    child:
                        titleTextField("Company Name", companyNameController),
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
                  function: () async {
                    final body = {
                      "name": "${nameController.text}",
                      "date": "$dateString",
                      "gst": "${gstNUmberController.text}",
                      "address": "${addressController.text}",
                      "phone": "${phoneNumberController.text}",
                      "email": "${emailController.text}",
                      "state": "${stateController.text}",
                      "comname": "${companyNameController.text}",
                      "city": "${cityController.text}",
                    };
                    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.postCustomer);
                    print("URL :: $url");

                    // $name = $_POST['name'];
                    // $date = $_POST['date'];
                    // $gst_number = $_POST['gst'];
                    // $address = $_POST['address'];
                    // $phone_number = $_POST['phone'];
                    // $email = $_POST['email'];

                    await post(url, body: jsonEncode(body)).then((value) {
                      print("Value :: ${value.body}");
                      if (value.body.toString() == "done") {
                        nameController.clear();
                        gstNUmberController.clear();
                        addressController.clear();
                        phoneNumberController.clear();
                        emailController.clear();
                        stateController.clear();
                        companyNameController.clear();
                        cityController.clear();
                        showSnackbar(context, "Customer Added Successfully.",
                            Colors.green);
                        getCustomer();
                      } else {
                        showSnackbar(
                            context, "Something went incorrect.", Colors.red);
                      }
                    });
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
                  "Customer Details",
                  style: TextStyle(
                      fontSize: 18,
                      color: colorBlack5,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 6),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Total Customer $totalCustomer",
                  style: TextStyle(fontSize: 16, color: colorBlack5),
                ),
              ),
            ),
            name.length > 0
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 22, left: 0, right: 14),
                      child: FittedBox(
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
                    padding: const EdgeInsets.only(top: 88),
                    child: loadingWidget("No Customer Found"),
                  ),
          ],
        ),
      ),
    );
  }

  // "Sr. No.",
  // "Name",
  // "Address",
  // "Phone Number",
  // "Email",
  // "GST",
  // "Date"
  DataRow _getDataRow(index) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Row(
          children: [
            DeleteButton(
              function: () {
                showDeleteDialog(index);
              },
            ),
            Text("${index + 1}")
          ],
        )),
        DataCell(Text("${name[index]}"), showEditIcon: true, onTap: () {
          showUpdateDialog(index, "Name");
        }),
        DataCell(Text("${address[index]}"), showEditIcon: true, onTap: () {
          showUpdateDialog(index, "Address");
        }),
        DataCell(Text("${phoneNumber[index]}"), showEditIcon: true, onTap: () {
          showUpdateDialog(index, "Phone Number");
        }),
        DataCell(Text("${email[index]}"), showEditIcon: true, onTap: () {
          showUpdateDialog(index, "Email");
        }),
        DataCell(Text("${gst[index]}"), showEditIcon: true, onTap: () {
          showUpdateDialog(index, "GST No.");
        }),
        DataCell(Text("${state[index]}"), showEditIcon: true, onTap: () {
          showUpdateDialog(index, "State");
        }),
        DataCell(Text("${city[index]}"), showEditIcon: true, onTap: () {
          showUpdateDialog(index, "City");
        }),
        DataCell(Text("${company[index]}"), showEditIcon: true, onTap: () {
          showUpdateDialog(index, "Company");
        }),
        DataCell(Text("${date[index]}")),
      ],
    );
  }

  Future<void> getCustomer([bool condition = true]) async {
    if (condition) {
      name.clear();
      address.clear();
      gst.clear();
      date.clear();
      phoneNumber.clear();
      email.clear();
      state.clear();
      city.clear();
      id.clear();
      company.clear();
    }
    setState(() {});
    Uri url = Uri.parse(APIUrl.mainUrl +
        APIUrl.getCustomer +
        "?start=${0 + incre}&end=${20 + incre}");
    await get(url).then((value) {
      log("Customer :: ${value.body}");
      final jsonData = jsonDecode(value.body);
      print("Len :: ${getJsonLength(value.body)}");

      for (int i = 0; i < getJsonLength(value.body); i++) {
        id.add(jsonData[i]["id"]);
        name.add(jsonData[i]["name"]);
        address.add(jsonData[i]["address"]);
        gst.add(jsonData[i]["gst"]);
        date.add(jsonData[i]["date"]);
        phoneNumber.add(jsonData[i]["phone_number"]);
        email.add(jsonData[i]["email"]);
        state.add(jsonData[i]["state"]);
        city.add(jsonData[i]["city"]);
        company.add(jsonData[i]["com_name"]);
        setState(() {
          totalCustomer = name.length.toString();
          apiCall = true;
        });
      }
      setState(() {});
    });
    setState(() {
      apiCall = true;
    });
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
                await deleteApi("customer", "${id[index]}");
                showSnackbar(_scaffoldkey.currentContext, "Delete successfully",
                    Colors.green);
                getCustomer();
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void showUpdateDialog(int index, String userField) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Update Details !',
            style: TextStyle(color: Colors.deepOrangeAccent),
          ),
          content: Container(
            child: titleTextField(userField, updateDataController),
            height: double.minPositive + 55,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                var jsonBody = {
                  "id": "${id[index]}",
                  "name": "${name[index]}",
                  "gst_num": "${gst[index]}",
                  "address": "${address[index]}",
                  "state": "${state[index]}",
                  "city": "${city[index]}",
                  "com_name": "${company[index]}",
                  "number": "${phoneNumber[index]}",
                  "email": "${email[index]}",
                  "location": "customer",
                };

                switch (userField) {
                  case "Name":
                    jsonBody = {
                      "id": "${id[index]}",
                      "name": "${updateDataController.text}",
                      "gst_num": "${gst[index]}",
                      "address": "${address[index]}",
                      "state": "${state[index]}",
                      "city": "${city[index]}",
                      "com_name": "${company[index]}",
                      "number": "${phoneNumber[index]}",
                      "email": "${email[index]}",
                      "location": "customer",
                    };
                    break;
                  case "Address":
                    jsonBody = {
                      "id": "${id[index]}",
                      "name": "${name[index]}",
                      "gst_num": "${gst[index]}",
                      "address": "${updateDataController.text}",
                      "state": "${state[index]}",
                      "city": "${city[index]}",
                      "com_name": "${company[index]}",
                      "number": "${phoneNumber[index]}",
                      "email": "${email[index]}",
                      "location": "customer",
                    };
                    break;
                  case "Phone Number":
                    jsonBody = {
                      "id": "${id[index]}",
                      "name": "${name[index]}",
                      "gst_num": "${gst[index]}",
                      "address": "${address[index]}",
                      "state": "${state[index]}",
                      "city": "${city[index]}",
                      "com_name": "${company[index]}",
                      "number": "${updateDataController.text}",
                      "email": "${email[index]}",
                      "location": "customer",
                    };
                    break;
                  case "Email":
                    jsonBody = {
                      "id": "${id[index]}",
                      "name": "${name[index]}",
                      "gst_num": "${gst[index]}",
                      "address": "${address[index]}",
                      "state": "${state[index]}",
                      "city": "${city[index]}",
                      "com_name": "${company[index]}",
                      "number": "${phoneNumber[index]}",
                      "email": "${updateDataController.text}",
                      "location": "customer",
                    };
                    break;
                  case "GST No.":
                    jsonBody = {
                      "id": "${id[index]}",
                      "name": "${name[index]}",
                      "gst_num": "${updateDataController.text}",
                      "address": "${address[index]}",
                      "state": "${state[index]}",
                      "city": "${city[index]}",
                      "com_name": "${company[index]}",
                      "number": "${phoneNumber[index]}",
                      "email": "${email[index]}",
                      "location": "customer",
                    };
                    break;
                  case "State":
                    jsonBody = {
                      "id": "${id[index]}",
                      "name": "${name[index]}",
                      "gst_num": "${gst[index]}",
                      "address": "${address[index]}",
                      "state": "${updateDataController.text}",
                      "city": "${city[index]}",
                      "com_name": "${company[index]}",
                      "number": "${phoneNumber[index]}",
                      "email": "${email[index]}",
                      "location": "customer",
                    };
                    break;
                  case "City":
                    jsonBody = {
                      "id": "${id[index]}",
                      "name": "${name[index]}",
                      "gst_num": "${gst[index]}",
                      "address": "${address[index]}",
                      "state": "${state[index]}",
                      "city": "${updateDataController.text}",
                      "com_name": "${company[index]}",
                      "number": "${phoneNumber[index]}",
                      "email": "${email[index]}",
                      "location": "customer",
                    };
                    break;
                  case "Company":
                    jsonBody = {
                      "id": "${id[index]}",
                      "name": "${name[index]}",
                      "gst_num": "${gst[index]}",
                      "address": "${address[index]}",
                      "state": "${state[index]}",
                      "city": "${city[index]}",
                      "com_name": "${updateDataController.text}",
                      "number": "${phoneNumber[index]}",
                      "email": "${email[index]}",
                      "location": "customer",
                    };
                    break;
                }

                updateDataController.clear();

                await updateApi(jsonBody);

                showSnackbar(_scaffoldkey.currentContext, "Update successfully",
                    Colors.green);
                getCustomer();
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }
}
