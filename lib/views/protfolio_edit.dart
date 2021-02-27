import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:portfolio_monitor/models/company_profile.dart';
import 'package:portfolio_monitor/services/nifty_company_profile.dart';
import 'package:portfolio_monitor/view_models/checkout_viewmodel.dart';
import 'package:portfolio_monitor/view_models/portfolio.dart';
import 'package:portfolio_monitor/views/portfolio_checkout_view.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ManagePortfolio extends StatefulWidget {
  @override
  State<ManagePortfolio> createState() => _InternalState();
}

class _InternalState extends State<ManagePortfolio> {
  Widget _panel = CheckOut(
    isPanelOpened: false,
  );
  @override
  void init() {
    super.initState();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _panel = CheckOut(isPanelOpened: false);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShortList>(
      create: (_) => ShortList(),
      builder: (context, child) => child,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Portfolio'),
        ),
        body: SlidingUpPanel(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFFFFFFFF),
          margin: EdgeInsets.symmetric(horizontal: 2),
          panel: _panel,
          onPanelClosed: () {
            setState(() {
              _panel = CheckOut(
                isPanelOpened: false,
              );
            });
          },
          onPanelOpened: () {
            setState(() {
              _panel = Consumer<Portfolio>(
                builder: (context, value, child) => CheckOut(
                  isPanelOpened: true,
                ),
              );
            });
          },
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xAACACACA),
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: 90,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "You can select any 10 stocks from the list to create a portfolio",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 35,
                margin: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          //enabled: true,
                          //autofocus: true,
                          decoration: InputDecoration(
                              labelText: "Search",
                              suffixIcon: Icon(Icons.cancel),
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(width: 2, style: BorderStyle.solid),
                        ),
                        child: FlatButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Sort&Filter',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            print("Filterd");
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemBuilder: (context, index) =>
                            _buildListView(context, snapshot.data[index]),
                        itemCount: snapshot.data.length,
                      );
                    } else
                      return CircularProgressIndicator();
                  },
                  future: NiftyCompanyProfileAPI.getDummyCompanyProfile(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget actions;

  Widget _buildListComponentAction(
      BuildContext currentContext, Company C, Color _tileColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
                shape: new CircleBorder(
                    side: BorderSide(
                        width: 2,
                        color: Colors.green,
                        style: BorderStyle.solid)),
                onPressed: () {
                  setState(() {
                    actions:
                    Text("Bought");
                  });
                  Provider.of<ShortList>(currentContext, listen: false)
                      .addToList(C, "buy");
                },
                child: Text('Buy'))
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
                shape: new CircleBorder(
                  side: BorderSide(
                      style: BorderStyle.solid, color: Colors.red, width: 2),
                ),
                onPressed: () {
                  setState(() {
                    actions:
                    Text("Bought");
                  });
                  Provider.of<ShortList>(currentContext, listen: false)
                      .addToList(C, "sell");
                },
                child: Text('Sell'))
          ],
        )
      ],
    );
  }

  Widget _buildListView(BuildContext currentContext, Company data) {
    Color color = Color(0XAAE0E0E0);
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Color(0xAAE0E0E0)),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(bottom: 10, left: 5, right: 5, top: 10),
      child: ListTile(
        contentPadding: EdgeInsets.all(5),
        title: Text(data.name),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Text(data.industry),
          ),
          Text(
            data.currentPrice.toString(),
            style: TextStyle(color: Colors.black, fontSize: 16),
          )
        ]),
        leading: Container(
          margin: EdgeInsets.only(left: 7, bottom: 8),
          child: Image(
            image: NetworkImage(data.image),
          ),
        ),
        isThreeLine: true,
        trailing: _buildListComponentAction(currentContext, data, color),
      ),
    );
  }
}
