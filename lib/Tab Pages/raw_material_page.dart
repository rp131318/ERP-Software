import 'dart:convert';
import 'package:dustbin/Widgets/button_widget.dart';
import 'package:dustbin/Widgets/progressHud.dart';
import 'package:dustbin/globalVariable.dart';
import 'package:flutter/material.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:http/http.dart';
import 'dart:io' as Io;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../globalVariable.dart';

class RawMaterialPage extends StatefulWidget {
  @override
  _RawMaterialPageState createState() => _RawMaterialPageState();
}

class _RawMaterialPageState extends State<RawMaterialPage> {
  final controller = TextEditingController();
  final nameController = TextEditingController();
  final qntController = TextEditingController();
  final partNumberController = TextEditingController();
  final dateController = TextEditingController();
  var a = ["a", "b", "c", "d", "e"];
  var title = [
    "Sr. No.",
    "Name",
    "In",
    "Out",
    "Remaining",
    "Part Number",
    "Date",
    "Bill Photo"
  ];
  var name = [];
  var qnt = [];
  var partNumber = [];
  var photo = [];
  var date = [];
  var remaining = [];
  var outArray = [];
  String filePath = " ";
  Io.File result;
  bool isLoading = false;
  String dateString = "DD-MM-YYYY";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        isLoading: isLoading,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 18, left: 18),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Upload Raw Materials",
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
                    child: titleTextField("Quantity", qntController),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 144),
                    child: titleTextField("Part Number", partNumberController),
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
                      context: context,
                      buttonText: "Upload Bill",
                      isIcon: true,
                      widget: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "images/pdf.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
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

                        result = file.getFile();
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
            Padding(
              padding: const EdgeInsets.only(right: 166),
              child: Align(
                alignment: Alignment.topRight,
                child: ButtonWidget(
                  context: context,
                  widget: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  isIcon: true,
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
            name.length > 0
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 22, left: 0, right: 14),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 46.0,
                          columns: List.generate(title.length, (index) {
                            return DataColumn(
                                label: Text(title[index].toString()));
                          }),
                          rows: List.generate(
                              name.length, (index) => _getDataRow(index)),
                        ),
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
    );
  }

  DataRow _getDataRow(index) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text("${index + 1}")),
        DataCell(SizedBox(
          width: 200,
          child: Text("${name[index]}"),
        )),
        DataCell(Text("${qnt[index]}")),
        DataCell(Text("${outArray[index]}")),
        DataCell(Text("${remaining[index]}")),
        DataCell(Text("${partNumber[index]}")),
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

  uploadFunction() async {
    if (validateField(context, nameController) &&
        validateField(context, qntController) &&
        validateField(context, partNumberController)) {
      setState(() {
        isLoading = true;
      });
      final bytes = Io.File('$filePath').readAsBytesSync();

      String img64 = base64Encode(bytes);
      //upload to Database
      final body = {
        "name": "${nameController.text}",
        "part_number": "${partNumberController.text}",
        "quantity": "${qntController.text}",
        "in_date": "$dateString",
        "out": "0",
        "total": "${qntController.text}",
        "bill_photo": "$img64",
      };

      print("Raw Body :: $body");
      Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.uploadRaw);
      print("URL :: $url");

      await post(url, body: body).then((value) {
        print("Value :: ${value.body}");
      });
      nameController.clear();
      qntController.clear();
      partNumberController.clear();
      dateController.clear();
      setState(() {});
      getData();
    }
  }

  void getData() {
    name.clear();
    qnt.clear();
    partNumber.clear();
    date.clear();
    outArray.clear();
    remaining.clear();
    Uri url = Uri.parse(APIUrl.mainUrl + APIUrl.getRaw);
    get(url).then((value) {
      print("Raw Materials :: ${value.body}");
      final jsonData = jsonDecode(value.body);
      print("Len :: ${getJsonLength(value.body)}");
      for (int i = 0; i < getJsonLength(value.body); i++) {
        name.add(jsonData[i]["name"]);
        qnt.add(jsonData[i]["quantity"]);
        partNumber.add(jsonData[i]["part_number"]);
        date.add(jsonData[i]["in_date"]);
        photo.add(jsonData[i]["bill_photo"]);
        outArray.add(jsonData[i]["out"]);
        remaining.add(jsonData[i]["total"]);
        setState(() {
          isLoading = false;
        });
      }
      setState(() {});
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
