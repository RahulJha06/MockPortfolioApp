import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_monitor/models/company_profile.dart';
import 'package:portfolio_monitor/view_models/portfolio.dart';
import 'package:portfolio_monitor/views/portfolio_detail_view.dart';
import 'package:portfolio_monitor/views/protfolio_edit.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override  State<StatefulWidget> createState() => _InternalState();

}

class _InternalState extends State<Home> {
  Widget _decreasing = Icon(Icons.arrow_circle_down, color: Colors.red);
  Widget _increasing = Icon(Icons.arrow_circle_up, color: Colors.green);
  double _profilePerformace = 0.0;
  List<Widget> _values = <Widget>[];
  @override
  void initState() {
    setState(() {
      _profilePerformace = Provider.of<Portfolio>(context).portfolioPerformance;
    });
  }

  @override
  void didWidgetUpdate(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("Here");
    setState(() {
      _profilePerformace = Provider.of<Portfolio>(context).portfolioPerformance;
    });
  }

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
    _values = data.map((c) => _unitStockView(c)).toList();
    return Container(
      child: Card(
        margin: EdgeInsets.all(20),
        borderOnForeground: true,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: _values,
            ),
            Column(
              children: _values,
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
                  Text(_profilePerformace.toStringAsPrecision(3)),
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
          setState(() {
            _profilePerformace = Provider.of<Portfolio>(context, listen: false)
                .portfolioPerformance;
          });
        },
      ),
    );
  }
}
