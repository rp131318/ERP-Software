import 'dart:convert';

import 'package:erp_software/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../globalVariable.dart';

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

  var name = [];
  var address = [];
  var date = [];
  var phoneNumber = [];
  var email = [];
  var gst = [];
  var designation = [];
  var title = [
    "Sr. No.",
    "Name",
    "Address",
    "Phone Number",
    "Email",
    "Designation",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                          label: Text(title[index].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold)));
                    }),
                    rows: List.generate(
                        name.length, (index) => _getDataRow(index)),
                  ),
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
        DataCell(Text("${address[index]}")),
        DataCell(Text("${phoneNumber[index]}")),
        DataCell(Text("${email[index]}")),
        DataCell(Text("${designation[index]}")),
      ],
    );
  }

  void getCustomer() {
    name.clear();
    address.clear();
    phoneNumber.clear();
    email.clear();
    designation.clear();
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
        setState(() {
          // isLoading = false;
        });
      }
      setState(() {});
    });
  }
}
