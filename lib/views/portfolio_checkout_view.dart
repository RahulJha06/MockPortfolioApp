import 'package:flutter/material.dart';
import 'package:portfolio_monitor/models/company_action.dart';
import 'package:portfolio_monitor/services/nifty_company_profile.dart';
import 'package:portfolio_monitor/view_models/checkout_viewmodel.dart';
import 'package:portfolio_monitor/view_models/portfolio.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatefulWidget {
  bool isPanelOpened;
  CheckOut({this.isPanelOpened});
  @override
  State<StatefulWidget> createState() {
    return _InternalState();
  }
}

class _InternalState extends State<CheckOut> {
  bool _isPanelOpened;
  @override
  void initState() {
    super.initState();
    _isPanelOpened = this.widget.isPanelOpened;
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isPanelOpened = this.widget.isPanelOpened;
  }

  Widget _buildListItem(CompanyAction C) {
    Widget status;
    if (C.company.change > 0)
      status = Icon(Icons.arrow_drop_down_outlined, color: Colors.red);
    else
      status = Icon(Icons.arrow_drop_up_outlined, color: Colors.green);

    Color color;
    if (C.action == "buy")
      color = Color(0xAAA2ED88);
    else
      color = Color(0xAAFCA18D);
    return Container(
      color: color,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Expanded(
            flex: 1,
            child: Image(
              image: NetworkImage(C.company.image),
            )),
        Expanded(
            flex: 1,
            child: Text(
              C.company.name,
              textAlign: TextAlign.center,
            )),
        Expanded(
            flex: 1,
            child: Text(
              NiftyCompanyProfileAPI.getCurrentPrice(C.company.name).toString(),
              textAlign: TextAlign.center,
            )),
        Expanded(
          flex: 1,
          child: Text(
            C.company.change.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      ]),
    );
  }

  Widget _buildColumn(List<CompanyAction> data) {
    return ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) => Divider(),
        itemCount: data.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) => _buildListItem(data[index]));
  }

  Widget _body;

  @override
  Widget build(BuildContext context) {
    if (!_isPanelOpened) {
      _body = Center(
        heightFactor: 4,
        child: Text(
          "Swipe up to view your profile",
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
        ),
      );
    } else {
      _body = Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    "John Doe(P1)",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: Container(
                  // height: 400,
                  child: _buildColumn(
                      Provider.of<ShortList>(context, listen: false).shortList),
                ),
              ),
            ],
          ),
          Positioned.fill(
            bottom: 10,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                color: Color(0xAAE0E0E0),
                child: Text("Confirm"),
                onPressed: () {
                  Portfolio portfolio =
                      Provider.of<Portfolio>(context, listen: false);
                  ShortList shortList =
                      Provider.of<ShortList>(context, listen: false);
                  List<CompanyAction> data = shortList.shortList;
                  SnackBar snackBar = SnackBar(content: Text("Error"));
                  for (int i = 0; i < data.length; i++) {
                    //orders from the shortList are processed serially
                    if (data[i].action == "buy") {
                      if (portfolio.portfolioSize < portfolio.portfolioLimit) {
                        data[i].company.buyingPrice =
                            data[i].company.currentPrice;
                        portfolio.addToPortfolio(data[i].company);
                      } else {
                        Scaffold.of(context).showSnackBar(snackBar);
                        for (int j = 0; j < i; j++)
                          shortList.removeFromList(data[j].company);
                        break;
                      }
                    } else if (data[i].action == "sell") {
                      data[i].company.sellingPrice =
                          data[i].company.currentPrice;
                      //the differnce between selling price and buying Price for the company can be used to calculate the profits if needed
                      portfolio.removeFromPortfolio(data[i].company);
                    }
                  }
                },
              ),
            ),
          ),
        ],
      );
    }
    return Scaffold(body: _body);
  }
}
