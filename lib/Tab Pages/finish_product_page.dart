import 'dart:convert';
import 'package:dustbin/Widgets/button_widget.dart';
import 'package:dustbin/Widgets/progressHud.dart';
import 'package:flutter/material.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import '../globalVariable.dart';
import 'package:http/http.dart';
import 'dart:io' as Io;
import 'package:url_launcher/url_launcher.dart';

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
  int currentPage = 0;
  String rawMaterialDropdown = "Select";
  String finishProductDropdown = "Select";
  var title = ["Sr. No.", "Name", "Quantity"];
  var title1 = [
    "Sr. No.",
    "Name",
    "Quantity",
    "Serial Number",
    "Date",
    "Bill Photo"
  ];
  var name = [];
  var finishProductName = [];
  var finishProductRawData = [];
  var qnt = [];
  var date = [];
  var finishQnt = [];
  var srNo = [];
  var photo = [];
  bool isLoading = false;
  var rawMaterialNameDatabase = [];
  var rawMaterialQntDatabase = [];
  var jsonDataOfProductName;
  String filePath = " ";
  List<String> rawMaterialList = [
    "Select",
  ];

  List<String> finishProductList = [
    "Select",
  ];

  var rawMaterialShowDataName = [];
  var rawMaterialShowDataQnt = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRawMaterials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        isLoading: isLoading,
        child: Stack(
          children: [
            Visibility(
              visible: currentPage == 0 ? true : false,
              child: Column(
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
                          setState(() {
                            currentPage = 1;
                          });
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
                          getAllProductsName();
                          setState(() {
                            currentPage = 3;
                          });
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
              ),
            ),
            addNewFinishProduct(),
            addFinalFinishProduct(),
            viewFinishProduct(),
          ],
        ),
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
    return Visibility(
      visible: currentPage == 1 ? true : false,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
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
                      padding: const EdgeInsets.only(right: 144),
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 28.0,
                      columns: List.generate(title.length, (index) {
                        return DataColumn(label: Text(title[index].toString()));
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

                  await post(url, body: body).then((value) {
                    print("Value :: ${value.body}");
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
        DataCell(Text("${srNo[index]}")),
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
    return Visibility(
      visible: currentPage == 2 ? true : false,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                                      for (int i = 0; i < temp.length; i++) {
                                        rawMaterialNameDatabase.add(
                                            temp[i].toString().split("_")[0]);
                                        rawMaterialQntDatabase.add(
                                            temp[i].toString().split("_")[1]);
                                      }
                                      print(
                                          "rawMaterialNameDatabase :: $rawMaterialNameDatabase");
                                      print(
                                          "rawMaterialQntDatabase :: $rawMaterialQntDatabase");
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
                        child: titleTextField("Date", dateController),
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
                        child: titleTextField("Quantity", finishQntController),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 144),
                        child: titleTextField(
                            "Serial Number", serialNumberController),
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
                          buttonText: "Upload",
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
                Divider(
                  thickness: 1,
                  color: colorBlack5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Raw Materials Details",
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
                        columns: List.generate(title1.length, (index) {
                          return DataColumn(
                              label: Text(title1[index].toString()));
                        }),
                        rows: List.generate(finishProductName.length,
                            (index) => _getDataRow1(index)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
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
                function: () {
                  if (validateField(context, dateController) &&
                      validateField(context, finishQntController) &&
                      validateField(context, serialNumberController)) {
                    setState(() {
                      isLoading = true;
                    });
                    for (int i = 0; i < rawMaterialNameDatabase.length; i++) {
                      Uri url = Uri.parse(APIUrl.mainUrl +
                          APIUrl.availableRaw +
                          "?name=${rawMaterialNameDatabase[i]}");
                      get(url).then((value) {
                        print("Raw Materials :: ${value.body}");
                        int tt = int.parse(value.body) -
                            int.parse(rawMaterialQntDatabase[i]);
                        Uri url = Uri.parse(APIUrl.mainUrl +
                            APIUrl.updateQuantityRaw +
                            "?name=${rawMaterialNameDatabase[i]}&quantity=$tt");
                        post(url).then((value) {
                          print("Raw Materials Update :: ${value.body}");
                          if (value.body.toString() == "done") {
                            if (i == rawMaterialNameDatabase.length - 1) {
                              final bytes =
                                  Io.File('$filePath').readAsBytesSync();
                              String img64 = base64Encode(bytes);
                              //upload to Database
                              final body = {
                                "name": "$finishProductDropdown",
                                "serial_number":
                                    "${serialNumberController.text}",
                                "quantity": "${finishQntController.text}",
                                "in_date": "${dateController.text}",
                                "bill_photo": "$img64",
                              };

                              Uri url = Uri.parse(
                                  APIUrl.mainUrl + APIUrl.finalProductUpload);
                              post(url, body: body).then((value) {
                                print("finalProductUpload :: ${value.body}");
                                dateController.clear();
                                finishQntController.clear();
                                serialNumberController.clear();
                                getAllFinalProducts();
                              });
                            }
                          }
                        });
                      });
                    }
                    date.add(dateController.text);
                    finishQnt.add(finishQntController.text);
                    srNo.add(serialNumberController.text);

                    setState(() {});
                  }
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
    );
  }

  viewFinishProduct() {
    return Visibility(
      visible: currentPage == 3 ? true : false,
      child: Column(
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
                    padding:
                        const EdgeInsets.only(top: 18, bottom: 18, left: 18),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Finish Products Details",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
          Flexible(
            child: ListView.builder(
                itemCount: finishProductList.length - 1,
                itemBuilder: (context, index1) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 18, top: 22),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "${finishProductList[index1 + 1]}",
                                style: TextStyle(fontSize: 18),
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
                                    height: 200,
                                    child: ListView.builder(
                                        itemCount: finishProductRawData.length,
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
                                                  child: Text(getQntOfRaw(
                                                      index, index1)),
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
      ),
    );
  }

  void getRawMaterials() {
    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.getRaw);
    get(url).then((value) {
      print("Raw Materials :: ${value.body}");
      int len = getJsonLength(jsonDecode(value.body));
      final jsonData = jsonDecode(value.body);
      print("Len :: $len");
      for (int i = 0; i < len; i++) {
        setState(() {
          rawMaterialList.add(jsonData[i]["name"]);
        });
      }
    });
  }

  void getAllProductsName() {
    finishProductRawData.clear();
    finishProductList.clear();
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
          // print("rawMaterialShowDataName :: $rawMaterialShowDataName");
        });
        print("finishProductRawData :: $finishProductRawData");
      }
    });
  }

  void getAllFinalProducts() {
    finishProductName.clear();
    srNo.clear();
    finishQnt.clear();
    date.clear();
    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.getFinalProduct);
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

  String getNameOfRaw(int index, int index1) {
    // print("getNameOfRaw :: ${finishProductRawData[index].toString()}");
    print("Index getNameOfRaw :: $index");

    print(
        "getNameOfRaw :: ${finishProductRawData[index1].toString().split("}")[index].toString().split("_")[0]}");

    return "${finishProductRawData[index1].toString().split("}")[index].toString().split("_")[0]}";
  }

  String getQntOfRaw(int index, int index1) {
    print("Index getQntOfRaw :: $index");
    print(
        "getNameOfRawQNt :: ${finishProductRawData[index1].toString().split("}")[index].toString().split("_")[1]}");

    return "${finishProductRawData[index1].toString().split("}")[index].toString().split("_")[1]}";
  }
}
