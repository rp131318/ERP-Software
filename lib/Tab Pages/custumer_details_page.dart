import 'dart:convert';
import 'package:erp_software/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../globalVariable.dart';
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
  String dateString = "DD-MM-YYYY";
  String totalCustomer = "0";
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
        DataCell(Text("${index + 1}")),
        DataCell(Text("${name[index]}")),
        DataCell(Text("${address[index]}")),
        DataCell(Text("${phoneNumber[index]}")),
        DataCell(Text("${email[index]}")),
        DataCell(Text("${gst[index]}")),
        DataCell(Text("${state[index]}")),
        DataCell(Text("${city[index]}")),
        DataCell(Text("${company[index]}")),
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

      totalCustomer = getJsonLength(value.body).toString();

      for (int i = 0; i < getJsonLength(value.body); i++) {
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
