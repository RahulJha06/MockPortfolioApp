import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_monitor/models/company_profile.dart';
import 'package:portfolio_monitor/view_models/portfolio.dart';
import 'package:portfolio_monitor/views/portfolio_detail_view.dart';
import 'package:portfolio_monitor/views/protfolio_edit.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InternalState();
}

class _InternalState extends State<Home> {
  Widget _decreasing = Icon(Icons.arrow_circle_down, color: Colors.red);
  Widget _increasing = Icon(Icons.arrow_circle_up, color: Colors.green);
  List<Widget> _col1 = <Widget>[];
  List<Widget> _col2 = <Widget>[];

  Widget _unitStockView(Company c) {
    double val = c.buyingPrice - c.currentPrice;
    Icon statusSymbol;
    if (val < 0)
      statusSymbol = _decreasing;
    else
      statusSymbol = _increasing;
    return Container(
      padding: EdgeInsets.all(2),
      child: Row(
        children: [
          Text(' - '),
          Text(
            c.name,
            textScaleFactor: 1.5,
          ),
          statusSymbol,
        ],
      ),
    );
  }

  Widget _buildInnerCard(List data) {
    int i = 0;
    _col1 = [];
    for (; i < data.length / 2; i++) _col1.add(_unitStockView(data[i]));
    int j = i;
    _col2 = [];
    for (; j < data.length; j++) _col2.add(_unitStockView(data[j]));
    return Container(
      child: Card(
        margin: EdgeInsets.all(20),
        borderOnForeground: true,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: _col1,
            ),
            Column(
              children: _col2,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Portfolio portfolio) {
    List<Company> companies = portfolio.portfolio;
    return FlatButton(
      padding: EdgeInsets.all(10),
      color: Color(0xFFFFFFFF),
      onPressed: () {
        showModalBottomSheet(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          isScrollControlled: true,
          context: context,
          builder: (context) => DetailView(),
        );
      },
      child: Card(
        color: Color(0xAAE0E0E0),
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('John Joe'),
                  Text(portfolio.portfolioPerformance.toStringAsPrecision(3)),
                ],
              ),
            ),
            Container(
              child: _buildInnerCard(companies),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCard(Provider.of<Portfolio>(context)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ManagePortfolio()));
        },
      ),
    );
  }
}
