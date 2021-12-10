import 'dart:convert';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:dustbin/Widgets/button_widget.dart';
import 'package:dustbin/globalVariable.dart';
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
  String rawMaterialDropdown = "Select";
  String productNameDropdown = "Select";
  String filePath = " ";
  List<String> rawMaterialList = ["Select"];
  List<String> productNameList = ["Select"];
  String dateString = "DD-MM-YYYY";
  String milli = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomer();
    getAllFinalProducts();
    // pdfTrial();
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
                        child: Container(
                          height: 26,
                          width: 333,
                          decoration: BoxDecoration(
                              color: Color(0xfff2f2f2),
                              // border: Border.all(width: 1, color: grey),
                              borderRadius: BorderRadius.circular(0)),
                          margin: EdgeInsets.only(left: 18, right: 18, top: 6),
                          padding: EdgeInsets.only(left: 14),
                          child: DropdownButton<String>(
                            value: productNameDropdown,
                            dropdownColor: colorCard,
                            elevation: 0,
                            underline: Container(),
                            icon: Container(),
                            onChanged: (String newValue) {
                              setState(() {
                                productNameDropdown = newValue;
                              });
                            },
                            items: productNameList
                                .map<DropdownMenuItem<String>>((String value) {
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
                                              bottomRight: Radius.circular(0))),
                                      margin:
                                          EdgeInsets.only(left: 0, right: 0),
                                      child: Center(
                                          child: Text(
                                        "Add Date",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
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
                          margin: EdgeInsets.only(left: 18, right: 18, top: 6),
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
                                .map<DropdownMenuItem<String>>((String value) {
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
                  child: titleTextField("Remark (Optional)", remarkController),
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
                    buttonText: "Kaccha Bill",
                    function: () {
                      final bytes = Io.File('$filePath').readAsBytesSync();

                      String img64 = base64Encode(bytes);
                      final body = {
                        "name": "$productNameDropdown",
                        "customer_name": "$rawMaterialDropdown",
                        "date": "${dateString}",
                        "gst": "${gstController.text}",
                        "photo": "$img64",
                      };
                      Uri url =
                          Uri.parse(APIUrl.mainUrl + APIUrl.postKacchaBill);
                      post(url, body: body).then((value) {
                        print("postKacchaBill :: ${value.body}");
                      });
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
                      final bytes = Io.File('$filePath').readAsBytesSync();

                      String img64 = base64Encode(bytes);
                      final body = {
                        "name": "$productNameDropdown",
                        "customer_name": "$rawMaterialDropdown",
                        "date": "$dateString",
                        "gst": "${gstController.text}",
                        "photo": "$img64",
                      };
                      Uri url =
                          Uri.parse(APIUrl.mainUrl + APIUrl.postPakkaBill);
                      post(url, body: body).then((value) {
                        print("postPakkaBill :: ${value.body}");
                      });
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
        ],
      ),
    );
  }

  void getCustomer() {
    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.getCustomer);
    get(url).then((value) {
      print("Customer :: ${value.body}");
      final jsonData = jsonDecode(value.body);
      print("Len :: ${getJsonLength(value.body)}");

      for (int i = 0; i < getJsonLength(value.body); i++) {
        rawMaterialList.add(jsonData[i]["name"]);
        setState(() {});
      }
      setState(() {});
    });
  }

  void getAllFinalProducts() {
    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.getFinalProduct);
    get(url).then((value) {
      print("All Finish Products :: ${value.body}");
      int len = getJsonLength(jsonDecode(value.body));
      final jsonData = jsonDecode(value.body);
      print("Len :: $len");
      for (int i = 0; i < len; i++) {
        setState(() {
          productNameList.add(jsonData[i]["name"]);
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

  uploadFunction() {}

  Future<void> pdfTrial() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.min,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Breath Medical System",
                            style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex("#ECBF1F")),
                          ),
                          pw.SizedBox(height: 12),
                          pw.Text(
                            "15, hariom nagar pandesara,\nnear govalak road,\nSurat-394210, Gujarat, India",
                            style: pw.TextStyle(fontSize: 12),
                          ),
                          pw.SizedBox(height: 12),
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Container(
                                  color: PdfColor.fromHex("#404145"),
                                  padding: pw.EdgeInsets.only(left: 12),
                                  child: pw.Text(
                                    "BILL TO",
                                    style: pw.TextStyle(
                                      color: PdfColor.fromHex("#FFFFFF"),
                                    ),
                                  ),
                                ),
                              ),
                              pw.SizedBox(width: 22),
                            ],
                          ),
                          pw.SizedBox(height: 12),
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Container(
                                  // color: PdfColor.fromHex("#404145"),
                                  child: pw.Text(
                                    "Name\nCompany Name\nAddress\nSurat Gujarat 394221\nEmail",
                                    style: pw.TextStyle(),
                                  ),
                                ),
                              ),
                              pw.SizedBox(width: 22),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.min,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.only(left: 22),
                            child: pw.Text(
                              "INVOICE",
                              style: pw.TextStyle(
                                  fontSize: 18, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.SizedBox(height: 63),
                          pw.Row(
                            children: [
                              pw.SizedBox(width: 22),
                              pw.Expanded(
                                child: pw.Container(
                                  color: PdfColor.fromHex("#404145"),
                                  child: pw.Center(
                                    child: pw.Text(
                                      "INVOICE #",
                                      style: pw.TextStyle(
                                        color: PdfColor.fromHex("#FFFFFF"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              pw.SizedBox(height: 12),
                              pw.Expanded(
                                child: pw.Container(
                                  color: PdfColor.fromHex("#404145"),
                                  child: pw.Center(
                                    child: pw.Text(
                                      "DATE",
                                      style: pw.TextStyle(
                                        color: PdfColor.fromHex("#FFFFFF"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 12),
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Container(
                                  // color: PdfColor.fromHex("#404145"),
                                  child: pw.Center(
                                    child: pw.Text(
                                      "204",
                                      style: pw.TextStyle(),
                                    ),
                                  ),
                                ),
                              ),
                              pw.SizedBox(height: 12),
                              pw.Expanded(
                                child: pw.Container(
                                  // color: PdfColor.fromHex("#404145"),
                                  child: pw.Center(
                                    child: pw.Text(
                                      "11-11-2021",
                                      style: pw.TextStyle(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                pw.SizedBox(height: 22),
                pw.ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return index == 0
                          ? pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 4,
                                  child: pw.Container(
                                    color: PdfColor.fromHex("#404145"),
                                    child: pw.Text(
                                      "DESCRIPTION",
                                      style: pw.TextStyle(
                                        color: PdfColor.fromHex("#FFFFFF"),
                                      ),
                                    ),
                                  ),
                                ),
                                pw.SizedBox(height: 12),
                                pw.Expanded(
                                  flex: 1,
                                  child: pw.Container(
                                    color: PdfColor.fromHex("#404145"),
                                    child: pw.Center(
                                      child: pw.Text(
                                        "QTY",
                                        style: pw.TextStyle(
                                          color: PdfColor.fromHex("#FFFFFF"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                pw.SizedBox(height: 12),
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Container(
                                    color: PdfColor.fromHex("#404145"),
                                    child: pw.Center(
                                      child: pw.Text(
                                        "UNIT PRICE",
                                        style: pw.TextStyle(
                                          color: PdfColor.fromHex("#FFFFFF"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                pw.SizedBox(height: 12),
                                pw.Expanded(
                                  flex: 3,
                                  child: pw.Container(
                                    color: PdfColor.fromHex("#404145"),
                                    child: pw.Center(
                                      child: pw.Text(
                                        "AMOUNT",
                                        style: pw.TextStyle(
                                          color: PdfColor.fromHex("#FFFFFF"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : pw.Padding(
                              padding: const pw.EdgeInsets.only(top: 8),
                              child: pw.Column(
                                children: [
                                  pw.Row(
                                    children: [
                                      pw.Expanded(
                                        flex: 4,
                                        child: pw.Container(
                                          // color: PdfColor.fromHex("#404145"),
                                          child: pw.Text(
                                            "7 inch display baby warmer",
                                            style: pw.TextStyle(
                                                // color: PdfColor.fromHex("#FFFFFF"),
                                                ),
                                          ),
                                        ),
                                      ),
                                      pw.SizedBox(height: 12),
                                      pw.Expanded(
                                        flex: 1,
                                        child: pw.Container(
                                          // color: PdfColor.fromHex("#404145"),
                                          child: pw.Center(
                                            child: pw.Text(
                                              "2",
                                              style: pw.TextStyle(
                                                  // color: PdfColor.fromHex("#FFFFFF"),
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      pw.SizedBox(height: 12),
                                      pw.Expanded(
                                        flex: 2,
                                        child: pw.Container(
                                          // color: PdfColor.fromHex("#404145"),
                                          child: pw.Center(
                                            child: pw.Text(
                                              "16000",
                                              style: pw.TextStyle(
                                                  // color: PdfColor.fromHex("#FFFFFF"),
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      pw.SizedBox(height: 12),
                                      pw.Expanded(
                                        flex: 3,
                                        child: pw.Container(
                                          // color: PdfColor.fromHex("#404145"),
                                          child: pw.Center(
                                            child: pw.Text(
                                              "32000",
                                              style: pw.TextStyle(
                                                  // color: PdfColor.fromHex("#FFFFFF"),
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  pw.Divider(
                                    thickness: 0.6,
                                  ),
                                ],
                              ),
                            );
                    }),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 6,
                      child: pw.Container(),
                    ),
                    pw.Expanded(
                      flex: 4,
                      child: pw.Row(children: [
                        pw.Expanded(
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("SUBTOTAL"),
                                pw.Text("GST %"),
                                pw.Text("GST"),
                                pw.SizedBox(height: 4),
                                pw.Text("TOTAL",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ]),
                        ),
                        pw.Expanded(
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text("32000"),
                                pw.Text("18%"),
                                pw.Text("5760"),
                                pw.SizedBox(height: 4),
                                pw.Text("37760",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ]),
                        ),
                      ]),
                    ),
                  ],
                )
              ],
            ); // Center
          }),
    );

    List<int> bytes = await pdf.save();
    // Uri url = Uri.parse("F:\\FILES\\Flutter Project\\ERP Software");
    final appDocDir = Directory.current.path;
    print("Path Final :: $appDocDir");
    final milli = "trial";
    // final path = (await ExtStorage.getExternalStoragePublicDirectory(
    //     ExtStorage.DIRECTORY_DOWNLOADS));
    // print("Path :: $path");
    final file1 = File('$appDocDir/$milli.pdf');
    await file1.writeAsBytes(bytes, flush: true);
    OpenFile.open('$appDocDir/$milli.pdf');

    // final file1 = File('Desktop/trialPdfRahul.pdf');
    // await file1.writeAsBytes(bytes, flush: true);
    // final path = (await ExtStorage.getExternalStoragePublicDirectory(
    //     ExtStorage.DIRECTORY_DOWNLOADS));
    // final file = File("example.pdf");
    // await file.writeAsBytes(await pdf.save());
  }
}
