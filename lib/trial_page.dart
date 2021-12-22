import 'package:erp_software/globalVariable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrialPage extends StatefulWidget {
  const TrialPage({Key key}) : super(key: key);

  @override
  _TrialPageState createState() => _TrialPageState();
}

class _TrialPageState extends State<TrialPage> {
  double dividerHeight = 342;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 33, left: 144, right: 144),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      "INVOICE",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 44,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        // color: Color(0xfff2f2f2),
                        border: Border.all(width: 1, color: colorBlack5),
                        borderRadius: BorderRadius.circular(0)),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(child: leftSidePdf()),
                              Container(
                                  width: 0,
                                  height: dividerHeight,
                                  margin: EdgeInsets.zero,
                                  child: VerticalDivider(
                                    color: colorBlack5,
                                    thickness: 1,
                                  )),
                              Expanded(child: rightSidePdf()),
                            ],
                          ),
                        ),
                        Divider(
                          height: 0,
                          thickness: 1,
                          color: colorBlack5,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        tableLayout(),
                        Divider(
                          thickness: 1,
                          color: colorBlack5,
                        ),
                        ListView.builder(
                            itemCount: 4,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  containTableLayout(index),
                                  index == 3
                                      ? SizedBox(
                                          height: 6,
                                        )
                                      : Divider(
                                          thickness: 1,
                                          color: colorBlack5,
                                        ),
                                ],
                              );
                            }),
                        Divider(
                          thickness: 1,
                          color: colorBlack5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(" "),
                              ),
                              flex: 5,
                            ),
                            Expanded(
                              child: Text(
                                "Total",
                                textAlign: TextAlign.right,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              flex: 30,
                            ),
                            Expanded(
                              child: Text(" "),
                              flex: 10,
                            ),
                            Expanded(
                              child: Text(" "),
                              flex: 6,
                            ),
                            Expanded(
                              child: Text(" "),
                              flex: 9,
                            ),
                            Expanded(
                              child: Text(" "),
                              flex: 20,
                            ),
                            Expanded(
                              child: Text(
                                "4632000",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              flex: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  "images/logo.png",
                  width: 133,
                  height: 66,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  leftSidePdf() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "Breathe Medial Systems Pvt. Ltd",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "15, hariom nagar pandesara,\nnear govalak road,\nSurat-394210, Gujarat, India",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Divider(
            color: colorBlack5,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "Consignee",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "Shlok International",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "15, hariom nagar pandesara,\nnear govalak road,\nSurat-394210, Gujarat, India",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Divider(
            color: colorBlack5,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "Buyer (if other than consignee)",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "Shlok International",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "15, hariom nagar pandesara,\nnear govalak road,\nSurat-394210, Gujarat, India",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  rightSidePdf() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: rightSide1()),
          Container(
              width: 0,
              height: dividerHeight,
              margin: EdgeInsets.zero,
              child: VerticalDivider(
                color: colorBlack5,
                thickness: 1,
              )),
          Expanded(child: rightSide2()),
        ],
      ),
    );
  }

  rightSide1() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            "Invoice No.",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            getRandomInt(4),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(
          color: colorBlack5,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            "Invoice No.",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            getRandomInt(4),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(
          color: colorBlack5,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            "Invoice No.",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            getRandomInt(4),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(
          color: colorBlack5,
          thickness: 1,
        ),
      ],
    );
  }

  rightSide2() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            "Invoice No.",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            getRandomInt(4),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(
          color: colorBlack5,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            "Invoice No.",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            getRandomInt(4),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(
          color: colorBlack5,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            "Invoice No.",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            getRandomInt(4),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(
          color: colorBlack5,
          thickness: 1,
        ),
      ],
    );
  }

  tableLayout() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text("Sr.No."),
          ),
          flex: 5,
        ),
        Expanded(
          child: Text("Description of Goods"),
          flex: 30,
        ),
        Expanded(
          child: Text("HSN/SAC"),
          flex: 10,
        ),
        Expanded(
          child: Text("GST Rate"),
          flex: 6,
        ),
        Expanded(
          child: Text("Quantity"),
          flex: 9,
        ),
        Expanded(
          child: Text("Rate"),
          flex: 20,
        ),
        Expanded(
          child: Text("Amount"),
          flex: 20,
        ),
      ],
    );
  }

  Widget containTableLayout(int index) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text("1"),
          ),
          flex: 5,
        ),
        Expanded(
          child: Text("Description of Goods are here and there"),
          flex: 30,
        ),
        Expanded(
          child: Text("123666542151"),
          flex: 10,
        ),
        Expanded(
          child: Text("12%"),
          flex: 6,
        ),
        Expanded(
          child: Text("26"),
          flex: 9,
        ),
        Expanded(
          child: Text("156200"),
          flex: 20,
        ),
        Expanded(
          child: Text("3654201"),
          flex: 20,
        ),
      ],
    );
  }
}
// return pw.Column(
//   children: [
//     pw.Row(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Expanded(
//           child: pw.Column(
//             mainAxisSize: pw.MainAxisSize.min,
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             mainAxisAlignment: pw.MainAxisAlignment.start,
//             children: [
//               pw.Text(
//                 "Breath Medical System",
//                 style: pw.TextStyle(
//                     fontSize: 16,
//                     fontWeight: pw.FontWeight.bold,
//                     color: PdfColor.fromHex("#ECBF1F")),
//               ),
//               pw.SizedBox(height: 12),
//               pw.Text(
//                 "15, hariom nagar pandesara,\nnear govalak road,\nSurat-394210, Gujarat, India",
//                 style: pw.TextStyle(fontSize: 12),
//               ),
//               pw.SizedBox(height: 12),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Container(
//                       color: PdfColor.fromHex("#404145"),
//                       padding: pw.EdgeInsets.only(left: 12),
//                       child: pw.Text(
//                         "BILL TO",
//                         style: pw.TextStyle(
//                           color: PdfColor.fromHex("#FFFFFF"),
//                         ),
//                       ),
//                     ),
//                   ),
//                   pw.SizedBox(width: 22),
//                 ],
//               ),
//               pw.SizedBox(height: 12),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Container(
//                       // color: PdfColor.fromHex("#404145"),
//                       child: pw.Text(
//                         "${customerDetailsJson["name"]}\n${customerDetailsJson["com_name"]}\n${customerDetailsJson["address"]}\n${customerDetailsJson["city"]} ${customerDetailsJson["state"]}\n${customerDetailsJson["email"]}",
//                         style: pw.TextStyle(),
//                       ),
//                     ),
//                   ),
//                   pw.SizedBox(width: 22),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         pw.Expanded(
//           child: pw.Column(
//             mainAxisSize: pw.MainAxisSize.min,
//             mainAxisAlignment: pw.MainAxisAlignment.start,
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Padding(
//                 padding: pw.EdgeInsets.only(left: 22),
//                 child: pw.Text(
//                   billCount == 1 ? "PROFORMA INVOICE" : "INVOICE",
//                   style: pw.TextStyle(
//                       fontSize: 18, fontWeight: pw.FontWeight.bold),
//                 ),
//               ),
//               pw.SizedBox(height: 63),
//               pw.Row(
//                 children: [
//                   pw.SizedBox(width: 22),
//                   pw.Expanded(
//                     child: pw.Container(
//                       color: PdfColor.fromHex("#404145"),
//                       child: pw.Center(
//                         child: pw.Text(
//                           "INVOICE #",
//                           style: pw.TextStyle(
//                             color: PdfColor.fromHex("#FFFFFF"),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   pw.SizedBox(height: 12),
//                   pw.Expanded(
//                     child: pw.Container(
//                       color: PdfColor.fromHex("#404145"),
//                       child: pw.Center(
//                         child: pw.Text(
//                           "DATE",
//                           style: pw.TextStyle(
//                             color: PdfColor.fromHex("#FFFFFF"),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 12),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Container(
//                       // color: PdfColor.fromHex("#404145"),
//                       child: pw.Center(
//                         child: pw.Text(
//                           "204",
//                           style: pw.TextStyle(),
//                         ),
//                       ),
//                     ),
//                   ),
//                   pw.SizedBox(height: 12),
//                   pw.Expanded(
//                     child: pw.Container(
//                       // color: PdfColor.fromHex("#404145"),
//                       child: pw.Center(
//                         child: pw.Text(
//                           "$dateString",
//                           style: pw.TextStyle(),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         )
//       ],
//     ),
//     pw.SizedBox(height: 22),
//     pw.ListView.builder(
//         itemCount: 2,
//         itemBuilder: (context, index) {
//           return index == 0
//               ? pw.Row(
//                   children: [
//                     pw.Expanded(
//                       flex: 4,
//                       child: pw.Container(
//                         color: PdfColor.fromHex("#404145"),
//                         child: pw.Text(
//                           "DESCRIPTION",
//                           style: pw.TextStyle(
//                             color: PdfColor.fromHex("#FFFFFF"),
//                           ),
//                         ),
//                       ),
//                     ),
//                     pw.SizedBox(height: 12),
//                     pw.Expanded(
//                       flex: 1,
//                       child: pw.Container(
//                         color: PdfColor.fromHex("#404145"),
//                         child: pw.Center(
//                           child: pw.Text(
//                             "QTY",
//                             style: pw.TextStyle(
//                               color: PdfColor.fromHex("#FFFFFF"),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     pw.SizedBox(height: 12),
//                     pw.Expanded(
//                       flex: 2,
//                       child: pw.Container(
//                         color: PdfColor.fromHex("#404145"),
//                         child: pw.Center(
//                           child: pw.Text(
//                             "UNIT PRICE",
//                             style: pw.TextStyle(
//                               color: PdfColor.fromHex("#FFFFFF"),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     pw.SizedBox(height: 12),
//                     pw.Expanded(
//                       flex: 3,
//                       child: pw.Container(
//                         color: PdfColor.fromHex("#404145"),
//                         child: pw.Center(
//                           child: pw.Text(
//                             "AMOUNT",
//                             style: pw.TextStyle(
//                               color: PdfColor.fromHex("#FFFFFF"),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               : pw.Padding(
//                   padding: const pw.EdgeInsets.only(top: 8),
//                   child: pw.Column(
//                     children: [
//                       pw.Row(
//                         children: [
//                           pw.Expanded(
//                             flex: 4,
//                             child: pw.Container(
//                               // color: PdfColor.fromHex("#404145"),
//                               child: pw.Text(
//                                 "$productNameDropdown",
//                                 style: pw.TextStyle(
//                                     // color: PdfColor.fromHex("#FFFFFF"),
//                                     ),
//                               ),
//                             ),
//                           ),
//                           pw.SizedBox(height: 12),
//                           pw.Expanded(
//                             flex: 1,
//                             child: pw.Container(
//                               // color: PdfColor.fromHex("#404145"),
//                               child: pw.Center(
//                                 child: pw.Text(
//                                   "${qntController.text}",
//                                   style: pw.TextStyle(
//                                       // color: PdfColor.fromHex("#FFFFFF"),
//                                       ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           pw.SizedBox(height: 12),
//                           pw.Expanded(
//                             flex: 2,
//                             child: pw.Container(
//                               // color: PdfColor.fromHex("#404145"),
//                               child: pw.Center(
//                                 child: pw.Text(
//                                   "${priceController.text}",
//                                   style: pw.TextStyle(
//                                       // color: PdfColor.fromHex("#FFFFFF"),
//                                       ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           pw.SizedBox(height: 12),
//                           pw.Expanded(
//                             flex: 3,
//                             child: pw.Container(
//                               // color: PdfColor.fromHex("#404145"),
//                               child: pw.Center(
//                                 child: pw.Text(
//                                   getQntMultiplicationText(),
//                                   style: pw.TextStyle(
//                                       // color: PdfColor.fromHex("#FFFFFF"),
//                                       ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       pw.Divider(
//                         thickness: 0.6,
//                       ),
//                     ],
//                   ),
//                 );
//         }),
//     pw.Row(
//       children: [
//         pw.Expanded(
//           flex: 6,
//           child: pw.Container(),
//         ),
//         pw.Expanded(
//           flex: 4,
//           child: pw.Row(children: [
//             pw.Expanded(
//               child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text("SUBTOTAL"),
//                     pw.Text("GST %"),
//                     pw.Text("GST"),
//                     pw.SizedBox(height: 4),
//                     pw.Text("TOTAL",
//                         style: pw.TextStyle(
//                             fontWeight: pw.FontWeight.bold)),
//                   ]),
//             ),
//             pw.Expanded(
//               child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.end,
//                   children: [
//                     pw.Text(getQntMultiplicationText()),
//                     pw.Text("18%"),
//                     pw.Text(makeGstCalculation(1)),
//                     pw.SizedBox(height: 4),
//                     pw.Text(makeGstCalculation(2),
//                         style: pw.TextStyle(
//                             fontWeight: pw.FontWeight.bold)),
//                   ]),
//             ),
//           ]),
//         ),
//       ],
//     )
//   ],
// ); // Center
