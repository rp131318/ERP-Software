import 'dart:convert';
import 'dart:developer';
import 'package:erp_software/Widgets/button_widget.dart';
import 'package:erp_software/Widgets/delete_button_widget.dart';
import 'package:erp_software/Widgets/progressHud.dart';
import 'package:flutter/material.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import '../globalVariable.dart';
import 'package:http/http.dart';
import 'dart:io' as Io;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class FinishProductPage extends StatefulWidget {
  @override
  _FinishProductPageState createState() => _FinishProductPageState();
}

class _FinishProductPageState extends State<FinishProductPage> {
  final qntController = TextEditingController();
  final controller = TextEditingController();
  final nameController = TextEditingController();
  final serialNumberController = TextEditingController();
  final finishQntController = TextEditingController();
  final dateController = TextEditingController();
  final hsnCodeController = TextEditingController();
  final _scrollController = ScrollController();
  final _scrollController1 = ScrollController();
  int currentPage = 0;
  String rawMaterialDropdown = "Select";
  String finishProductDropdown = "Select";
  var title = ["Sr. No.", "Name", "Quantity"];
  var title1 = ["Sr. No.", "Name", "Quantity", "Date", "Bill Photo"];
  String dateString = "DD-MM-YYYY";
  var name = [];
  var finishProductName = [];
  var finishProductRawData = [];
  var idOfFinishDetails = [];
  var qnt = [];
  var date = [];
  var finishQnt = [];
  var srNo = [];
  var photo = [];
  bool isLoading = false;
  var rawMaterialNameDatabase = [];
  var rawMaterialQntDatabase = [];
  var jsonDataOfProductName;
  bool allAttemptDone = true;
  int currentStockNumber = 0;
  String filePath = " ";
  List<String> rawMaterialList = [
    "Select",
  ];

  List<String> finishProductList = [
    "Select",
  ];

  var rawMaterialShowDataName = [];
  var rawMaterialShowDataQnt = [];

  String filterDropdown = "Today";
  List<String> filterList = ["All", "Today"];
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  int kmk = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRawMaterials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: ProgressHUD(
        isLoading: isLoading,
        child: currentPage == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 122,
                      height: 122,
                      margin: EdgeInsets.only(top: 111),
                      padding: EdgeInsets.all(12),
                      color: Color(0xfff2f2f2),
                      child: InkWell(
                        onTap: () {
                          if (userAccess != "sales") {
                            setState(() {
                              currentPage = 1;
                            });
                          } else {
                            showSnackbar(
                                context,
                                "You don't has permission to access this feature",
                                Colors.red,
                                1000);
                          }
                        },
                        child: Column(
                          children: [
                            Icon(Icons.note_add_rounded,
                                size: 66, color: colorBlack5),
                            Text(
                              "Add New",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 122,
                      height: 122,
                      margin: EdgeInsets.only(top: 44),
                      padding: EdgeInsets.all(12),
                      color: Color(0xfff2f2f2),
                      child: InkWell(
                        onTap: () {
                          getAllProductsName();
                          getAllFinalProducts();
                          setState(() {
                            currentPage = 2;
                          });
                        },
                        child: Column(
                          children: [
                            Icon(Icons.add_business_rounded,
                                size: 66, color: colorBlack5),
                            Text(
                              "Add Final",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 122,
                      height: 122,
                      margin: EdgeInsets.only(top: 44),
                      padding: EdgeInsets.all(12),
                      color: Color(0xfff2f2f2),
                      child: InkWell(
                        onTap: () {
                          if (userAccess != "sales") {
                            getAllProductsName();
                            setState(() {
                              currentPage = 3;
                            });
                          } else {
                            showSnackbar(
                                context,
                                "You don't has permission to access this feature",
                                Colors.red,
                                1000);
                          }
                        },
                        child: Column(
                          children: [
                            Icon(Icons.youtube_searched_for_rounded,
                                size: 66, color: colorBlack5),
                            Text(
                              "Details",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : currentPage == 1
                ? addNewFinishProduct()
                : currentPage == 2
                    ? addFinalFinishProduct()
                    : viewFinishProduct(),
      ),
    );
  }

  uploadFunction() {
    if (validateField(context, nameController) &&
        validateField(context, qntController)) {
      name.add(rawMaterialDropdown);
      qnt.add(qntController.text);
      // nameController.clear();
      qntController.clear();
      setState(() {});
    }
  }

  addNewFinishProduct() {
    return Stack(
      children: [
        DraggableScrollbar.rrect(
          controller: _scrollController1,
          child: ListView(
            controller: _scrollController1,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18, bottom: 18, top: 18),
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
                        padding: const EdgeInsets.only(
                            top: 18, bottom: 18, left: 18),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Add New Finish Products",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 177),
                      child:
                          titleTextField("Enter Product Name", nameController),
                    ),
                  ),
                  Expanded(
                    child: Container(),
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
                                "Select Raw Material",
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
                                value: rawMaterialDropdown,
                                dropdownColor: colorCard,
                                elevation: 0,
                                underline: Container(),
                                icon: Container(),
                                onChanged: (String newValue) {
                                  setState(() {
                                    rawMaterialDropdown = newValue;
                                  });
                                },
                                items: rawMaterialList
                                    .map<DropdownMenuItem<String>>(
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
                      child: titleTextField("Quantity", qntController),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 22,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 160),
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
                    function: uploadFunction,
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
              Align(
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
                        name.length, (index) => _getDataRow(index)),
                  ),
                ),
              ),
            ],
          ),
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
                String rawData = "";
                for (int i = 0; i < name.length; i++) {
                  rawData = rawData + name[i] + "_" + qnt[i] + "}";
                }
                print("rawData :: $rawData");
                final body = {
                  "name": "${nameController.text}",
                  "raw_data": "$rawData",
                };
                Uri url =
                    Uri.parse(APIUrl.mainUrl + APIUrl.uploadFinishLinkRaw);
                print("URL :: $url");

                // $name = $_POST['name'];
                // $raw_data = $_POST['raw_data'];

                await post(url, body: jsonEncode(body)).then((value) {
                  print("Value :: ${value.body}");
                  if (value.body.toString() == "done") {
                    setState(() {
                      isLoading = false;
                    });
                    showSnackbar(
                        context,
                        "${nameController.text} added successfully",
                        Colors.green);
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    showSnackbar(context, "${value.body}", Colors.red);
                  }
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
    );
  }

  DataRow _getDataRow(index) {
    return DataRow(
      cells: <DataCell>[
        // DataCell(Text(result[0].toString())),
        DataCell(Text("${index + 1}")),
        DataCell(Text("${name[index]}")),
        DataCell(Text("${qnt[index]}")),
      ],
    );
  }

  DataRow _getDataRow1(index) {
    return DataRow(
      cells: <DataCell>[
        // DataCell(Text(result[0].toString())),
        DataCell(Text("${index + 1}")),
        DataCell(Text("${finishProductName[index]}")),
        DataCell(Text("${finishQnt[index]}")),
        // DataCell(Text("${srNo[index]}")),
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

  addFinalFinishProduct() {
    return Stack(
      children: [
        DraggableScrollbar.rrect(
          controller: _scrollController,
          child: ListView(
            controller: _scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18, bottom: 18, top: 18),
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
                        padding: const EdgeInsets.only(
                            top: 18, bottom: 18, left: 18),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Add Finish Products",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: userAccess != "sales" ? true : false,
                child: Column(
                  children: [
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
                                      "Select Product Name",
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
                                      value: finishProductDropdown,
                                      dropdownColor: colorCard,
                                      elevation: 0,
                                      underline: Container(),
                                      icon: Container(),
                                      onChanged: (String newValue) {
                                        //call API
                                        Uri url = Uri.parse(APIUrl.mainUrl +
                                            APIUrl.rawMaterialUsed +
                                            "?name=$newValue");
                                        get(url).then((value) {
                                          print(
                                              "Raw Materials Details :: ${value.body}");
                                          rawMaterialNameDatabase.clear();
                                          rawMaterialQntDatabase.clear();
                                          var temp =
                                              value.body.toString().split("}");
                                          temp.remove("");
                                          for (int i = 0;
                                              i < temp.length;
                                              i++) {
                                            rawMaterialNameDatabase.add(temp[i]
                                                .toString()
                                                .split("_")[0]);
                                            rawMaterialQntDatabase.add(
                                                int.parse(temp[i]
                                                    .toString()
                                                    .split("_")[1]));
                                          }
                                          print(
                                              "rawMaterialNameDatabase :: $rawMaterialNameDatabase");
                                          print(
                                              "rawMaterialQntDatabase :: $rawMaterialQntDatabase");
                                        });

                                        url = Uri.parse(APIUrl.mainUrl +
                                            APIUrl.getFinalProduct +
                                            "?type=name&name=$newValue");

                                        get(url).then((value) {
                                          print(
                                              "Finish Product Details :: ${value.body}");
                                          int len = getJsonLength(
                                              jsonDecode(value.body));
                                          final jsonData =
                                              jsonDecode(value.body);
                                          print("Len :: $len");

                                          currentStockNumber = int.parse(
                                              jsonData[0]["quantity"]
                                                  .toString());
                                          print(
                                              "currentStockNumber :: $currentStockNumber");
                                        });

                                        setState(() {
                                          finishProductDropdown = newValue;
                                        });
                                      },
                                      items: finishProductList
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
                            padding: const EdgeInsets.only(right: 177),
                            child:
                                titleTextField("Quantity", finishQntController),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 144),
                            child: titleTextField("HSN/SAC", hsnCodeController),
                          ),
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
                              widget: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "images/pdf.png",
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              isIcon: true,
                              context: context,
                              buttonText: "PO Upload",
                              function: () {
                                final file = OpenFilePicker()
                                  ..filterSpecification = {
                                    'Word Document (*.doc)': '*.doc',
                                    'Web Page (*.htm; *.html)': '*.htm;*.html',
                                    'Text Document (*.txt)': '*.txt',
                                    'All Files': '*.*'
                                  }
                                  ..defaultFilterIndex = 0
                                  ..defaultExtension = 'doc'
                                  ..title = 'Select a document';

                                final result = file.getFile();
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
                  ],
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
                        "Finish Product Details",
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
                            getAllFinalProducts();
                          } else if (filterDropdown == "All") {
                            getAllFinalProducts("all");
                          } else {
                            getAllFinalProducts("name", filterDropdown);
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
              finishProductName.length > 0
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 22, left: 0, right: 14),
                        child: DataTable(
                          columnSpacing: 28.0,
                          columns: List.generate(title1.length, (index) {
                            return DataColumn(
                                label: Text(title1[index].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)));
                          }),
                          rows: List.generate(finishProductName.length,
                              (index) => _getDataRow1(index)),
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
        Visibility(
          visible: userAccess != "sales" ? true : false,
          child: Padding(
            padding: const EdgeInsets.only(right: 111, bottom: 44),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ButtonWidget(
                widget: Image.asset(
                  "images/submit.png",
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
                isIcon: true,
                context: context,
                buttonText: "Submit",
                function: () async {
                  if (finishProductDropdown == "Select") {
                    showSnackbar(
                        context, "Select finish product name", Colors.red);
                    return;
                  }
                  try {
                    if (validateField(context, finishQntController) &&
                        validateField(context, hsnCodeController)) {
                      if (filePath.trim().isEmpty) {
                        showSnackbar(context, "Please upload PO", Colors.red);
                        return;
                      }
                      if (dateString == "DD-MM-YYYY") {
                        showSnackbar(context, "Select date", Colors.red);
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });
                      // for (int im = 0;
                      //     im < int.parse(finishQntController.text);
                      //     im++) {
                      for (int i = 0; i < rawMaterialNameDatabase.length; i++) {
                        Uri url = Uri.parse(APIUrl.mainUrl +
                            APIUrl.availableRaw +
                            "?name=${rawMaterialNameDatabase[i]}&date=$dateString");
                        await get(url).then((value) async {
                          print("Raw Materials :: ${value.body}");

                          if (value.body.contains("Error description")) {
                            //again

                            for (kmk = 0; kmk < 365; kmk++) {
                              DateTime newDate = DateTime(
                                      int.parse(dateString.split("-")[2]),
                                      int.parse(dateString.split("-")[1]),
                                      int.parse(dateString.split("-")[0]))
                                  .subtract(Duration(days: kmk));

                              Uri url = Uri.parse(APIUrl.mainUrl +
                                  APIUrl.availableRaw +
                                  "?name=${rawMaterialNameDatabase[i]}&date=${newDate.day}-${newDate.month}-${newDate.year}");
                              print("Error description Url :: $url");

                              await get(url).then((value) {
                                if (!(value.body
                                    .contains("Error description"))) {
                                  kmk = 400;
                                  // allAttemptDone = false;
                                  print(
                                      "value.body of function 1 :: ${value.body}");
                                  function1(
                                      value.body,
                                      (int.parse(rawMaterialQntDatabase[i]
                                                  .toString()) *
                                              int.parse(
                                                  finishQntController.text))
                                          .toString(),
                                      rawMaterialNameDatabase[i],
                                      "${newDate.day}-${newDate.month}-${newDate.year}");
                                }
                              });

                              if (kmk == 364) {
                                function1(
                                    "0",
                                    (int.parse(rawMaterialQntDatabase[i]
                                                .toString()) *
                                            int.parse(finishQntController.text))
                                        .toString(),
                                    rawMaterialNameDatabase[i],
                                    "${newDate.day}-${newDate.month}-${newDate.year}");
                              }
                              //
                            }
                          } else {
                            // print("value.body :: ${value.body}");
                            // print(
                            //     "Value 1 :: ${int.parse(rawMaterialQntDatabase[i].toString())}");
                            // print(
                            //     "Value 2 :: ${int.parse(qntController.text).toString()}");
                            // print(
                            //     "Mult 1 :: ${(int.parse(rawMaterialQntDatabase[i].toString()) * int.parse(qntController.text)).toString()}");
                            //
                            // print(
                            //     "rawMaterialNameDatabase[i] :: ${rawMaterialNameDatabase[i]}");
                            // print("dateString :: ${dateString}");

                            function1(
                                value.body.toString(),
                                (int.parse(rawMaterialQntDatabase[i]
                                            .toString()) *
                                        int.parse(finishQntController.text))
                                    .toString(),
                                rawMaterialNameDatabase[i],
                                "$dateString");
                          }
                          if (i == rawMaterialNameDatabase.length - 1) {
                            // if (im == int.parse(finishQntController.text) - 1) {
                            await Future.delayed(const Duration(seconds: 2),
                                () {
                              String img64;
                              if (filePath != " ") {
                                final bytes =
                                    Io.File('$filePath').readAsBytesSync();
                                img64 = base64Encode(bytes);
                              }

                              //upload to Database

                              final body = {
                                "name": "$finishProductDropdown",
                                "serial_number": "no data",
                                "quantity":
                                    "${int.parse(finishQntController.text) + currentStockNumber}",
                                "in_date": "$dateString",
                                "bill_photo": "$img64",
                                "hsn": "${hsnCodeController.text}",
                              };

                              Uri url = Uri.parse(
                                  APIUrl.mainUrl + APIUrl.finalProductUpload);
                              post(url, body: jsonEncode(body)).then((value) {
                                print("finalProductUpload :: ${value.body}");

                                getAllFinalProducts();
                              });
                            });
                            // }
                          }
                        });
                      }
                      // }
                      date.add(dateString);
                      finishQnt.add(finishQntController.text);
                      srNo.add(serialNumberController.text);
                      setState(() {});
                    }
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    print("Error Message :: $e");
                    showSnackbar(
                        context, "Some unknown error has occur.", Colors.red);
                  }
                },
                left: 0,
                right: 0,
                width: 133,
                height: 33,
              ),
            ),
          ),
        ),
      ],
    );
  }

  viewFinishProduct() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, bottom: 18, top: 18),
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
                      "Finish Products Details",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 22),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Product Name",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  "Raw Materials Used",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
        ),
        Visibility(
          visible: finishProductRawData.length > 0 ? false : true,
          child: Padding(
            padding: const EdgeInsets.only(top: 111),
            child: loadingWidget(),
          ),
        ),
        Flexible(
          child: ListView.builder(
              itemCount: finishProductList.length - 1,
              itemBuilder: (context, index1) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16, right: 18, top: 22),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                DeleteButton(function: () {
                                  showDeleteDialog(index1);
                                }),
                                Text(
                                  "${finishProductList[index1 + 1]}",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Raw. Name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Raw. Qnt.",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 26 *
                                      finishProductRawData[index1]
                                          .toString()
                                          .split("}")
                                          .length
                                          .toDouble(),
                                  child: ListView.builder(
                                      itemCount: finishProductRawData[index1]
                                              .toString()
                                              .split("}")
                                              .length -
                                          1,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(getNameOfRaw(
                                                    index, index1)),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    getQntOfRaw(index, index1)),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                            //
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  void showDeleteDialog(int index) {
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
                print("index :: $index");
                print(
                    "idOfFinishDetails[index] :: ${idOfFinishDetails[index]}");
                setState(() {
                  isLoading = true;
                });
                await deleteApi("finish", "${idOfFinishDetails[index]}");
                showSnackbar(_scaffoldkey.currentContext, "Delete successfully",
                    Colors.green);
                getAllProductsName();
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void getRawMaterials() {
    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.getRaw + "?type=all");
    get(url).then((value) {
      print("Raw Materials :: ${value.body}");
      int len = getJsonLength(jsonDecode(value.body));
      final jsonData = jsonDecode(value.body);
      print("Len :: $len");
      for (int i = 0; i < len; i++) {
        setState(() {
          if (!(rawMaterialList.contains("${jsonData[i]["name"]}"))) {
            rawMaterialList.add(jsonData[i]["name"]);
          }
        });
      }
    });
  }

  void getAllProductsName() {
    finishProductRawData.clear();
    finishProductList.clear();
    idOfFinishDetails.clear();
    finishProductList.add("Select");

    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.getFinishLinkRaw);
    get(url).then((value) {
      print("Finish Materials :: ${value.body}");
      int len = getJsonLength(jsonDecode(value.body));
      jsonDataOfProductName = jsonDecode(value.body);
      print("Len :: $len");
      for (int i = 0; i < len; i++) {
        setState(() {
          finishProductList.add(jsonDataOfProductName[i]["name"]);
          finishProductRawData.add(jsonDataOfProductName[i]["raw_data"]);
          idOfFinishDetails.add(jsonDataOfProductName[i]["id"]);
          // print("rawMaterialShowDataName :: $rawMaterialShowDataName");
          isLoading = false;
        });
        print("finishProductRawData :: $idOfFinishDetails");
      }
      setState(() {
        isLoading = false;
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  void getAllFinalProducts([String type = "date", String name = ""]) {
    finishProductName.clear();
    srNo.clear();
    finishQnt.clear();
    date.clear();
    DateTime now = DateTime.now();
    String sendDate = "${now.day}-${now.month}-${now.year}";
    Uri url;
    if (type == "date") {
      url = Uri.parse(APIUrl.mainUrl +
          APIUrl.getFinalProduct +
          "?type=$type&date=$sendDate");
    } else if (type == "all") {
      url = Uri.parse(APIUrl.mainUrl + APIUrl.getFinalProduct + "?type=$type");
    } else {
      url = Uri.parse(
          APIUrl.mainUrl + APIUrl.getFinalProduct + "?type=$type&name=$name");
    }
    get(url).then((value) {
      print("All Finish Products :: ${value.body}");
      int len = getJsonLength(jsonDecode(value.body));
      final jsonData = jsonDecode(value.body);
      print("Len :: $len");
      for (int i = 0; i < len; i++) {
        setState(() {
          finishProductName.add(jsonData[i]["name"]);
          srNo.add(jsonData[i]["serial_number"]);
          finishQnt.add(jsonData[i]["quantity"]);
          date.add(jsonData[i]["in_date"]);
          photo.add(jsonData[i]["bill_photo"]);
          isLoading = false;
        });
      }
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

  String getNameOfRaw(int index, int index1) {
    print("$index--------------------------$index1");
    // print("Index Name :: $index");
    // print("Index1 Name :: $index1");

    print(
        "getNameOfRaw :: ${finishProductRawData[index1].toString().split("}")[index].toString().split("_")[0]}");
    print("=================================================");

    // String temp =
    // "${finishProductRawData[index1].toString().split("}")[index].toString().split("_")[0]}";

    return "${finishProductRawData[index1].toString().split("}")[index].toString().split("_")[0]}";
    // return "-";
  }

  String getQntOfRaw(int index, int index1) {
    // print("Index Qnt :: $index");
    // print("Index1 Qnt :: $index1");
    // print(
    //     "getNameOfRawQNt :: ${finishProductRawData[index1].toString().split("}")[index].toString().split("_")[1]}");
    // String temp =
    return "${finishProductRawData[index1].toString().split("}")[index].toString().split("_")[1]}";
    // return temp != null ? temp : "-";
    // return "-";
  }

  Future<void> function1(
      String body, String rawQnt, String rawName, String newDate) async {
    try {
      print("body :: $body");
      int tt = int.parse(body) - int.parse(rawQnt);
      Uri url = Uri.parse(APIUrl.mainUrl +
          APIUrl.updateQuantityRaw +
          "?name=$rawName&quantity=$tt&date=$newDate");
      await post(url).then((value) async {
        print("Raw Materials Update :: ${value.body}");

        //
        Uri url1 = Uri.parse(APIUrl.mainUrl +
            APIUrl.getAvalailablOut +
            "?name=$rawName&date=$dateString");
        print("Available Url :: $url1");
        await get(url1).then((value) async {
          log("Get Available :: ${value.body}");
          //
          if (value.body.contains("Error description")) {
            //again

            for (int k = 0; k < 5; k++) {
              DateTime newDate = DateTime(
                      int.parse(dateString.split("-")[2]),
                      int.parse(dateString.split("-")[1]),
                      int.parse(dateString.split("-")[0]))
                  .subtract(Duration(days: k));

              Uri url1 = Uri.parse(APIUrl.mainUrl +
                  APIUrl.getAvalailablOut +
                  "?name=$rawName&date=${newDate.day}-${newDate.month}-${newDate.year}");
              print("Get Available Url :: $url1");
              await get(url1).then((value) {
                print("Get Available :: ${value.body}");

                if (!(value.body.contains("Error description"))) {
                  k = 10;
                  function2(value.body, rawQnt, rawName,
                      "${newDate.day}-${newDate.month}-${newDate.year}");
                }
              });
              if (k == 4) {
                function2("0", rawQnt, rawName,
                    "${newDate.day}-${newDate.month}-${newDate.year}");
              }
            }
          } else {
            function2(value.body, rawQnt, rawName, "$dateString");
          }

          // function2(value, rawQnt, rawName);
        });
      });
    } catch (e) {
      print("Error Function 1 :: $e");
    }
  }

  void function2(String body, String rawQnt, String rawName, String newDate) {
    try {
      int outQnt = int.parse(body) + int.parse(rawQnt);

      print("outQnt :: $outQnt");

      Uri url1 = Uri.parse(APIUrl.mainUrl +
          APIUrl.updateOut +
          "?name=$rawName&date=$newDate&out=$outQnt");
      print("Available Url 2 :: $url1");
      post(url1).then((value) {
        print("Post Available 2  :: ${value.body}");
      });
    } catch (e) {
      print("Error Function 2 :: $e");
    }
  }
}
