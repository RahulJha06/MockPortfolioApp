import 'package:flutter/material.dart';
import 'package:portfolio_monitor/models/company_profile.dart';
import 'package:portfolio_monitor/view_models/portfolio.dart';
import 'package:provider/provider.dart';

List<Map<String, dynamic>> _data = [
  {
    "image": "1234",
    "cName": "TCS",
    "cIndustry": "Tech",
    "cPrice": "Select by random%",
    "changeInValue": 5,
  },
  {
    "image": "1234",
    "cName": "TCS",
    "cIndustry": "Tech",
    "cPrice": "Select by random%",
    "changeInValue": 5,
  },
  {
    "image": "1234",
    "cName": "TCS",
    "cIndustry": "Tech",
    "cPrice": "Select by random%",
    "changeInValue": 5,
  },
  {
    "image": "1234",
    "cName": "TCS",
    "cIndustry": "Tech",
    "cPrice": "Select by random%",
    "changeInValue": 5,
  },
  {
    "image": "1234",
    "cName": "TCS",
    "cIndustry": "Tech",
    "cPrice": "Select by random%",
    "changeInValue": 5,
  },
  {
    "image": "1234",
    "cName": "TCS",
    "cIndustry": "Tech",
    "cPrice": "Select by random%",
    "changeInValue": 5,
  },
  {
    "image": "1234",
    "cName": "TCS",
    "cIndustry": "Tech",
    "cPrice": "Select by random%",
    "changeInValue": 5,
  },
  {
    "image": "1234",
    "cName": "TCS",
    "cIndustry": "Tech",
    "cPrice": "Select by random%",
    "changeInValue": 5
  },
  {
    "image": "1234",
    "cName": "TCS",
    "cIndustry": "Tech",
    "cPrice": "Select by random%",
    "changeInValue": 5
  },
  {
    "image": "1234",
    "cName": "TCS",
    "cIndustry": "Tech",
    "cPrice": "Select by random%",
    "changeInValue": 5
  }
];

class DetailView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InternalState();
  }
}

class _InternalState extends State<DetailView> {
  Widget _buildListItem(Company C) {
    double val = C.buyingPrice - C.currentPrice;
    Icon status;
    if (val < 0)
      status = Icon(Icons.arrow_circle_down_outlined, color: Colors.red);
    else
      status = Icon(Icons.arrow_circle_up_outlined, color: Colors.green);
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(flex: 1, child: Image(image: NetworkImage(C.image))),
              Expanded(flex: 2, child: Text(C.name)),
              Expanded(flex: 1, child: Text(C.buyingPrice.toString())),
              Expanded(
                flex: 1,
                child: Text(C.change.toString()),
              ),
              Expanded(
                flex: 1,
                child: status,
              )
            ],
          ),
          Divider(thickness: 2),
        ],
      ),
    );
  }

  List<Widget> _buildColumn(List data) {
    List<Widget> _displayData = <Widget>[];
    print(_data.length);
    _displayData = data.map((e) => (_buildListItem(e))).toList();
    return _displayData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Consumer<Portfolio>(
          builder: (context, value, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.all(50),
                      child: Text(
                        "John Doe(P1)",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child:
                        Text(value.portfolioPerformance.toStringAsPrecision(3)),
                  )
                ],
              ),
              Container(
                // padding: EdgeInsets.all(10),
                child: Column(
                  children: _buildColumn(value.portfolio),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          bottom: 10,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: RaisedButton(
              child: Text("Dismiss"),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ]),
    );
  }
}
