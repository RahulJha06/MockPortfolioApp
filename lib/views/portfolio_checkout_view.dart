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
    return Container(
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

  List<Widget> _buildColumn(List<CompanyAction> data) {
    List<Widget> _displayData = data.map((e) => _buildListItem(e)).toList();
    return _displayData;
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
              Center(
                heightFactor: 3,
                child: Text(
                  "John Doe(P1)",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
              ),
              Container(
                // padding: EdgeInsets.all(10),
                child: Column(
                  children: _buildColumn(
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
