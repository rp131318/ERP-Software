import 'dart:convert';

import 'package:erp_software/Widgets/button_widget.dart';
import 'package:erp_software/Widgets/delete_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../globalVariable.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class EmplyoeeDetailsPage extends StatefulWidget {
  @override
  _EmplyoeeDetailsPageState createState() => _EmplyoeeDetailsPageState();
}

class _EmplyoeeDetailsPageState extends State<EmplyoeeDetailsPage> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final dateController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final gstNUmberController = TextEditingController();
  final designationController = TextEditingController();
  final employeIdController = TextEditingController();
  final updateDataController = TextEditingController();

  var name = [];
  var address = [];
  var date = [];
  var phoneNumber = [];
  var email = [];
  var gst = [];
  var designation = [];
  var id = [];
  var title = [
    "Sr. No.",
    "Name",
    "Address",
    "Phone Number",
    "Email",
    "Designation",
  ];
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomer();
  }

  final _scrollController = ScrollController();

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
                  "Employee Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 144),
                    child: titleTextField("Name", nameController),
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
                    child: titleTextField("Email", emailController),
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
                    child: titleTextField("Designation", designationController),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 144),
                    child: titleTextField("Employee Id", employeIdController),
                  ),
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
                      "address": "${addressController.text}",
                      "number": "${phoneNumberController.text}",
                      "email": "${emailController.text}",
                      "designation": "${designationController.text}",
                      "emp_id": "${employeIdController.text}"
                    };
                    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.postEmployee);
                    print("URL :: $url");

                    // $name = $_POST['name'];
                    // $address = $_POST['address'];
                    // $number = $_POST['number'];
                    // $email = $_POST['email'];
                    // $designation = $_POST['designation'];

                    await post(url, body: jsonEncode(body)).then((value) {
                      print("Value :: ${value.body}");
                      if (value.body.toString() == "done") {
                        getCustomer();
                        nameController.clear();
                        addressController.clear();
                        phoneNumberController.clear();
                        emailController.clear();
                        designationController.clear();
                        employeIdController.clear();
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
                  "Employee Details",
                  style: TextStyle(
                      fontSize: 18,
                      color: colorBlack5,
                      fontWeight: FontWeight.bold),
                ),
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
                    padding: const EdgeInsets.only(top: 88),
                    child: loadingWidget("No Employee Details Found"),
                  ),
          ],
        ),
      ),
    );
  }

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
            Text("${index + 1}"),
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
        DataCell(Text("${designation[index]}"), showEditIcon: true, onTap: () {
          showUpdateDialog(index, "Designation");
        }),
      ],
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
                  "address": "${address[index]}",
                  "number": "${phoneNumber[index]}",
                  "email": "${email[index]}",
                  "designation": "${designation[index]}",
                  "location": "employee",
                };

                switch (userField) {
                  case "Name":
                    jsonBody = {
                      "id": "${id[index]}",
                      "name": "${updateDataController.text}",
                      "address": "${address[index]}",
                      "number": "${phoneNumber[index]}",
                      "email": "${email[index]}",
                      "designation": "${designation[index]}",
                      "location": "employee",
                    };
                    break;
                  case "Address":
                    jsonBody = {
                      "id": "${id[index]}",
                      "name": "${name[index]}",
                      "address": "${updateDataController.text}",
                      "number": "${phoneNumber[index]}",
                      "email": "${email[index]}",
                      "designation": "${designation[index]}",
                      "location": "employee",
                    };
                    break;
                  case "Phone Number":
                    jsonBody = {
                      "id": "${id[index]}",
                      "name": "${name[index]}",
                      "address": "${address[index]}",
                      "number": "${updateDataController.text}",
                      "email": "${email[index]}",
                      "designation": "${designation[index]}",
                      "location": "employee",
                    };
                    break;
                  case "Email":
                    jsonBody = {
                      "id": "${id[index]}",
                      "name": "${name[index]}",
                      "address": "${address[index]}",
                      "number": "${phoneNumber[index]}",
                      "email": "${updateDataController.text}",
                      "designation": "${designation[index]}",
                      "location": "employee",
                    };
                    break;
                  case "Designation":
                    jsonBody = {
                      "id": "${id[index]}",
                      "name": "${name[index]}",
                      "address": "${address[index]}",
                      "number": "${phoneNumber[index]}",
                      "email": "${updateDataController.text}",
                      "designation": "${updateDataController.text}",
                      "location": "employee",
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
                await deleteApi("employee", "${id[index]}");
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

  void getCustomer() {
    name.clear();
    address.clear();
    phoneNumber.clear();
    email.clear();
    designation.clear();
    id.clear();
    setState(() {});
    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.getEmployee);
    get(url).then((value) {
      print("Customer :: ${value.body}");
      final jsonData = jsonDecode(value.body);
      print("Len :: ${getJsonLength(value.body)}");

      for (int i = 0; i < getJsonLength(value.body); i++) {
        name.add(jsonData[i]["name"]);
        address.add(jsonData[i]["address"]);
        designation.add(jsonData[i]["designation"]);
        phoneNumber.add(jsonData[i]["number"]);
        email.add(jsonData[i]["email"]);
        id.add(jsonData[i]["id"]);
        setState(() {
          // isLoading = false;
        });
      }
      setState(() {});
    });
  }
}
