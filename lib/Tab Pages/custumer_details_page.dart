import 'dart:convert';

import 'package:dustbin/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../globalVariable.dart';

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

  var name = [];
  var address = [];
  var date = [];
  var phoneNumber = [];
  var email = [];
  var gst = [];
  var title = [
    "Sr. No.",
    "Name",
    "Address",
    "Phone Number",
    "Email",
    "GST",
    "Date"
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
      body: Column(
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
                  child: titleTextField("Date", dateController),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 144),
                  child: titleTextField("Phone Number", phoneNumberController),
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
                    "date": "${dateController.text}",
                    "gst": "${gstNUmberController.text}",
                    "address": "${addressController.text}",
                    "phone": "${phoneNumberController.text}",
                    "email": "${emailController.text}",
                  };
                  Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.postCustomer);
                  print("URL :: $url");

                  // $name = $_POST['name'];
                  // $date = $_POST['date'];
                  // $gst_number = $_POST['gst'];
                  // $address = $_POST['address'];
                  // $phone_number = $_POST['phone'];
                  // $email = $_POST['email'];

                  await post(url, body: body).then((value) {
                    print("Value :: ${value.body}");
                    if (value.body.toString() == "done") {
                      getCustomer();
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
                  rows:
                      List.generate(name.length, (index) => _getDataRow(index)),
                ),
              ),
            ),
          ),
        ],
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
        DataCell(Text("${index + 1}")),
        DataCell(Text("${name[index]}")),
        DataCell(Text("${address[index]}")),
        DataCell(Text("${phoneNumber[index]}")),
        DataCell(Text("${email[index]}")),
        DataCell(Text("${gst[index]}")),
        DataCell(Text("${date[index]}")),
      ],
    );
  }

  void getCustomer() {
    name.clear();
    address.clear();
    gst.clear();
    date.clear();
    phoneNumber.clear();
    email.clear();
    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.getCustomer);
    get(url).then((value) {
      print("Customer :: ${value.body}");
      final jsonData = jsonDecode(value.body);
      print("Len :: ${getJsonLength(value.body)}");

      // 'id'=>$id,
      // 'name'=>$name,
      // 'gst'=>$gst_num,
      // 'address'=>$address,
      // 'date'=>$date,
      // 'phone_number'=>$phone_number,
      // 'email'=>$email,
      //

      for (int i = 0; i < getJsonLength(value.body); i++) {
        name.add(jsonData[i]["name"]);
        address.add(jsonData[i]["address"]);
        gst.add(jsonData[i]["gst"]);
        date.add(jsonData[i]["date"]);
        phoneNumber.add(jsonData[i]["phone_number"]);
        email.add(jsonData[i]["email"]);
        setState(() {
          // isLoading = false;
        });
      }
      setState(() {
        // name.reversed;
        // qnt.reversed;
        // qnt.reversed;
        // qnt.reversed;
      });
    });
  }
}
