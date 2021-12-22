import 'dart:convert';
import 'dart:io';
import 'package:number_to_words/number_to_words.dart';
import 'package:erp_software/Widgets/button_widget.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:http/http.dart';
import '../globalVariable.dart';
import 'dart:io' as Io;
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class GenerateBillPage extends StatefulWidget {
  @override
  _GenerateBillPageState createState() => _GenerateBillPageState();
}

class _GenerateBillPageState extends State<GenerateBillPage> {
  final controller = TextEditingController();
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final gstController = TextEditingController();
  final remarkController = TextEditingController();
  final qntController = TextEditingController();
  final priceController = TextEditingController();
  final gstPercentageController = TextEditingController();
  final bankNameController = TextEditingController();
  final bankDetailsNumberController = TextEditingController();
  final popUpController = TextEditingController();
  final popUpSerialNoController = TextEditingController();
  String rawMaterialDropdown = "Select";
  String productNameDropdown = "Select";
  String filePath = " ";
  List<String> rawMaterialList = ["Select"];
  List<String> productNameList = ["Select"];
  String dateString = "DD-MM-YYYY";
  String milli = DateTime.now().millisecondsSinceEpoch.toString();
  List<int> bytes;
  var assetImage;

  var customerDetailsJson;
  double dividerHeight = 244.0;
  int currentStockNumber = 1;
  String currentStockId = "";
  String currentHsnCode = "";

  String totalFinal = "";

  var subTotalArray = [];

  //
  int idOfPaymentMethod = 1;
  String radioButtonItemOfPaymentMethod = "Advance Payment";

  int idOfAdvance = 1;
  String radioButtonItemOfAdvance = "Cheque";

  int idOfGst = 1;
  String radioButtonItemOfGst = "CGST & SGST";

  var productNameArray = [];
  var productPriceArray = [];
  var productQuantityArray = [];
  var productSubtotalArray = [];
  var productHsnCode = [];
  var productSerialNumber = [];

  //
  var updateIdArray = [];
  var updateQntArray = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomer();
    getAllFinalProducts();
    getImage();
    // pdfTrial();
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
                  "Generate Bill",
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
                              "Select product name",
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
                                    borderRadius: BorderRadius.circular(0)),
                                margin:
                                    EdgeInsets.only(left: 18, right: 6, top: 6),
                                padding: EdgeInsets.only(left: 14),
                                child: DropdownButton<String>(
                                  value: productNameDropdown,
                                  dropdownColor: colorCard,
                                  elevation: 0,
                                  underline: Container(),
                                  icon: Container(),
                                  onChanged: (String newValue) {
                                    Uri url = Uri.parse(APIUrl.mainUrl +
                                        APIUrl.getFinalProduct +
                                        "?type=name&name=$newValue");

                                    get(url).then((value) {
                                      print(
                                          "Finish Product Details :: ${value.body}");
                                      int len =
                                          getJsonLength(jsonDecode(value.body));
                                      final jsonData = jsonDecode(value.body);
                                      print("Len :: $len");

                                      currentStockNumber = int.parse(
                                          jsonData[0]["quantity"].toString());
                                      currentStockId =
                                          jsonData[0]["id"].toString();
                                      currentHsnCode =
                                          jsonData[0]["hsn"].toString();
                                      print(
                                          "currentStockNumber :: $currentStockNumber");
                                    });
                                    setState(() {
                                      productNameDropdown = newValue;
                                    });
                                  },
                                  items: productNameList
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
                              Container(
                                margin: EdgeInsets.only(top: 6),
                                decoration: BoxDecoration(
                                    color: colorBlack5,
                                    // border: Border.all(width: 1, color: grey),
                                    borderRadius: BorderRadius.circular(100)),
                                child: InkWell(
                                  onTap: () {
                                    if (productNameDropdown != "Select") {
                                      AlertDialog alert = AlertDialog(
                                        // title: Text("Simple Alert"),
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            titleTextField("Serial Number",
                                                popUpSerialNoController),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            titleTextField("Product Price",
                                                popUpController),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            titleTextField("Product Quantity",
                                                qntController),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 22, top: 12),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  if (validateField(context,
                                                          popUpController) &&
                                                      validateField(context,
                                                          qntController) &&
                                                      validateField(context,
                                                          popUpSerialNoController)) {
                                                    if (int.parse(qntController
                                                            .text) <=
                                                        currentStockNumber) {
                                                      setState(() {
                                                        productNameArray.add(
                                                            productNameDropdown);
                                                        productHsnCode.add(
                                                            currentHsnCode);
                                                        productPriceArray.add(
                                                            popUpController
                                                                .text);
                                                        productQuantityArray
                                                            .add(qntController
                                                                .text);
                                                        productSerialNumber.add(
                                                            popUpSerialNoController
                                                                .text);

                                                        updateIdArray.add(
                                                            currentStockId);
                                                        updateQntArray.add(
                                                            "${currentStockNumber - int.parse(qntController.text)}");
                                                      });
                                                      popUpController.clear();
                                                      qntController.clear();
                                                      popUpSerialNoController
                                                          .clear();
                                                    } else {
                                                      showSnackbar(
                                                          context,
                                                          "Only $currentStockNumber quantity left",
                                                          Colors.red);
                                                    }
                                                  }
                                                },
                                                child: Text("Ok"),
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
                                    } else {
                                      showSnackbar(context,
                                          "Select product first", Colors.red);
                                    }
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
                              "Select customer name",
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
                                getCustomerDetails(rawMaterialDropdown);
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
                    child: titleTextField("GST No. (Optional)", gstController),
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
                    child: titleTextField("GST %", gstPercentageController),
                  ),
                ),
                Expanded(
                  // child: Padding(
                  //   padding: const EdgeInsets.only(right: 144),
                  //   child: titleTextField("GST %", gstPercentageController),
                  // ),
                  child: Container(),
                ),
              ],
            ),
            SizedBox(
              height: 18,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                // height: 46,
                width: 600,
                decoration: BoxDecoration(
                    color: colorCardWhite,
                    border: Border.all(width: 0.5, color: grey),
                    borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.only(left: 18, right: 18, top: 18),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Radio(
                          activeColor: colorDark,
                          value: 1,
                          groupValue: idOfGst,
                          onChanged: (val) {
                            setState(() {
                              radioButtonItemOfGst = 'CGST & SGST';
                              idOfGst = 1;
                              // cusPriceV = false;
                            });
                          },
                        ),
                        Text(
                          'CGST & SGST',
                          style: new TextStyle(
                              fontSize: 17.0, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 22,
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: colorDark,
                          value: 2,
                          groupValue: idOfGst,
                          onChanged: (val) {
                            setState(() {
                              radioButtonItemOfGst = 'IGST';
                              idOfGst = 2;
                              // cusPriceV = false;
                            });
                          },
                        ),
                        Text(
                          'IGST',
                          style: new TextStyle(
                              fontSize: 17.0, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 22,
            ),
            productNameArray.length > 0
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: SizedBox(
                        width: 600,
                        child: ListView.builder(
                            itemCount: productNameArray.length + 1,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? Card(
                                      color: colorCardWhite,
                                      elevation: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            Opacity(
                                              opacity: 0,
                                              child: Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 18,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                              flex: 6,
                                              child: Text(
                                                "Product Name",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Product Price",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 22,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Product Qty",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Opacity(
                                              opacity: 0,
                                              child: Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Card(
                                      elevation: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 18,
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                              flex: 6,
                                              child: Text(
                                                productNameArray[index - 1],
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                productPriceArray[index - 1],
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 22,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                productSerialNumber[index - 1],
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 22,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                productQuantityArray[index - 1],
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  productNameArray
                                                      .removeAt(index - 1);
                                                  productPriceArray
                                                      .removeAt(index - 1);
                                                  productQuantityArray
                                                      .removeAt(index - 1);
                                                  productSerialNumber
                                                      .removeAt(index - 1);
                                                  updateQntArray
                                                      .removeAt(index - 1);
                                                  updateIdArray
                                                      .removeAt(index - 1);
                                                  productHsnCode
                                                      .removeAt(index - 1);
                                                });
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                size: 18,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            }),
                      ),
                    ),
                  )
                : Container(),
            // Row(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(right: 0, left: 20),
            //       child: Align(
            //         alignment: Alignment.topLeft,
            //         child: ButtonWidget(
            //           widget: Image.asset(
            //             "images/pdf.png",
            //             width: 20,
            //             height: 20,
            //           ),
            //           isIcon: true,
            //           context: context,
            //           buttonText: "Upload",
            //           function: () {
            //             final file = OpenFilePicker()
            //               ..filterSpecification = {
            //                 'Word Document (*.doc)': '*.doc',
            //                 'Web Page (*.htm; *.html)': '*.htm;*.html',
            //                 'Text Document (*.txt)': '*.txt',
            //                 'All Files': '*.*'
            //               }
            //               ..defaultFilterIndex = 0
            //               ..defaultExtension = 'doc'
            //               ..title = 'Select a document';
            //
            //             final result = file.getFile();
            //             if (result != null) {
            //               print(result.path);
            //               setState(() {
            //                 filePath = result.path;
            //               });
            //             }
            //           },
            //           left: 0,
            //           right: 0,
            //           width: 133,
            //           height: 33,
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       width: 22,
            //     ),
            //     Text(
            //       filePath,
            //       style: TextStyle(
            //         fontSize: 14,
            //         color: colorBlack5,
            //         decoration: TextDecoration.underline,
            //       ),
            //     )
            //   ],
            // ),

            optionalParameters(),
            SizedBox(
              height: 22,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 177),
                    child:
                        titleTextField("Remark (Optional)", remarkController),
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
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 0, left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: ButtonWidget(
                      widget: Container(),
                      isIcon: false,
                      context: context,
                      buttonText: "Rough Bill",
                      function: () {
                        // final bytes = Io.File('$filePath').readAsBytesSync();
                        //
                        // String img64 = base64Encode(bytes);
                        // final body = {
                        //   "name": "$productNameDropdown",
                        //   "customer_name": "$rawMaterialDropdown",
                        //   "date": "${dateString}",
                        //   "gst": "${gstController.text}",
                        //   // "photo": "$img64",
                        // };
                        // Uri url =
                        //     Uri.parse(APIUrl.mainUrl + APIUrl.postKacchaBill);
                        // post(url, body: body).then((value) {
                        //   print("postKacchaBill :: ${value.body}");
                        // });
                        showSnackbar(context, "Please wait we are creating PDF",
                            Colors.green);

                        pdfTrial(1, "Original for recipient");
                        pdfTrial(1, "Duplicate for transportation");
                        pdfTrial(1, "Triplicates  for supplier");
                      },
                      left: 0,
                      right: 0,
                      width: 100,
                      height: 26,
                    ),
                  ),
                ),
                SizedBox(
                  width: 22,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0, left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: ButtonWidget(
                      widget: Container(),
                      isIcon: false,
                      context: context,
                      buttonText: "Final Bill",
                      function: () {
                        showSnackbar(context, "Please wait we are creating PDF",
                            Colors.green);
                        pdfTrial(2, "Original for recipient");
                        pdfTrial(2, "Duplicate for transportation");
                        pdfTrial(3, "Triplicates  for supplier");
                      },
                      left: 0,
                      right: 0,
                      width: 100,
                      height: 26,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 200,
            ),
          ],
        ),
      ),
    );
  }

  void getCustomer() {
    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.getCustomer);
    get(url).then((value) {
      print("Customer :: ${value.body}");
      final jsonData = jsonDecode(value.body);
      print("Len :: ${getJsonLength(jsonData)}");

      for (int i = 0; i < getJsonLength(value.body); i++) {
        rawMaterialList.add(jsonData[i]["name"]);
        setState(() {});
      }
      setState(() {});
    });
  }

  void getAllFinalProducts() {
    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.getFinalProduct + "?type=all");
    get(url).then((value) {
      print("All Finish Products :: ${value.body}");
      int len = getJsonLength(jsonDecode(value.body));
      final jsonData = jsonDecode(value.body);
      print("Len :: $len");
      for (int i = 0; i < len; i++) {
        if (!productNameList.contains(jsonData[i]["name"])) {
          setState(() {
            productNameList.add(jsonData[i]["name"]);
          });
        }
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

  uploadFunction() {}

  Future<void> pdfTrial(int billCount, String recipentTitle) async {
    productSubtotalArray.clear();

    for (int i = 0; i < productNameArray.length; i++) {
      subTotalArray.add(getSubTotal1(i));
    }
    totalFinal = getTotalFinal();

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Stack(
              children: [
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Center(
                      child: pw.Text(
                        "INVOICE",
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.SizedBox(
                      height: 33,
                    ),
                    pw.Container(
                      decoration: pw.BoxDecoration(
                          // color: Color(0xfff2f2f2),
                          border: pw.Border.all(width: 1),
                          borderRadius: pw.BorderRadius.circular(0)),
                      child: pw.Column(
                        children: [
                          pw.Container(
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Expanded(child: leftSidePdf()),
                                pw.Container(
                                    width: 0,
                                    height: dividerHeight,
                                    margin: pw.EdgeInsets.zero,
                                    child: pw.VerticalDivider(
                                      // color: colorBlack5,
                                      thickness: 1,
                                    )),
                                pw.Expanded(child: rightSidePdf()),
                              ],
                            ),
                          ),
                          pw.Divider(
                            height: 0,
                            thickness: 1,
                            // color: colorBlack5,
                          ),
                          pw.SizedBox(
                            height: 8,
                          ),
                          tableLayout(),
                          pw.Divider(
                            thickness: 1,
                            // color: colorBlack5,
                          ),
                          pw.ListView.builder(
                              itemCount: productNameArray.length,
                              // shrinkWrap: true,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  productSubtotalArray.clear();
                                }
                                return pw.Column(
                                  children: [
                                    containTableLayout(index),
                                    index == productNameArray.length - 1
                                        ? pw.SizedBox(
                                            height: 6,
                                          )
                                        : pw.Divider(
                                            thickness: 1,
                                            // color: colorBlack5,
                                          ),
                                  ],
                                );
                              }),
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Padding(
                                  padding: pw.EdgeInsets.only(left: 8),
                                  child: pw.Text(" "),
                                ),
                                flex: 5,
                              ),
                              pw.SizedBox(
                                width: 8,
                              ),
                              pw.Expanded(
                                child: pw.Text(" "),
                                flex: 30,
                              ),
                              pw.SizedBox(
                                width: 2,
                              ),
                              pw.Expanded(
                                child: pw.Text(" "),
                                flex: 25,
                              ),
                              pw.SizedBox(
                                width: 8,
                              ),
                              pw.Expanded(
                                child: pw.Text(" "),
                                flex: 6,
                              ),
                              pw.SizedBox(
                                width: 2,
                              ),
                              pw.Expanded(
                                child: pw.Text(" "),
                                flex: 9,
                              ),
                              pw.SizedBox(
                                width: 2,
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  "$radioButtonItemOfGst" == "CGST & SGST"
                                      ? "CSGT ${"${"${double.parse(gstPercentageController.text) / 2}"}%"}"
                                      : radioButtonItemOfGst +
                                          " ${"${"${double.parse(gstPercentageController.text)}"}%"}",
                                  textAlign: pw.TextAlign.left,
                                  style: pw.TextStyle(fontSize: 8),
                                ),
                                flex: 20,
                              ),
                              pw.SizedBox(
                                width: 2,
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  "$radioButtonItemOfGst" == "CGST & SGST"
                                      ? "Rs. " + getCsgtAmt()
                                      : "Rs. " + getIgstAmt(),
                                  style: pw.TextStyle(fontSize: 8),
                                ),
                                flex: 20,
                              ),
                            ],
                          ),
                          "$radioButtonItemOfGst" == "CGST & SGST"
                              ? pw.Row(
                                  children: [
                                    pw.Expanded(
                                      child: pw.Padding(
                                        padding: pw.EdgeInsets.only(left: 8),
                                        child: pw.Text(" "),
                                      ),
                                      flex: 5,
                                    ),
                                    pw.SizedBox(
                                      width: 8,
                                    ),
                                    pw.Expanded(
                                      child: pw.Text(" "),
                                      flex: 30,
                                    ),
                                    pw.SizedBox(
                                      width: 2,
                                    ),
                                    pw.Expanded(
                                      child: pw.Text(" "),
                                      flex: 25,
                                    ),
                                    pw.SizedBox(
                                      width: 8,
                                    ),
                                    pw.Expanded(
                                      child: pw.Text(" "),
                                      flex: 6,
                                    ),
                                    pw.SizedBox(
                                      width: 2,
                                    ),
                                    pw.Expanded(
                                      child: pw.Text(" "),
                                      flex: 9,
                                    ),
                                    pw.SizedBox(
                                      width: 2,
                                    ),
                                    pw.Expanded(
                                      child: pw.Text(
                                        "SGST ${double.parse(gstPercentageController.text) / 2}%",
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(fontSize: 8),
                                      ),
                                      flex: 20,
                                    ),
                                    pw.SizedBox(
                                      width: 2,
                                    ),
                                    pw.Expanded(
                                      child: pw.Text(
                                        "Rs. " + getCsgtAmt(),
                                        style: pw.TextStyle(fontSize: 8),
                                      ),
                                      flex: 20,
                                    ),
                                  ],
                                )
                              : pw.Container(),
                          pw.Divider(
                            thickness: 1,
                            // color: colorBlack5,
                          ),
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Padding(
                                  padding: pw.EdgeInsets.only(left: 8),
                                  child: pw.Text(" "),
                                ),
                                flex: 5,
                              ),
                              pw.SizedBox(
                                width: 8,
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  "Total",
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                flex: 30,
                              ),
                              pw.SizedBox(
                                width: 2,
                              ),
                              pw.Expanded(
                                child: pw.Text(" "),
                                flex: 25,
                              ),
                              pw.SizedBox(
                                width: 8,
                              ),
                              pw.Expanded(
                                child: pw.Text(" "),
                                flex: 6,
                              ),
                              pw.SizedBox(
                                width: 2,
                              ),
                              pw.Expanded(
                                child: pw.Text(" "),
                                flex: 9,
                              ),
                              pw.SizedBox(
                                width: 2,
                              ),
                              pw.Expanded(
                                child: pw.Text(" "),
                                flex: 20,
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  "Rs. " + totalFinal,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10),
                                ),
                                flex: 20,
                              ),
                            ],
                          ),
                          pw.Divider(
                            thickness: 1,
                            // color: colorBlack5,
                          ),
                          // pw.SizedBox(
                          //   height: 2,
                          // ),
                          pw.Stack(
                            children: [
                              pw.Column(
                                children: [
                                  pw.Align(
                                    alignment: pw.Alignment.topRight,
                                    child: pw.SizedBox(
                                      width: 188,
                                      child: pw.Row(
                                        children: [
                                          pw.Expanded(
                                            child: pw.Text(
                                              "Company's Bank Details",
                                              style: pw.TextStyle(fontSize: 8),
                                            ),
                                          ),
                                          pw.Expanded(
                                            child: pw.Container(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.SizedBox(
                                    height: 2,
                                  ),
                                  pw.Align(
                                    alignment: pw.Alignment.topRight,
                                    child: pw.SizedBox(
                                      width: 188,
                                      child: pw.Row(
                                        children: [
                                          pw.Expanded(
                                            child: pw.Text(
                                              "Bank Name :",
                                              style: pw.TextStyle(fontSize: 8),
                                            ),
                                          ),
                                          pw.Expanded(
                                            child: pw.Text(
                                              "Yes Bank",
                                              style: pw.TextStyle(fontSize: 8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.SizedBox(
                                    height: 2,
                                  ),
                                  pw.Align(
                                    alignment: pw.Alignment.topRight,
                                    child: pw.SizedBox(
                                      width: 188,
                                      child: pw.Row(
                                        children: [
                                          pw.Expanded(
                                            child: pw.Text(
                                              "A/c No. :",
                                              style: pw.TextStyle(fontSize: 8),
                                            ),
                                          ),
                                          pw.Expanded(
                                            child: pw.Text(
                                              "009883800003015",
                                              style: pw.TextStyle(fontSize: 8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.SizedBox(
                                    height: 2,
                                  ),
                                  pw.Align(
                                    alignment: pw.Alignment.topRight,
                                    child: pw.SizedBox(
                                      width: 188,
                                      child: pw.Row(
                                        children: [
                                          pw.Expanded(
                                            child: pw.Text(
                                              "IFS Code :",
                                              style: pw.TextStyle(fontSize: 8),
                                            ),
                                          ),
                                          pw.Expanded(
                                            child: pw.Text(
                                              "YESB0000098",
                                              style: pw.TextStyle(fontSize: 8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.SizedBox(
                                    height: 2,
                                  ),
                                  pw.Align(
                                    alignment: pw.Alignment.topRight,
                                    child: pw.Container(
                                      height: 80,
                                      width: 188,
                                      padding: pw.EdgeInsets.all(4),
                                      decoration: pw.BoxDecoration(
                                          border: pw.Border.all(width: 1),
                                          borderRadius:
                                              pw.BorderRadius.circular(0)),
                                      child: pw.Text("Authorised Signature",
                                          style: pw.TextStyle(fontSize: 8)),
                                    ),
                                  ),
                                ],
                              ),
                              pw.Align(
                                  alignment: pw.Alignment.topLeft,
                                  child: pw.Padding(
                                    padding: const pw.EdgeInsets.only(left: 8),
                                    child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(
                                          "Amount Chargeable (in words)",
                                          style: pw.TextStyle(fontSize: 8),
                                        ),
                                        pw.SizedBox(
                                          height: 2,
                                        ),
                                        pw.Text(
                                          "INR ${NumberToWord().convert('en-in', double.parse(totalFinal).round())} Only",
                                          style: pw.TextStyle(fontSize: 8),
                                        ),
                                        pw.SizedBox(
                                          height: 16,
                                        ),
                                        pw.SizedBox(
                                          width: 200,
                                          child: pw.Row(
                                            children: [
                                              pw.Expanded(
                                                child: pw.Text(
                                                  "Company's VAT TIN :",
                                                  style:
                                                      pw.TextStyle(fontSize: 8),
                                                ),
                                              ),
                                              pw.Expanded(
                                                child: pw.Text(
                                                  "YESB0000098",
                                                  style:
                                                      pw.TextStyle(fontSize: 8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        pw.SizedBox(
                                          height: 2,
                                        ),
                                        pw.SizedBox(
                                          width: 200,
                                          child: pw.Row(
                                            children: [
                                              pw.Expanded(
                                                child: pw.Text(
                                                  "Company's CST No. :",
                                                  style:
                                                      pw.TextStyle(fontSize: 8),
                                                ),
                                              ),
                                              pw.Expanded(
                                                child: pw.Text(
                                                  "YESB0000098",
                                                  style:
                                                      pw.TextStyle(fontSize: 8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        pw.SizedBox(
                                          height: 2,
                                        ),
                                        pw.SizedBox(
                                          width: 200,
                                          child: pw.Row(
                                            children: [
                                              pw.Expanded(
                                                child: pw.Text(
                                                  "Company's PAN :",
                                                  style:
                                                      pw.TextStyle(fontSize: 8),
                                                ),
                                              ),
                                              pw.Expanded(
                                                child: pw.Text(
                                                  "YESB0000098",
                                                  style:
                                                      pw.TextStyle(fontSize: 8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        pw.SizedBox(
                                          height: 2,
                                        ),
                                        pw.Text(
                                          "Declaration",
                                          style: pw.TextStyle(fontSize: 8),
                                        ),
                                        pw.SizedBox(
                                          height: 2,
                                        ),
                                        pw.Text(
                                          "We declare that this invoice shows the actual price of\nthe goods described and that all particulars are true\nand correct.",
                                          style: pw.TextStyle(fontSize: 8),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      height: 6,
                    ),
                    pw.Text(
                      "This is a Computer Generated Invoice",
                      style: pw.TextStyle(fontSize: 8),
                    ),
                  ],
                ),
                pw.Align(
                  alignment: pw.Alignment.topRight,
                  child: pw.Image(
                    assetImage,
                    width: 68,
                    height: 38,
                  ),
                ),
                pw.Align(
                  alignment: pw.Alignment.topLeft,
                  child: pw.Text(
                    "$recipentTitle",
                    style: pw.TextStyle(
                        fontSize: 10, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                bottomPart(),
              ],
            );
          }),
    );

    try {
      bytes = await pdf.save();
      // Uri url = Uri.parse("F:\\FILES\\Flutter Project\\ERP Software");
      final appDocDir = Directory.current.path;
      print("Path Final :: $appDocDir");
      // final milli = "trial";
      // final path = (await ExtStorage.getExternalStoragePublicDirectory(
      //     ExtStorage.DIRECTORY_DOWNLOADS));
      // print("Path :: $path");
      final file1 = File('$appDocDir/BMS-$milli-$recipentTitle.pdf');
      await file1.writeAsBytes(bytes, flush: true);

      if (recipentTitle == "Original for recipient") {
        String img64 = base64Encode(bytes);
        final body = {
          "name": productNameArray.toString(),
          "customer_name": "$rawMaterialDropdown",
          "date": "$dateString",
          "gst": "${gstController.text}",
          "photo": "$img64",
          "qty": qntController.text,
          // "price": priceController.text,
          "total": getTotalFinal(),
          "remark": remarkController.text,
          "payment_method": radioButtonItemOfPaymentMethod,
          "gst_percent": gstPercentageController.text,
          "type": radioButtonItemOfAdvance,
          "bank": bankNameController.text,
          "number": bankDetailsNumberController.text,
        };
        Uri url = Uri.parse(APIUrl.mainUrl +
            (billCount == 1 ? APIUrl.postKacchaBill : APIUrl.postPakkaBill));
        post(url, body: jsonEncode(body)).then((value) {
          print("postPakkaBill :: ${value.body}");
        });

        final body1 = {
          "id": updateIdArray,
          "qty": updateQntArray,
        };

        url = Uri.parse(APIUrl.mainUrl + APIUrl.updateQntFinalProduct);
        post(url, body: jsonEncode(body1)).then((value) {
          print("postPakkaBill :: ${value.body}");
        });

        OpenFile.open('$appDocDir/BMS-$milli-$recipentTitle.pdf');
      }
    } catch (e) {
      print("Error PDF :: $e");
      showSnackbar(context, "Please close previous open PDF", Colors.red);
    }
  }

  pw.Widget leftSidePdf() {
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Padding(
            padding: pw.EdgeInsets.only(left: 4),
            child: pw.Text(
              "Breathe Medical Systems Pvt. Ltd",
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.only(left: 4),
            child: pw.Text(
              "15, hariom nagar pandesara,\nnear govalak road,\nSurat-394210, Gujarat, India \nGSTIN/UIN : 256322142568542",
              style: pw.TextStyle(fontSize: 8),
            ),
          ),
          pw.Divider(
            // color: colorBlack5,
            thickness: 1,
          ),
          pw.Padding(
            padding: pw.EdgeInsets.only(left: 4),
            child: pw.Text(
              "Consignee",
              style: pw.TextStyle(fontSize: 8),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.only(left: 4),
            child: pw.Text(
              "${customerDetailsJson["com_name"]}",
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.only(left: 4),
            child: pw.Text(
              "${customerDetailsJson["name"]}\n${customerDetailsJson["com_name"]}\n${customerDetailsJson["address"]}\n${customerDetailsJson["city"]} ${customerDetailsJson["state"]}\n${customerDetailsJson["email"]}\nGST No. ${customerDetailsJson["gst"]}",
              style: pw.TextStyle(fontSize: 8),
            ),
          ),
          pw.Divider(
            // color: colorBlack5,
            thickness: 1,
          ),
          pw.Padding(
            padding: pw.EdgeInsets.only(left: 4),
            child: pw.Text(
              "Buyer (if other than consignee)",
              style: pw.TextStyle(fontSize: 8),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.only(left: 4),
            child: pw.Text(
              "${customerDetailsJson["com_name"]}",
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.only(left: 4),
            child: pw.Text(
              "${customerDetailsJson["name"]}\n${customerDetailsJson["com_name"]}\n${customerDetailsJson["address"]}\n${customerDetailsJson["city"]} ${customerDetailsJson["state"]}\n${customerDetailsJson["email"]}",
              style: pw.TextStyle(fontSize: 8),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget rightSidePdf() {
    return pw.Container(
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(child: rightSide1()),
          pw.Container(
              width: 0,
              height: dividerHeight,
              margin: pw.EdgeInsets.zero,
              child: pw.VerticalDivider(
                // color: colorBlack5,
                thickness: 1,
              )),
          pw.Expanded(child: rightSide2()),
        ],
      ),
    );
  }

  pw.Widget rightSide1() {
    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 4),
          child: pw.Text(
            "Invoice No.",
            style: pw.TextStyle(fontSize: 8),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 4),
          child: pw.Text(
            getRandomInt(4),
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Divider(
          // color: colorBlack5,
          thickness: 1,
        ),
      ],
    );
  }

  pw.Widget rightSide2() {
    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 4),
          child: pw.Text(
            "Date",
            style: pw.TextStyle(fontSize: 8),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 4),
          child: pw.Text(
            "$dateString",
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Divider(
          // color: colorBlack5,
          thickness: 1,
        ),
      ],
    );
  }

  pw.Widget tableLayout() {
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Padding(
            padding: const pw.EdgeInsets.only(left: 4),
            child: pw.Text("SL.No.", style: pw.TextStyle(fontSize: 8)),
          ),
          flex: 5,
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child:
              pw.Text("Description of Goods", style: pw.TextStyle(fontSize: 8)),
          flex: 30,
        ),
        pw.SizedBox(width: 2),
        pw.Expanded(
          child: pw.Text("HSN/SAC", style: pw.TextStyle(fontSize: 8)),
          flex: 25,
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: pw.Text("GST Rate", style: pw.TextStyle(fontSize: 8)),
          flex: 6,
        ),
        pw.SizedBox(width: 2),
        pw.Expanded(
          child: pw.Text("Quantity", style: pw.TextStyle(fontSize: 8)),
          flex: 9,
        ),
        pw.SizedBox(width: 2),
        pw.Expanded(
          child: pw.Text("Rate", style: pw.TextStyle(fontSize: 8)),
          flex: 20,
        ),
        pw.SizedBox(width: 2),
        pw.Expanded(
          child: pw.Text("Amount", style: pw.TextStyle(fontSize: 8)),
          flex: 20,
        ),
      ],
    );
  }

  pw.Widget containTableLayout(int index) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Padding(
            padding: const pw.EdgeInsets.only(left: 4),
            child: pw.Text("${index + 1}", style: pw.TextStyle(fontSize: 8)),
          ),
          flex: 5,
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: pw.Text(
              productNameArray[index] +
                  "\nSr.No.: ${productSerialNumber[index]}",
              style: pw.TextStyle(fontSize: 8)),
          flex: 30,
        ),
        pw.SizedBox(width: 2),
        pw.Expanded(
          child:
              pw.Text(productHsnCode[index], style: pw.TextStyle(fontSize: 8)),
          flex: 25,
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: pw.Text("${gstPercentageController.text}%",
              style: pw.TextStyle(fontSize: 8)),
          flex: 6,
        ),
        pw.SizedBox(width: 2),
        pw.Expanded(
          child: pw.Text("${productQuantityArray[index]}",
              style: pw.TextStyle(fontSize: 8)),
          flex: 9,
        ),
        pw.SizedBox(width: 2),
        pw.Expanded(
          child: pw.Text("${productPriceArray[index]}",
              style: pw.TextStyle(fontSize: 8)),
          flex: 20,
        ),
        pw.SizedBox(width: 2),
        pw.Expanded(
          child:
              pw.Text(subTotalArray[index], style: pw.TextStyle(fontSize: 8)),
          flex: 20,
        ),
      ],
    );
  }

  void getCustomerDetails(String Name) {
    // flutter: Details :: [{"id":8,"name":"Sam","gst":"125455665",
    // "address":"Sam Socity","state":"Gujarat","city":"Surat",
    // "com_name":"Ak","date":"10-12-2021","phone_number":"124222151",
    // "email":"pu@gmail.com"}]
    Uri url =
        Uri.parse(APIUrl.mainUrl + APIUrl.getCustomerDetails + "?name=$Name");
    get(url).then((value) {
      print("Details :: ${value.body}");
      customerDetailsJson = jsonDecode(value.body)[0];
      gstController.text = customerDetailsJson["gst"];
      setState(() {});
    });
  }

  String getQntMultiplicationText() {
    double tt =
        double.parse(qntController.text) * double.parse(priceController.text);
    return tt.toString();
  }

  String makeGstCalculation(int i) {
    if (i == 1) {
      double tt = (double.parse(getQntMultiplicationText()) * 18.0) / 100;
      // double total = double.parse(getQntMultiplicationText()) + tt;
      return tt.toString();
    }
    double tt = (double.parse(getQntMultiplicationText()) * 18.0) / 100;
    double total = double.parse(getQntMultiplicationText()) + tt;
    return total.toString();
  }

  optionalParameters() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            // height: 46,
            width: 200,
            decoration: BoxDecoration(
                color: colorCardWhite,
                border: Border.all(width: 0.5, color: grey),
                borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.only(left: 18, right: 18, top: 22),
            child: Column(
              children: [
                Row(
                  children: [
                    Radio(
                      activeColor: colorDark,
                      value: 1,
                      groupValue: idOfPaymentMethod,
                      onChanged: (val) {
                        setState(() {
                          radioButtonItemOfPaymentMethod = 'Advance Payment';
                          idOfPaymentMethod = 1;
                          // cusPriceV = false;
                        });
                      },
                    ),
                    Text(
                      'Advance Payment',
                      style: new TextStyle(fontSize: 17.0, color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      activeColor: colorDark,
                      value: 2,
                      groupValue: idOfPaymentMethod,
                      onChanged: (val) {
                        setState(() {
                          radioButtonItemOfPaymentMethod = 'Credit Payment';
                          idOfPaymentMethod = 2;
                          // cusPriceV = false;
                        });
                      },
                    ),
                    Text(
                      'Credit Payment',
                      style: new TextStyle(fontSize: 17.0, color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      activeColor: colorDark,
                      value: 3,
                      groupValue: idOfPaymentMethod,
                      onChanged: (val) {
                        setState(() {
                          radioButtonItemOfPaymentMethod = 'Partial Payment';
                          idOfPaymentMethod = 3;
                          // cusPriceV = true;
                        });
                      },
                    ),
                    Text(
                      'Partial Payment',
                      style: new TextStyle(fontSize: 17.0, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        idOfPaymentMethod != 2
            ? Padding(
                padding: const EdgeInsets.only(top: 18, bottom: 0, left: 18),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "$radioButtonItemOfPaymentMethod Method",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            : Container(),
        idOfPaymentMethod != 2 ? advanceOptions() : Container(),
        idOfPaymentMethod != 2
            ? SizedBox(
                height: 22,
              )
            : Container(),
        idOfPaymentMethod != 2 && idOfAdvance != 4
            ? showAdvanceField()
            : Container(),
      ],
    );
  }

  advanceOptions() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        // height: 46,
        width: 600,
        decoration: BoxDecoration(
            color: colorCardWhite,
            border: Border.all(width: 0.5, color: grey),
            borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.only(left: 18, right: 18, top: 18),
        child: Row(
          children: [
            Row(
              children: [
                Radio(
                  activeColor: colorDark,
                  value: 1,
                  groupValue: idOfAdvance,
                  onChanged: (val) {
                    setState(() {
                      radioButtonItemOfAdvance = 'Cheque';
                      idOfAdvance = 1;
                      // cusPriceV = false;
                    });
                  },
                ),
                Text(
                  'Cheque',
                  style: new TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              width: 22,
            ),
            Row(
              children: [
                Radio(
                  activeColor: colorDark,
                  value: 2,
                  groupValue: idOfAdvance,
                  onChanged: (val) {
                    setState(() {
                      radioButtonItemOfAdvance = 'NEFT';
                      idOfAdvance = 2;
                      // cusPriceV = false;
                    });
                  },
                ),
                Text(
                  'NEFT',
                  style: new TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              width: 22,
            ),
            Row(
              children: [
                Radio(
                  activeColor: colorDark,
                  value: 3,
                  groupValue: idOfAdvance,
                  onChanged: (val) {
                    setState(() {
                      radioButtonItemOfAdvance = 'UPI';
                      idOfAdvance = 3;
                      // cusPriceV = true;
                    });
                  },
                ),
                Text(
                  'UPI',
                  style: new TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              width: 22,
            ),
            Row(
              children: [
                Radio(
                  activeColor: colorDark,
                  value: 4,
                  groupValue: idOfAdvance,
                  onChanged: (val) {
                    setState(() {
                      radioButtonItemOfAdvance = 'Cash';
                      idOfAdvance = 4;
                      // cusPriceV = true;
                    });
                  },
                ),
                Text(
                  'Cash',
                  style: new TextStyle(fontSize: 17.0, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showAdvanceField() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 177),
            child: titleTextField("Bank Name", bankNameController),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 144),
            child: titleTextField("$radioButtonItemOfAdvance Number",
                bankDetailsNumberController),
          ),
        ),
      ],
    );
  }

  Future<void> getImage() async {
    assetImage = pw.MemoryImage(
      (await rootBundle.load('images/logo.png')).buffer.asUint8List(),
    );
  }

  pw.Widget bottomPart() {
    return pw.Align(
      alignment: pw.Alignment.bottomCenter,
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Padding(
            padding: pw.EdgeInsets.only(left: 4),
            child: pw.Text(
              "Breathe Medical Systems Private Limited",
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Divider(
            thickness: 1,
          ),
          pw.Text(
            "15, hariom nagar pandesara, near govalak road, Surat-394210, Gujarat, India",
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text("Phone : 7575819898 / 7575889898",
              style: pw.TextStyle(fontSize: 8)),
        ],
      ),
    );
  }

  String getSubTotal1(int index) {
    String tt =
        "${double.parse(productPriceArray[index]) * double.parse(productQuantityArray[index])}";
    print("TT Subtotal :: $tt");
    productSubtotalArray.add(tt);
    totalFinal = getTotalFinal();
    return tt;
  }

  String getTotalFinal() {
    double tt = 0;
    for (int i = 0; i < productSubtotalArray.length; i++) {
      tt = tt + double.parse(productSubtotalArray[i]);
      if (i == productSubtotalArray.length - 1) {
        double gst = (tt * double.parse(gstPercentageController.text)) / 100;
        tt = tt + gst;
        print("Final TOtal :: $tt");
        return tt.toString();
      }
    }
  }

  String getCsgtAmt() {
    double tt = (double.parse(gstPercentageController.text) /
            2 *
            double.parse(totalFinal)) /
        100;
    return tt.toString();
  }

  String getIgstAmt() {
    double tt = (double.parse(gstPercentageController.text) *
            double.parse(totalFinal)) /
        100;
    return tt.toString();
  }
}
