import 'package:flutter/material.dart';

import '../globalVariable.dart';
import 'Sell Purchase/purchase_page.dart';
import 'Sell Purchase/sell_page.dart';

class SellPurchasePage extends StatefulWidget {
  const SellPurchasePage({Key key}) : super(key: key);

  @override
  _SellPurchasePageState createState() => _SellPurchasePageState();
}

class _SellPurchasePageState extends State<SellPurchasePage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage == 1
          ? SellPage()
          : currentPage == 2
              ? PurchasePage()
              : Column(
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
                              Icon(Icons.sell_rounded,
                                  size: 66, color: colorBlack5),
                              Text(
                                "Sell",
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
                            // getAllProductsName();
                            // getAllFinalProducts();
                            setState(() {
                              currentPage = 2;
                            });
                          },
                          child: Column(
                            children: [
                              Icon(Icons.money_sharp,
                                  size: 66, color: colorBlack5),
                              Text(
                                "Purchase",
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
    );
  }
}
